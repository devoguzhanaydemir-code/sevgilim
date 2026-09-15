import 'dart:math';

import 'package:flutter/material.dart';

// ====== BURAYI KİŞİSELLEŞTİR ======
const String sevgiliAdi = 'Sevgilim';
const String gonderen = 'Oğuzhan';
const String mesaj =
    'Seninle geçen her gün hayatımın en güzel günü. '
    'Gülüşün, sesin, varlığın... Hepsi için teşekkür ederim.';
const String soru = 'Sonsuza kadar benim sevgilim olur musun?';
const String kutlamaMesaji = 'Biliyordum! Seni çok seviyorum ❤️';
// ==================================

void main() => runApp(const SevgilimApp());

class SevgilimApp extends StatelessWidget {
  const SevgilimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sana Özel ❤️',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.pink),
      home: const AnaEkran(),
    );
  }
}

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> with TickerProviderStateMixin {
  late final AnimationController _kalpler =
      AnimationController(vsync: this, duration: const Duration(seconds: 12))
        ..repeat();
  late final AnimationController _nabiz = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);

  final _rnd = Random();
  late final List<_Cicek> _cicekler = List.generate(34, (_) => _Cicek(_rnd));
  final List<_Parca> _patlamalar = [];
  final Stopwatch _saat = Stopwatch()..start();

  // Dokunulan yere çiçek saç
  void _cicekSac(Offset konum, {int adet = 18}) {
    final simdi = _saat.elapsedMilliseconds / 1000.0;
    _patlamalar.removeWhere((p) => simdi - p.baslangic > _Parca.omur);
    for (var i = 0; i < adet; i++) {
      _patlamalar.add(_Parca(_rnd, konum, simdi));
    }
  }

  bool _evet = false;
  int _hayirSayisi = 0;
  Alignment _hayirKonum = const Alignment(0.45, 0.72);

  static const _hayirYazilari = [
    'Hayır',
    'Emin misin? 🥺',
    'Bir daha düşün',
    'Yakalayamazsın 😜',
    'Bu buton bozuk',
    'Olmaz ki 💔',
  ];

  void _kac() {
    setState(() {
      _hayirSayisi++;
      _hayirKonum = Alignment(
        _rnd.nextDouble() * 1.6 - 0.8,
        _rnd.nextDouble() * 1.6 - 0.8,
      );
    });
  }

  @override
  void dispose() {
    _kalpler.dispose();
    _nabiz.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4), Color(0xFFFBC2EB)],
          ),
        ),
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (e) => _cicekSac(e.localPosition),
          child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _kalpler,
                builder: (_, __) => CustomPaint(
                  painter: _CicekRessami(
                    _cicekler,
                    _patlamalar,
                    _kalpler.value,
                    _saat.elapsedMilliseconds / 1000.0,
                    yogun: _evet,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _evet ? _kutlama() : _soruEkrani(),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buyukKalp() => ScaleTransition(
        scale: Tween(begin: 0.9, end: 1.1).animate(
            CurvedAnimation(parent: _nabiz, curve: Curves.easeInOut)),
        child: const Icon(Icons.favorite, color: Color(0xFFE91E63), size: 110),
      );

  Widget _soruEkrani() {
    final evetBoyut = 1.0 + min(_hayirSayisi, 8) * 0.12;
    return Stack(
      key: const ValueKey('soru'),
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 160),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: Tween(begin: 0.95, end: 1.05).animate(
                        CurvedAnimation(parent: _nabiz, curve: Curves.easeInOut)),
                    child: const SizedBox(
                      width: 220,
                      height: 180,
                      child: CustomPaint(painter: _EsekRessami()),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Ben bir eşşeğim 🙈',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6A1B9A))),
                  const SizedBox(height: 16),
                  Text('Sevgili $sevgiliAdi,',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF880E4F))),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(mesaj,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            color: Color(0xFF4A148C))),
                  ),
                  const SizedBox(height: 28),
                  const Text(soru,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFAD1457))),
                  const SizedBox(height: 24),
                  AnimatedScale(
                    scale: evetBoyut,
                    duration: const Duration(milliseconds: 300),
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 18),
                      ),
                      onPressed: () {
                        final boyut = MediaQuery.of(context).size;
                        for (var i = 0; i < 5; i++) {
                          _cicekSac(
                            Offset(boyut.width * (0.1 + i * 0.2),
                                boyut.height * 0.4),
                            adet: 24,
                          );
                        }
                        setState(() => _evet = true);
                      },
                      icon: const Icon(Icons.favorite),
                      label: const Text('Evet!',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Kaçan "Hayır" butonu
        AnimatedAlign(
          alignment: _hayirKonum,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutBack,
          child: MouseRegion(
            onEnter: (_) => _kac(),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFE91E63)),
              ),
              onPressed: _kac,
              child: Text(
                _hayirYazilari[_hayirSayisi % _hayirYazilari.length],
                style: const TextStyle(color: Color(0xFFE91E63)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _kutlama() {
    return Center(
      key: const ValueKey('kutlama'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.elasticOut,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: _buyukKalp(),
            ),
            const SizedBox(height: 24),
            const Text(kutlamaMesaji,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF880E4F))),
            const SizedBox(height: 12),
            const Text('— $gonderen',
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFAD1457))),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => setState(() {
                _evet = false;
                _hayirSayisi = 0;
              }),
              child: const Text('Tekrar izle ↺'),
            ),
          ],
        ),
      ),
    );
  }
}

const _renkler = [
  Color(0xFFE91E63),
  Color(0xFFFF80AB),
  Color(0xFFFFFFFF),
  Color(0xFFF06292),
  Color(0xFFBA68C8),
  Color(0xFFFFB74D),
];

class _Cicek {
  _Cicek(Random r)
      : x = r.nextDouble(),
        faz = r.nextDouble(),
        boyut = 9 + r.nextDouble() * 14,
        salinim = r.nextDouble() * 2 * pi,
        hiz = 0.5 + r.nextDouble() * 0.9,
        donus = (r.nextDouble() - 0.5) * 8,
        renk = _renkler[r.nextInt(_renkler.length)];

  final double x, faz, boyut, salinim, hiz, donus;
  final Color renk;
}

class _Parca {
  _Parca(Random r, this.merkez, this.baslangic)
      : aci = r.nextDouble() * 2 * pi,
        guc = 120 + r.nextDouble() * 260,
        boyut = 8 + r.nextDouble() * 10,
        donus = (r.nextDouble() - 0.5) * 12,
        renk = _renkler[r.nextInt(_renkler.length)];

  static const double omur = 2.2;
  final Offset merkez;
  final double baslangic, aci, guc, boyut, donus;
  final Color renk;
}

class _CicekRessami extends CustomPainter {
  _CicekRessami(this.cicekler, this.parcalar, this.t, this.saniye,
      {required this.yogun});

  final List<_Cicek> cicekler;
  final List<_Parca> parcalar;
  final double t, saniye;
  final bool yogun;

  @override
  void paint(Canvas canvas, Size size) {
    // Yukarıdan yağan çiçekler
    for (final c in cicekler) {
      final ilerleme = (t * c.hiz + c.faz) % 1.0;
      final y = size.height * (ilerleme * 1.2 - 0.1);
      final x = size.width * c.x + sin(ilerleme * 5 * pi + c.salinim) * 24;
      final boyut = c.boyut * (yogun ? 1.4 : 1.0);
      _cicekCiz(canvas, Offset(x, y), boyut, ilerleme * c.donus * pi, c.renk,
          yogun ? 0.95 : 0.75);
    }
    // Dokunuşla saçılan çiçekler
    for (final p in parcalar) {
      final g = saniye - p.baslangic;
      if (g < 0 || g > _Parca.omur) continue;
      final dx = cos(p.aci) * p.guc * g;
      final dy = sin(p.aci) * p.guc * g + 260 * g * g;
      final opak = 1 - g / _Parca.omur;
      _cicekCiz(canvas, p.merkez + Offset(dx, dy), p.boyut, g * p.donus,
          p.renk, opak);
    }
  }

  void _cicekCiz(Canvas canvas, Offset merkez, double s, double aci,
      Color renk, double opak) {
    canvas.save();
    canvas.translate(merkez.dx, merkez.dy);
    canvas.rotate(aci);
    final yaprak = Paint()..color = renk.withValues(alpha: opak);
    final kenar = Paint()
      ..color = const Color(0xFFAD1457).withValues(alpha: opak * 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      canvas.save();
      canvas.rotate(i * 2 * pi / 5);
      final r = Rect.fromCenter(
          center: Offset(0, -s * 0.55), width: s * 0.7, height: s * 1.05);
      canvas.drawOval(r, yaprak);
      canvas.drawOval(r, kenar);
      canvas.restore();
    }
    canvas.drawCircle(Offset.zero, s * 0.28,
        Paint()..color = const Color(0xFFFFD54F).withValues(alpha: opak));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CicekRessami old) => true;
}

class _EsekRessami extends CustomPainter {
  const _EsekRessami();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 220, size.height / 180);
    final gri = Paint()..color = const Color(0xFF9E9E9E);
    final koyu = Paint()..color = const Color(0xFF616161);
    final acik = Paint()..color = const Color(0xFFE0E0E0);
    final siyah = Paint()..color = const Color(0xFF212121);
    final pembe = Paint()..color = const Color(0xFFF8BBD0);

    // Kuyruk
    final kuyruk = Paint()
      ..color = const Color(0xFF616161)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(45, 95), const Offset(22, 125), kuyruk);
    canvas.drawCircle(const Offset(20, 128), 7, Paint()..color = const Color(0xFF424242));
    // Bacaklar
    for (final x in [58.0, 78.0, 118.0, 138.0]) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(x, 105, 14, 55), const Radius.circular(6)),
          gri);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(x - 1, 152, 16, 10), const Radius.circular(3)),
          siyah);
    }
    // Gövde
    canvas.drawOval(const Rect.fromLTWH(40, 65, 120, 60), gri);
    canvas.drawOval(const Rect.fromLTWH(70, 95, 60, 25), acik);
    // Boyun
    final boyun = Path()
      ..moveTo(130, 80)
      ..lineTo(150, 40)
      ..lineTo(172, 48)
      ..lineTo(160, 95)
      ..close();
    canvas.drawPath(boyun, gri);
    // Yele
    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(Offset(146 + i * 1.5, 45.0 + i * 9), 5, koyu);
    }
    // Kulaklar
    for (final dx in [-9.0, 9.0]) {
      canvas.save();
      canvas.translate(172 + dx, 30);
      canvas.rotate(dx * 0.03);
      canvas.drawOval(const Rect.fromLTWH(-7, -34, 14, 38), gri);
      canvas.drawOval(const Rect.fromLTWH(-3.5, -28, 7, 26), pembe);
      canvas.restore();
    }
    // Kafa
    canvas.drawOval(const Rect.fromLTWH(150, 22, 44, 50), gri);
    // Ağız / burun
    canvas.drawOval(const Rect.fromLTWH(160, 55, 46, 34), acik);
    canvas.drawCircle(const Offset(176, 70), 3, siyah);
    canvas.drawCircle(const Offset(192, 70), 3, siyah);
    // Gülümseme
    canvas.drawArc(const Rect.fromLTWH(172, 72, 22, 10), 0.2, 2.7, false,
        Paint()
          ..color = const Color(0xFF212121)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    // Gözler
    canvas.drawCircle(const Offset(165, 42), 5, siyah);
    canvas.drawCircle(const Offset(185, 42), 5, siyah);
    canvas.drawCircle(const Offset(166.5, 40.5), 1.6, Paint()..color = Colors.white);
    canvas.drawCircle(const Offset(186.5, 40.5), 1.6, Paint()..color = Colors.white);
    // Yanaklar
    canvas.drawCircle(const Offset(158, 56), 5, pembe);
    canvas.drawCircle(const Offset(198, 54), 5, pembe);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
