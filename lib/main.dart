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
  late final List<_Kalp> _kalpListesi = List.generate(28, (_) => _Kalp(_rnd));

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
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _kalpler,
                builder: (_, __) => CustomPaint(
                  painter: _KalpRessami(_kalpListesi, _kalpler.value,
                      yogun: _evet),
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
                  _buyukKalp(),
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
                      onPressed: () => setState(() => _evet = true),
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

class _Kalp {
  _Kalp(Random r)
      : x = r.nextDouble(),
        faz = r.nextDouble(),
        boyut = 10 + r.nextDouble() * 22,
        salinim = r.nextDouble() * 2 * pi,
        hiz = 0.6 + r.nextDouble() * 0.8;

  final double x, faz, boyut, salinim, hiz;
}

class _KalpRessami extends CustomPainter {
  _KalpRessami(this.kalpler, this.t, {required this.yogun});

  final List<_Kalp> kalpler;
  final double t;
  final bool yogun;

  @override
  void paint(Canvas canvas, Size size) {
    for (final k in kalpler) {
      final ilerleme = (t * k.hiz + k.faz) % 1.0;
      final y = size.height * (1.1 - ilerleme * 1.3);
      final x = size.width * k.x + sin(ilerleme * 6 * pi + k.salinim) * 18;
      final boyut = k.boyut * (yogun ? 1.5 : 1.0);
      final paint = Paint()
        ..color = const Color(0xFFE91E63)
            .withValues(alpha: (yogun ? 0.55 : 0.3) * (1 - ilerleme * 0.6));
      canvas.drawPath(_kalpYolu(Offset(x, y), boyut), paint);
    }
  }

  Path _kalpYolu(Offset c, double s) {
    return Path()
      ..moveTo(c.dx, c.dy + s * 0.35)
      ..cubicTo(c.dx - s * 1.0, c.dy - s * 0.3, c.dx - s * 0.45, c.dy - s * 0.95,
          c.dx, c.dy - s * 0.45)
      ..cubicTo(c.dx + s * 0.45, c.dy - s * 0.95, c.dx + s * 1.0, c.dy - s * 0.3,
          c.dx, c.dy + s * 0.35)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _KalpRessami old) =>
      old.t != t || old.yogun != yogun;
}
