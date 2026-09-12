# Babylarm (Baby Monitor)

En enkel babymonitor som körs helt i webbläsaren, utan konto och utan egen
server. Två telefoner öppnar samma sida, väljer varsin roll och ansluter
direkt till varandra (peer-to-peer, WebRTC).

## Så funkar det

1. Öppna sidan på båda telefonerna.
2. På telefonen som ska stå hos barnet: välj **Barnenhet**. Den startar
   mikrofonen och visar en rumskod.
3. På den andra telefonen: välj **Föräldraenhet** och skriv in samma
   rumskod, tryck **Anslut**.
4. Ljudet strömmas direkt från barnenheten till föräldraenheten så länge
   båda flikarna hålls öppna. Tryck **Stäng av** för att avsluta.

Ingen inloggning krävs och ingen data sparas på någon server – anslutningen
sker peer-to-peer via WebRTC, med [Trystero](https://github.com/dmotz/trystero)
(BitTorrent-strategin) som enda hjälpmedel för att hitta motparten, eftersom
det inte finns någon egen backend på GitHub Pages.

## Begränsningar

- Fliken/sidan måste hållas öppen på båda enheterna – stängs den, stängs
  larmet av (det finns ingen bakgrundstjänst på en ren webbsida).
- Mikrofon och ljuduppspelning kräver att användaren tillåter det i
  webbläsaren.
- Fungerar bäst med båda enheterna anslutna till internet (wifi eller
  mobildata); ljudet går direkt mellan telefonerna när det går, annars
  reläas det via en publik server.

## Utveckling

Ingen build behövs – det är bara statisk HTML/CSS/JS. Öppna
`index.html` i en webbläsare (eller kör en enkel lokal webbserver, t.ex.
`npx serve .`, eftersom mikrofonåtkomst kräver `https://` eller
`localhost`).
