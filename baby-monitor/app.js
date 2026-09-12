import { joinRoom } from 'https://esm.run/@trystero-p2p/torrent@0.25.4'

// Any unique string works here — no signup or server required for the
// BitTorrent signaling strategy, it just needs to be unique to this app
// so we don't accidentally join rooms from other Trystero apps.
const APP_ID = 'hanneslarsson-baby-monitor-v1'
const CODE_ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789' // no 0/O/1/I to avoid mix-ups

const els = {
  viewSelect: document.getElementById('view-select'),
  viewBaby: document.getElementById('view-baby'),
  viewParent: document.getElementById('view-parent'),
  btnBaby: document.getElementById('btn-baby'),
  btnParent: document.getElementById('btn-parent'),
  btnBack: document.getElementById('btn-back'),
  errorBanner: document.getElementById('error-banner'),

  babyCode: document.getElementById('baby-code'),
  babyStatusDot: document.getElementById('baby-status-dot'),
  babyStatusText: document.getElementById('baby-status-text'),
  babyMeterFill: document.getElementById('baby-meter-fill'),
  babyMute: document.getElementById('baby-mute'),
  babyStop: document.getElementById('baby-stop'),

  parentJoinForm: document.getElementById('parent-join-form'),
  parentCodeInput: document.getElementById('parent-code-input'),
  parentConnected: document.getElementById('parent-connected'),
  parentStatusDot: document.getElementById('parent-status-dot'),
  parentStatusText: document.getElementById('parent-status-text'),
  parentMeterFill: document.getElementById('parent-meter-fill'),
  parentVolume: document.getElementById('parent-volume'),
  parentStop: document.getElementById('parent-stop'),
  remoteAudio: document.getElementById('remote-audio')
}

let currentRoom = null
let wakeLock = null
let meterRafId = null
let audioCtx = null

function showView(view) {
  for (const v of [els.viewSelect, els.viewBaby, els.viewParent]) {
    v.hidden = v !== view
  }
  els.btnBack.hidden = view === els.viewSelect
}

function showError(message) {
  els.errorBanner.textContent = message
  els.errorBanner.hidden = false
}

function clearError() {
  els.errorBanner.hidden = true
  els.errorBanner.textContent = ''
}

function setStatus(dotEl, textEl, kind, text) {
  dotEl.classList.remove('status-waiting', 'status-connected', 'status-error')
  dotEl.classList.add(`status-${kind}`)
  textEl.textContent = text
}

function randomRoomCode(length = 6) {
  let code = ''
  const bytes = new Uint8Array(length)
  crypto.getRandomValues(bytes)
  for (let i = 0; i < length; i++) {
    code += CODE_ALPHABET[bytes[i] % CODE_ALPHABET.length]
  }
  return code
}

async function acquireWakeLock() {
  try {
    if ('wakeLock' in navigator) {
      wakeLock = await navigator.wakeLock.request('screen')
    }
  } catch {
    // Not fatal — the monitor keeps working, the screen may just dim.
  }
}

function releaseWakeLock() {
  if (wakeLock) {
    wakeLock.release().catch(() => {})
    wakeLock = null
  }
}

document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'visible' && currentRoom) {
    acquireWakeLock()
  }
})

function stopMeter() {
  if (meterRafId !== null) {
    cancelAnimationFrame(meterRafId)
    meterRafId = null
  }
}

function startMeter(stream, fillEl) {
  stopMeter()
  audioCtx ||= new (window.AudioContext || window.webkitAudioContext)()
  const source = audioCtx.createMediaStreamSource(stream)
  const analyser = audioCtx.createAnalyser()
  analyser.fftSize = 512
  analyser.smoothingTimeConstant = 0.6
  source.connect(analyser)
  const data = new Uint8Array(analyser.frequencyBinCount)

  const tick = () => {
    analyser.getByteFrequencyData(data)
    let sum = 0
    for (const v of data) sum += v
    const level = Math.min(1, (sum / data.length / 255) * 3.2)
    fillEl.style.width = `${Math.round(level * 100)}%`
    meterRafId = requestAnimationFrame(tick)
  }
  tick()
}

function leaveCurrentRoom() {
  stopMeter()
  releaseWakeLock()
  if (currentRoom) {
    currentRoom.leave()
    currentRoom = null
  }
}

// ---------- Barnenhet ----------

let babyStream = null

async function startBaby() {
  clearError()
  showView(els.viewBaby)
  els.babyMute.disabled = true
  els.babyMeterFill.style.width = '0%'
  setStatus(els.babyStatusDot, els.babyStatusText, 'waiting', 'Startar mikrofon…')

  const code = randomRoomCode()
  els.babyCode.textContent = code

  try {
    babyStream = await navigator.mediaDevices.getUserMedia({ audio: true })
  } catch {
    setStatus(els.babyStatusDot, els.babyStatusText, 'error', 'Kunde inte starta mikrofonen')
    showError('Åtkomst till mikrofonen nekades. Tillåt mikrofon i webbläsaren och försök igen.')
    return
  }

  await acquireWakeLock()

  currentRoom = joinRoom({ appId: APP_ID }, code)

  let peerCount = 0
  setStatus(els.babyStatusDot, els.babyStatusText, 'waiting', 'Väntar på föräldraenhet…')

  // addStream only reaches peers that are already in the room, so every
  // newly joined peer needs the stream (re-)sent directly to it.
  currentRoom.onPeerJoin = (peerId) => {
    peerCount++
    currentRoom.addStream(babyStream, { target: peerId })
    setStatus(els.babyStatusDot, els.babyStatusText, 'connected', 'Ansluten till föräldraenhet')
  }
  currentRoom.onPeerLeave = () => {
    peerCount = Math.max(0, peerCount - 1)
    if (peerCount === 0) {
      setStatus(els.babyStatusDot, els.babyStatusText, 'waiting', 'Väntar på föräldraenhet…')
    }
  }

  startMeter(babyStream, els.babyMeterFill)
  els.babyMute.disabled = false
  els.babyMute.textContent = 'Stäng av mikrofon'
}

function toggleBabyMute() {
  if (!babyStream) return
  const track = babyStream.getAudioTracks()[0]
  if (!track) return
  track.enabled = !track.enabled
  els.babyMute.textContent = track.enabled ? 'Stäng av mikrofon' : 'Slå på mikrofon'
}

function stopBaby() {
  leaveCurrentRoom()
  if (babyStream) {
    for (const track of babyStream.getTracks()) track.stop()
    babyStream = null
  }
  goToSelect()
}

// ---------- Föräldraenhet ----------

function startParentView() {
  clearError()
  showView(els.viewParent)
  els.parentJoinForm.hidden = false
  els.parentConnected.hidden = true
  els.parentCodeInput.value = ''
  els.parentCodeInput.focus()
}

async function joinAsParent(code) {
  clearError()
  els.parentJoinForm.hidden = true
  els.parentConnected.hidden = false
  els.parentMeterFill.style.width = '0%'
  setStatus(els.parentStatusDot, els.parentStatusText, 'waiting', 'Ansluter…')

  await acquireWakeLock()

  currentRoom = joinRoom({ appId: APP_ID }, code)

  currentRoom.onPeerStream = (stream) => {
    els.remoteAudio.srcObject = stream
    els.remoteAudio.play().catch(() => {})
    setStatus(els.parentStatusDot, els.parentStatusText, 'connected', 'Ansluten – lyssnar')
    startMeter(stream, els.parentMeterFill)
  }

  currentRoom.onPeerLeave = () => {
    setStatus(els.parentStatusDot, els.parentStatusText, 'waiting', 'Väntar på barnenhet…')
    els.parentMeterFill.style.width = '0%'
    els.remoteAudio.srcObject = null
    stopMeter()
  }
}

function stopParent() {
  leaveCurrentRoom()
  els.remoteAudio.srcObject = null
  goToSelect()
}

// ---------- Navigering ----------

function goToSelect() {
  clearError()
  showView(els.viewSelect)
}

els.btnBaby.addEventListener('click', startBaby)
els.btnParent.addEventListener('click', startParentView)
els.btnBack.addEventListener('click', () => {
  leaveCurrentRoom()
  if (babyStream) {
    for (const track of babyStream.getTracks()) track.stop()
    babyStream = null
  }
  els.remoteAudio.srcObject = null
  goToSelect()
})

els.babyMute.addEventListener('click', toggleBabyMute)
els.babyStop.addEventListener('click', stopBaby)
els.parentStop.addEventListener('click', stopParent)

els.parentJoinForm.addEventListener('submit', (e) => {
  e.preventDefault()
  const code = els.parentCodeInput.value.trim().toUpperCase()
  if (!code) return
  joinAsParent(code)
})

els.parentVolume.addEventListener('input', () => {
  els.remoteAudio.volume = Number(els.parentVolume.value) / 100
})

window.addEventListener('beforeunload', () => {
  leaveCurrentRoom()
  if (babyStream) {
    for (const track of babyStream.getTracks()) track.stop()
  }
})

showView(els.viewSelect)
