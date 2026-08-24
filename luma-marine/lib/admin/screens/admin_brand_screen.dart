import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/luma_logo.dart';
import '../widgets/admin_shell.dart';

/// The Luma Marine brand guide, built into the admin panel rather than kept
/// as an external document — palette, type, logo construction and usage,
/// all sourced from the same constants the rest of the app renders with
/// (AppColors, LumaMark/LumaWordmark), so it can't quietly drift out of
/// sync with the real product.
class AdminBrandScreen extends StatelessWidget {
  const AdminBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 900;

    return AdminShell(
      section: AdminSection.brand,
      title: 'Varumärke',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 40, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CoverHeader(),
              const _Section(
                title: 'Grunden',
                subtitle: 'Varför identiteten ser ut som den gör.',
                child: _FoundationBlock(),
              ),
              const _Section(
                title: 'Färg',
                subtitle: 'Marinblått och vitt är varumärket. Allt annat är stöd.',
                child: _ColorBlock(),
              ),
              const _Section(
                title: 'Typografi',
                subtitle: 'InterDisplay för ordmärke och rubriker, Inter för brödtext — samma typsnitt som butiken faktiskt använder.',
                child: _TypographyBlock(),
              ),
              _Section(
                title: 'Logotyp',
                subtitle: 'Ett märke, två färger, en och samma linjetjocklek. Aldrig fyllt, aldrig omfärgat.',
                child: _LogoBlock(compact: compact),
              ),
              _Section(
                title: 'I användning',
                subtitle: 'Så beter sig paletten när den faktiskt gör ett jobb.',
                child: _ApplicationBlock(compact: compact),
              ),
              _Section(
                title: 'Tonalitet',
                subtitle: 'Rösten som hör ihop med en identitet utan brus.',
                child: _VoiceBlock(compact: compact),
              ),
              const SizedBox(height: 24),
              const Text(
                'Källa: lib/theme/app_theme.dart och lib/widgets/luma_logo.dart. '
                'Ändra där, inte här — den här sidan läser samma värden.',
                style: TextStyle(color: AppColors.slate, fontSize: 12),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverHeader extends StatelessWidget {
  const _CoverHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LumaMark(size: 48, color: AppColors.navy),
          const SizedBox(height: 16),
          const Text(
            'VARUMÄRKESGUIDE',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 2.2,
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Luma Marines varumärke',
            style: TextStyle(
              fontFamily: 'InterDisplay',
              fontWeight: FontWeight.w700,
              fontSize: 32,
              letterSpacing: -0.3,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'En tvåfärgad identitet — marinblått och vitt — samt de typografi- och '
            'logotypregler som håller butiken och adminpanelen samman.',
            style: TextStyle(color: AppColors.slate, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _Section({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 28),
          Text(title,
              style: const TextStyle(
                  fontFamily: 'InterDisplay',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppColors.navy)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: AppColors.slate, fontSize: 13.5)),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _FoundationBlock extends StatelessWidget {
  const _FoundationBlock();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final stacked = width < 900;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Luma Marine finns för att lösa ett problem: att hitta rätt LED-belysning '
          'till en båt under 12 meter är svårare än det borde vara — spretiga '
          'komponenter, otydliga specifikationer och ingen vägledning i vad som '
          'faktiskt fungerar ihop ombord. Vi testar och väljer ut belysning och '
          'styrenheter som tål saltvatten, vibrationer och det nordiska klimatet, '
          'och vi kopplar varje komponent till rådgivning för en komplett, säker '
          'och genomtänkt belysningslösning — inte bara en lista med delar.',
          style: TextStyle(color: AppColors.ink, fontSize: 14.5, height: 1.6),
        ),
        SizedBox(height: 14),
        Text(
          'Det fokuset — precist, pålitligt, osnyggt utan att vara skrytsamt — är '
          'också designbriefen. Identiteten bygger på två färger och ett märke, '
          'för ett belysningsföretags eget uttryck ska inte konkurrera med '
          'produkten. Navigationsljus ska gå att läsa på en sekund; det ska '
          'varumärket också.',
          style: TextStyle(color: AppColors.ink, fontSize: 14.5, height: 1.6),
        ),
      ],
    );

    final factsCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fogDark),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FactRow('Fokus', 'Marin LED-belysning, båtar under 12 m'),
          _FactRow('Kärnpalett', 'Enbart marinblått + vitt'),
          _FactRow('Funktionell accent', 'Stålturkos — bara i UI, aldrig i logotypen'),
          _FactRow('Typsnitt', 'InterDisplay / Inter'),
          _FactRow('Märkets konstruktion', 'En linjetjocklek, ingen fyllnad'),
        ],
      ),
    );

    return stacked
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [text, const SizedBox(height: 20), factsCard])
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: text),
              const SizedBox(width: 32),
              Expanded(flex: 4, child: factsCard),
            ],
          );
  }
}

class _FactRow extends StatelessWidget {
  final String label;
  final String value;
  const _FactRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.slate, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, color: AppColors.ink)),
          ),
        ],
      ),
    );
  }
}

class _ColorSpec {
  final String name;
  final String role;
  final String usage;
  final Color color;
  final Color onColor;
  const _ColorSpec(this.name, this.role, this.usage, this.color, this.onColor);
}

class _ColorBlock extends StatelessWidget {
  const _ColorBlock();

  static const _colors = [
    _ColorSpec('Marinblå (Ink Navy)', 'Primär — kärnidentitet',
        'Logotyp, ordmärke, ytor som bär varumärket: hero-sektioner, sidfot, adminmenyn.',
        AppColors.navy, AppColors.white),
    _ColorSpec('Vit', 'Primär — kärnidentitet',
        'Den andra halvan av identiteten. Sidbakgrunder, kort, och logotypen på marinblått.',
        AppColors.white, AppColors.navy),
    _ColorSpec('Marinblå, ljus', 'Nyans av marinblå',
        'Sekundära ytor och hover-tillstånd på marinblå bakgrund.',
        AppColors.navyLight, AppColors.white),
    _ColorSpec('Marinblå, mörk', 'Nyans av marinblå',
        'Djupaste bakgrunden — sidfot, mörkt läge.',
        AppColors.navyDark, AppColors.white),
    _ColorSpec('Dis (Fog)', 'Neutral yta',
        'Sidbakgrund, ljusare än vit — kylig, blåtonad grå snarare än ren grå.',
        AppColors.fog, AppColors.ink),
    _ColorSpec('Skiffer (Slate)', 'Neutral text',
        'Sekundär text, bildtexter, metadata — aldrig rubriker eller logotypen.',
        AppColors.slate, AppColors.white),
    _ColorSpec('Stålturkos', 'Funktionell accent — ej kärnfärg',
        'Primära knappar, aktivt navigeringsläge, prislyft. Kombinera med mörk text, inte vit.',
        AppColors.seafoam, AppColors.navyDark),
    _ColorSpec('Stålturkos, mörk', 'Funktionell accent — ej kärnfärg',
        'Ikoner och text i accentfärgen där den ljusare tonen inte ger tillräcklig kontrast.',
        AppColors.seafoamDark, AppColors.white),
    _ColorSpec('Signalröd', 'Endast systemmeddelanden',
        'Fel och destruktiva åtgärder. Reserverad — aldrig dekorativ, aldrig nära logotypen.',
        AppColors.danger, AppColors.white),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 640 ? 1 : (width < 900 ? 2 : 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _colors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, i) {
            final c = _colors[i];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.fogDark),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 68,
                    color: c.color,
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '#${c.color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                      style: TextStyle(
                          color: c.onColor, fontSize: 11.5, fontFamily: 'monospace'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                        const SizedBox(height: 2),
                        Text(c.role.toUpperCase(),
                            style: const TextStyle(
                                color: AppColors.slate,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        Text(c.usage,
                            style: const TextStyle(color: AppColors.slate, fontSize: 12, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.seafoam.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.fogDark),
          ),
          child: const Text(
            'Stålturkos är ett verktyg, inte ett varumärke. Den finns för att ett rent '
            'marinblått/vitt gränssnitt inte kan visa vad som går att klicka på eller '
            'vad som finns i lager. Den syns aldrig i logotypen eller ordmärket. Går '
            'en användning av turkos att lösa med marinblått + luft + vikt istället — '
            'gör det.',
            style: TextStyle(color: AppColors.ink, fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _TypographyBlock extends StatelessWidget {
  const _TypographyBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TypeRow(
          label: 'ORDMÄRKE',
          spec: 'InterDisplay · Vikt 800 · Spärrning +0.12em · Alltid versaler',
          child: const Text('LUMA',
              style: TextStyle(
                  fontFamily: 'InterDisplay',
                  fontWeight: FontWeight.w800,
                  fontSize: 36,
                  letterSpacing: 5,
                  color: AppColors.navy)),
        ),
        _TypeRow(
          label: 'RUBRIK',
          spec: 'InterDisplay · Vikt 700 · Spärrning −0.01em · Gemener',
          child: const Text('Rätt ljus för din båt, på minuten',
              style: TextStyle(
                  fontFamily: 'InterDisplay',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: AppColors.navy)),
        ),
        _TypeRow(
          label: 'BRÖDTEXT',
          spec: 'Inter · Vikt 400–500 · Radavstånd 1.5',
          child: const Text(
              'Luma Marine hjälper dig hitta de bästa LED-lösningarna för båtar '
              'under 12 meter — från enskilda komponenter till kompletta paket.',
              style: TextStyle(color: AppColors.slate, fontSize: 15, height: 1.5)),
        ),
        _TypeRow(
          label: 'ETIKETT',
          spec: 'Inter · Vikt 700 · Spärrning +0.14em · Versaler',
          isLast: true,
          child: const Text('LEVERANTÖR · STYRENHETER & DIMMER',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.8,
                  color: AppColors.navy)),
        ),
      ],
    );
  }
}

class _TypeRow extends StatelessWidget {
  final String label;
  final String spec;
  final Widget child;
  final bool isLast;

  const _TypeRow({
    required this.label,
    required this.spec,
    required this.child,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final stacked = width < 640;
    final row = stacked
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.slate,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 1)),
              const SizedBox(height: 10),
              child,
              const SizedBox(height: 6),
              Text(spec, style: const TextStyle(color: AppColors.slate, fontSize: 11)),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(label,
                      style: const TextStyle(
                          color: AppColors.slate,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          letterSpacing: 1)),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    child,
                    const SizedBox(height: 6),
                    Text(spec, style: const TextStyle(color: AppColors.slate, fontSize: 11)),
                  ],
                ),
              ),
            ],
          );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.fogDark)),
      ),
      child: row,
    );
  }
}

class _LogoBlock extends StatelessWidget {
  final bool compact;
  const _LogoBlock({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _LogoPanel(background: AppColors.navy, child: const LumaLogoLockup(color: AppColors.white, markSize: 34)),
            _LogoPanel(background: AppColors.white, border: true, child: const LumaLogoLockup(color: AppColors.navy, markSize: 34)),
            _LogoPanel(background: AppColors.fog, child: const LumaMark(size: 48, color: AppColors.navy)),
            _LogoPanel(background: AppColors.navy, child: const LumaMark(size: 48, color: AppColors.white)),
          ],
        ),
        const SizedBox(height: 28),
        Center(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.slate, width: 1),
            ),
            child: Column(
              children: const [
                Text('Fri yta runt märket = märkets egen linjetjocklek',
                    style: TextStyle(fontSize: 11, color: AppColors.slate)),
                SizedBox(height: 12),
                LumaMark(size: 56, color: AppColors.navy),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _DoDontRow(compact: compact),
      ],
    );
  }
}

class _LogoPanel extends StatelessWidget {
  final Color background;
  final Widget child;
  final bool border;
  const _LogoPanel({required this.background, required this.child, this.border = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: border ? Border.all(color: AppColors.fogDark) : null,
      ),
      child: child,
    );
  }
}

class _DoDontRow extends StatelessWidget {
  final bool compact;
  const _DoDontRow({required this.compact});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _DoDontCard(
        ok: true,
        label: 'Vit logotyp på fylld marinblå yta',
        background: AppColors.navy,
        child: const LumaMark(size: 32, color: AppColors.white),
      ),
      _DoDontCard(
        ok: false,
        label: 'Omfärgad i UI-accenten',
        background: AppColors.navy,
        child: const LumaMark(size: 32, color: AppColors.seafoam),
      ),
      _DoDontCard(
        ok: false,
        label: 'Placerad på en stökig bakgrund',
        background: AppColors.navy,
        backgroundGradient: const LinearGradient(
          colors: [AppColors.navyLight, AppColors.seafoam, AppColors.navy],
        ),
        child: const LumaMark(size: 32, color: AppColors.white),
      ),
    ];

    return compact
        ? Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList())
        : Row(
            children: cards
                .map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 12), child: c)))
                .toList(),
          );
  }
}

class _DoDontCard extends StatelessWidget {
  final bool ok;
  final String label;
  final Color background;
  final Gradient? backgroundGradient;
  final Widget child;

  const _DoDontCard({
    required this.ok,
    required this.label,
    required this.background,
    required this.child,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fogDark),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundGradient == null ? background : null,
              gradient: backgroundGradient,
            ),
            child: child,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(ok ? 'JA' : 'NEJ',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        color: ok ? AppColors.seafoamDark : AppColors.danger)),
                const SizedBox(width: 8),
                Expanded(child: Text(label, style: const TextStyle(fontSize: 12.5))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ApplicationBlock extends StatelessWidget {
  final bool compact;
  const _ApplicationBlock({required this.compact});

  @override
  Widget build(BuildContext context) {
    final navMock = _MockCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.fogDark)),
            ),
            child: Row(
              children: [
                const LumaLogoLockup(color: AppColors.navy, markSize: 18),
                const Spacer(),
                const Text('Hem', style: TextStyle(fontSize: 11.5)),
                const SizedBox(width: 14),
                const Text('Sortiment',
                    style: TextStyle(fontSize: 11.5, color: AppColors.seafoamDark, fontWeight: FontWeight.w700)),
                const SizedBox(width: 14),
                const Text('Guider', style: TextStyle(fontSize: 11.5)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(spacing: 8, children: [
              Chip(
                label: const Text('Alla kategorier', style: TextStyle(fontSize: 11, color: AppColors.white)),
                backgroundColor: AppColors.navy,
              ),
              Chip(
                label: const Text('LED-remsor', style: TextStyle(fontSize: 11)),
                backgroundColor: AppColors.fog,
              ),
            ]),
          ),
        ],
      ),
    );

    final heroMock = _MockCard(
      background: AppColors.navy,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rätt ljus för din båt, på minuten',
                style: TextStyle(
                    color: AppColors.white,
                    fontFamily: 'InterDisplay',
                    fontWeight: FontWeight.w700,
                    fontSize: 17)),
            const SizedBox(height: 6),
            const Text('Marina LED-lösningar för båtar under 12 meter.',
                style: TextStyle(color: Color(0xFFB7C5CE), fontSize: 11.5)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: AppColors.seafoam, borderRadius: BorderRadius.circular(4)),
              child: const Text('Utforska sortimentet',
                  style: TextStyle(color: AppColors.navyDark, fontWeight: FontWeight.w700, fontSize: 11.5)),
            ),
          ],
        ),
      ),
    );

    final cardMock = _MockCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 90,
            color: AppColors.fog,
            alignment: Alignment.center,
            child: const LumaMark(size: 26, color: AppColors.navyLight, strokeWidthFactor: 0.09),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LED-remsa Varmvit 5m', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: AppColors.seafoam.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Text('I lager',
                      style: TextStyle(fontSize: 10.5, color: AppColors.seafoamDark, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 8),
                const Text('349 kr', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy)),
              ],
            ),
          ),
        ],
      ),
    );

    final footerMock = _MockCard(
      background: AppColors.navyDark,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            LumaLogoLockup(color: AppColors.white, markSize: 20),
            SizedBox(height: 10),
            Text('Marin LED-belysning för båtar under 12 meter.',
                style: TextStyle(color: Color(0xFF7C8FA0), fontSize: 11)),
          ],
        ),
      ),
    );

    final tiles = [navMock, heroMock, cardMock, footerMock];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: compact ? 1 : 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: compact ? 1.6 : 1.5,
      children: tiles,
    );
  }
}

class _MockCard extends StatelessWidget {
  final Widget child;
  final Color background;
  const _MockCard({required this.child, this.background = AppColors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fogDark),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _VoiceBlock extends StatelessWidget {
  final bool compact;
  const _VoiceBlock({required this.compact});

  @override
  Widget build(BuildContext context) {
    final cards = const [
      _VoiceCard(
        title: 'Rakt på, inte utsmyckat',
        body: 'Säg specen, priset, leveranstiden. Trovärdighet kommer av precision, inte adjektiv.',
        sample: '"4 dagars leveranstid" — inte "Superb, blixtsnabb leverans på bara 4 dagar!"',
      ),
      _VoiceCard(
        title: 'Tekniskt när det spelar roll',
        body: 'Båtägare vill ha IP-klass och spänning, inte marknadsföring som ersätter dem.',
        sample: '"IP67 · 12V · 300 LED" skrivet rakt av, varje gång.',
      ),
    ];

    return compact
        ? Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList())
        : Row(
            children: cards
                .map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16), child: c)))
                .toList(),
          );
  }
}

class _VoiceCard extends StatelessWidget {
  final String title;
  final String body;
  final String sample;
  const _VoiceCard({required this.title, required this.body, required this.sample});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fogDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(color: AppColors.slate, fontSize: 12.5, height: 1.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.fog, borderRadius: BorderRadius.circular(6)),
            child: Text(sample, style: const TextStyle(fontSize: 12.5)),
          ),
        ],
      ),
    );
  }
}
