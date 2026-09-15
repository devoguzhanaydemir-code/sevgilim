import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

// ====== BURAYI KİŞİSELLEŞTİR ======
const String sevgiliAdi = 'Sevgilim';
const List<String> mesajlar = [
  'Aya dokun 🌙',
  'İyi geceler $sevgiliAdi ✨',
  'Rüyanda beni gör 💛',
  'Yarın yine seni seveceğim',
  'Gökyüzüne dokun, dilek tut ⭐',
];
// Buluşma: 16 Eylül 2026, 18:00 (Türkiye saati = 15:00 UTC)
final DateTime bulusma = DateTime.utc(2026, 9, 16, 15, 0);
// ==================================

const sari = Color(0xFFFFD54F);

void main() => runApp(const MaterialApp(
      title: 'İyi Geceler 🌙',
      debugShowCheckedModeBanner: false,
      home: GeceEkrani(),
    ));

class GeceEkrani extends StatefulWidget {
  const GeceEkrani({super.key});

  @override
  State<GeceEkrani> createState() => _GeceEkraniState();
}

class _GeceEkraniState extends State<GeceEkrani>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tik =
      AnimationController(vsync: this, duration: const Duration(seconds: 60))
        ..repeat();
  final _rnd = Random();
  final _saat = Stopwatch()..start();
  late final List<_Yildiz> _yildizlar = List.generate(140, (_) => _Yildiz(_rnd));
  late final List<_Yildiz> _bocekler = List.generate(18, (_) => _Yildiz(_rnd));
  final List<_Kivilcim> _kivilcimlar = [];
  final List<_KayanYildiz> _kayanlar = [];
  int _mesaj = 0;
  double _ayParlama = 0;
  late final Timer _sayacTimer =
      Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));

  @override
  void initState() {
    super.initState();
    _sayacTimer;
  }

  Widget _sayac() {
    final kalan = bulusma.difference(DateTime.now().toUtc());
    if (kalan.isNegative) {
      return const Text('Görüşme zamanı geldi! 💛',
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: sari,
              shadows: [Shadow(color: sari, blurRadius: 20)]));
    }
    String iki(int n) => n.toString().padLeft(2, '0');
    Widget kutu(String deger, String etiket) => Container(
          width: 74,
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: sari.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(color: sari.withValues(alpha: 0.25), blurRadius: 18)
            ],
          ),
          child: Column(children: [
            Text(deger,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: sari,
                    shadows: [Shadow(color: sari, blurRadius: 16)])),
            Text(etiket,
                style: TextStyle(
                    fontSize: 12, color: sari.withValues(alpha: 0.8))),
          ]),
        );
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Görüşmemize kalan 💛',
          style: TextStyle(fontSize: 16, color: sari.withValues(alpha: 0.9))),
      const SizedBox(height: 10),
      Row(mainAxisSize: MainAxisSize.min, children: [
        kutu(iki(kalan.inHours), 'saat'),
        kutu(iki(kalan.inMinutes % 60), 'dakika'),
        kutu(iki(kalan.inSeconds % 60), 'saniye'),
      ]),
    ]);
  }

  double get _sn => _saat.elapsedMilliseconds / 1000.0;

  void _gokyuzuneDokun(Offset p, Size s) {
    final sn = _sn;
    _kivilcimlar.removeWhere((k) => sn - k.t0 > 1.6);
    for (var i = 0; i < 26; i++) {
      _kivilcimlar.add(_Kivilcim(_rnd, p, sn));
    }
    _kayanlar.removeWhere((k) => sn - k.t0 > 1.4);
    _kayanlar.add(_KayanYildiz(
        Offset(_rnd.nextDouble() * s.width, _rnd.nextDouble() * s.height * 0.4),
        sn));
  }

  void _ayaDokun() {
    setState(() {
      _mesaj = _mesaj % (mesajlar.length - 1) + 1;
      _ayParlama = 1;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _ayParlama = 0);
    });
  }

  @override
  void dispose() {
    _sayacTimer.cancel();
    _tik.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060F),
      body: LayoutBuilder(builder: (context, c) {
        final boyut = Size(c.maxWidth, c.maxHeight);
        final ayCap = min(boyut.width, boyut.height) * 0.38;
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (e) => _gokyuzuneDokun(e.localPosition, boyut),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF05060F),
                        Color(0xFF0B1030),
                        Color(0xFF1A1440)
                      ],
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _tik,
                    builder: (_, __) => CustomPaint(
                      painter: _GeceRessami(
                          _yildizlar, _bocekler, _kivilcimlar, _kayanlar, _sn),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.5),
                child: GestureDetector(
                  onTap: _ayaDokun,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: ayCap,
                    height: ayCap,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              sari.withValues(alpha: 0.45 + _ayParlama * 0.4),
                          blurRadius: 60 + _ayParlama * 60,
                          spreadRadius: 6 + _ayParlama * 20,
                        ),
                      ],
                    ),
                    child: const CustomPaint(painter: _AyRessami()),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.9),
                child: _sayac(),
              ),
              Align(
                alignment: const Alignment(0, 0.4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (w, a) => FadeTransition(
                        opacity: a, child: ScaleTransition(scale: a, child: w)),
                    child: Text(
                      mesajlar[_mesaj],
                      key: ValueKey(_mesaj),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: sari,
                        shadows: [
                          Shadow(color: sari, blurRadius: 24),
                          Shadow(color: Color(0xFFFF8F00), blurRadius: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _Yildiz {
  _Yildiz(Random rnd)
      : x = rnd.nextDouble(),
        y = rnd.nextDouble(),
        r = 0.6 + rnd.nextDouble() * 1.8,
        faz = rnd.nextDouble() * 2 * pi,
        hiz = 0.5 + rnd.nextDouble() * 2.5;
  final double x, y, r, faz, hiz;
}

class _Kivilcim {
  _Kivilcim(Random rnd, this.p, this.t0)
      : aci = rnd.nextDouble() * 2 * pi,
        guc = 60 + rnd.nextDouble() * 220,
        boy = 1.5 + rnd.nextDouble() * 3;
  final Offset p;
  final double t0, aci, guc, boy;
}

class _KayanYildiz {
  _KayanYildiz(this.p, this.t0);
  final Offset p;
  final double t0;
}

class _GeceRessami extends CustomPainter {
  _GeceRessami(
      this.yildizlar, this.bocekler, this.kivilcimlar, this.kayanlar, this.sn);
  final List<_Yildiz> yildizlar, bocekler;
  final List<_Kivilcim> kivilcimlar;
  final List<_KayanYildiz> kayanlar;
  final double sn;

  @override
  void paint(Canvas canvas, Size size) {
    final boya = Paint();
    final isilti = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final yildizRengi = Color.lerp(Colors.white, sari, 0.6)!;

    // Yanıp sönen yıldızlar
    for (final y in yildizlar) {
      final a = 0.35 + 0.65 * (0.5 + 0.5 * sin(sn * y.hiz + y.faz));
      boya.color = yildizRengi.withValues(alpha: a);
      canvas.drawCircle(Offset(y.x * size.width, y.y * size.height), y.r, boya);
    }

    // Ateş böcekleri
    for (final b in bocekler) {
      final x = (b.x * size.width + sin(sn * 0.3 * b.hiz + b.faz) * 60) %
          size.width;
      final yy = size.height * (0.55 + 0.4 * b.y) +
          cos(sn * 0.4 * b.hiz + b.faz) * 30;
      final a = 0.4 + 0.6 * (0.5 + 0.5 * sin(sn * 2 * b.hiz + b.faz));
      final o = Offset(x, yy);
      isilti.color = sari.withValues(alpha: a * 0.8);
      canvas.drawCircle(o, 7, isilti);
      boya.color = const Color(0xFFFFF59D).withValues(alpha: a);
      canvas.drawCircle(o, 2.2, boya);
    }

    // Kayan yıldızlar
    for (final k in kayanlar) {
      final g = (sn - k.t0) / 1.2;
      if (g < 0 || g > 1) continue;
      final bas = k.p + Offset(g * 420, g * 180);
      final kuyruk = bas - const Offset(120, 52);
      final cizgi = Paint()
        ..shader = LinearGradient(colors: [
          sari.withValues(alpha: 0),
          sari.withValues(alpha: 1 - g),
        ]).createShader(Rect.fromPoints(kuyruk, bas))
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(kuyruk, bas, cizgi);
      isilti.color = sari.withValues(alpha: 1 - g);
      canvas.drawCircle(bas, 6, isilti);
    }

    // Dokunuş kıvılcımları
    for (final k in kivilcimlar) {
      final g = sn - k.t0;
      if (g < 0 || g > 1.6) continue;
      final o = k.p +
          Offset(cos(k.aci) * k.guc * g, sin(k.aci) * k.guc * g + 40 * g * g);
      final a = 1 - g / 1.6;
      isilti.color = sari.withValues(alpha: a * 0.7);
      canvas.drawCircle(o, k.boy * 2.5, isilti);
      boya.color = const Color(0xFFFFF8E1).withValues(alpha: a);
      canvas.drawCircle(o, k.boy, boya);
    }
  }

  @override
  bool shouldRepaint(covariant _GeceRessami old) => true;
}

class _AyRessami extends CustomPainter {
  const _AyRessami();

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final c = Offset(r, r);
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-0.3, -0.3),
            colors: [Color(0xFFFFF9C4), sari, Color(0xFFFFB300)],
          ).createShader(Rect.fromCircle(center: c, radius: r)));
    final krater = Paint()
      ..color = const Color(0xFFFFA000).withValues(alpha: 0.35);
    canvas.drawCircle(c + Offset(-r * 0.3, -r * 0.35), r * 0.14, krater);
    canvas.drawCircle(c + Offset(r * 0.4, r * 0.35), r * 0.12, krater);
    canvas.drawCircle(c + Offset(-r * 0.45, r * 0.4), r * 0.08, krater);
    // Uyuyan yüz
    final yuz = Paint()
      ..color = const Color(0xFF6D4C00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.05
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
        Rect.fromCircle(center: c + Offset(-r * 0.3, -r * 0.02), radius: r * 0.13),
        0.2, pi - 0.4, false, yuz);
    canvas.drawArc(
        Rect.fromCircle(center: c + Offset(r * 0.3, -r * 0.02), radius: r * 0.13),
        0.2, pi - 0.4, false, yuz);
    canvas.drawArc(
        Rect.fromCircle(center: c + Offset(0, r * 0.2), radius: r * 0.18),
        0.4, pi - 0.8, false, yuz);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
