import 'dart:math';

import 'package:flutter/material.dart';

// ====== BURAYI KİŞİSELLEŞTİR ======
const String gonderen = 'Oğuzhan';
const String finalMesaj = 'Kalbimi de sen iyileştirdin 💛';
const int hedef = 5;
// ==================================

const nane = Color(0xFF26A69A);
const pembe = Color(0xFFEC407A);
const koyu = Color(0xFF004D40);

class Dert {
  const Dert(this.hasta, this.soz, this.cozum);
  final String hasta, soz, cozum;
}

class Arac {
  const Arac(this.id, this.emoji, this.ad);
  final String id, emoji, ad;
}

const araclar = [
  Arac('ates', '🌡️', 'Termometre'),
  Arac('yara', '🩹', 'Yara bandı'),
  Arac('tansiyon', '🩺', 'Tansiyon'),
  Arac('ilac', '💊', 'İlaç'),
  Arac('sarilma', '🤗', 'Sarılma'),
];

const dertler = [
  Dert('🤒', 'Ateşim çıktı!', 'ates'),
  Dert('🥵', 'Yanıyorum sanki!', 'ates'),
  Dert('🤕', 'Düştüm, kolum kanadı!', 'yara'),
  Dert('😣', 'Dizimi sıyırdım...', 'yara'),
  Dert('😵‍💫', 'Başım dönüyor!', 'tansiyon'),
  Dert('😰', 'Kalbim çok hızlı atıyor!', 'tansiyon'),
  Dert('🤧', 'Burnum aktı, hapşu!', 'ilac'),
  Dert('🤢', 'Midem bulanıyor...', 'ilac'),
  Dert('💔', 'Kalbim kırıldı...', 'sarilma'),
  Dert('🥺', 'Çok yalnız hissediyorum', 'sarilma'),
];

void main() => runApp(const MaterialApp(
      title: 'Nöbetteki Hemşire 👩‍⚕️',
      debugShowCheckedModeBanner: false,
      home: Oyun(),
    ));

enum Asama { giris, oyun, bitti, kazandi }

class Oyun extends StatefulWidget {
  const Oyun({super.key});
  @override
  State<Oyun> createState() => _OyunState();
}

class _OyunState extends State<Oyun> with TickerProviderStateMixin {
  final _rnd = Random();
  Asama _asama = Asama.giris;
  int _iyilesen = 0;
  int _can = 1;
  late Dert _dert;
  String? _geriBildirim;
  bool _dogru = false;
  bool _kilit = false;

  late final AnimationController _sure = AnimationController(vsync: this)
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed && _asama == Asama.oyun && !_kilit) {
        _cevap(null);
      }
    });
  late final AnimationController _kalp = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800))
    ..repeat(reverse: true);

  void _basla() {
    setState(() {
      _asama = Asama.oyun;
      _iyilesen = 0;
      _can = 1;
    });
    _yeniHasta();
  }

  void _yeniHasta() {
    setState(() {
      _dert = dertler[_rnd.nextInt(dertler.length)];
      _geriBildirim = null;
      _kilit = false;
    });
    // Her hastada süre biraz kısalır
    _sure.duration = Duration(milliseconds: 6000 - _iyilesen * 300);
    _sure.forward(from: 0);
  }

  void _cevap(String? aracId) {
    if (_kilit) return;
    _sure.stop();
    final dogru = aracId == _dert.cozum;
    setState(() {
      _kilit = true;
      _dogru = dogru;
      if (dogru) {
        _iyilesen++;
        _geriBildirim = 'İyileşti! 💚';
      } else {
        _can--;
        _geriBildirim = aracId == null ? 'Süre doldu! ⏰' : 'Yanlış malzeme! 😬';
      }
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_iyilesen >= hedef) {
        setState(() => _asama = Asama.kazandi);
      } else if (_can <= 0) {
        setState(() => _asama = Asama.bitti);
      } else {
        _yeniHasta();
      }
    });
  }

  @override
  void dispose() {
    _sure.dispose();
    _kalp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F2F1), Color(0xFFFFFFFF), Color(0xFFFCE4EC)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: switch (_asama) {
                    Asama.giris => _giris(),
                    Asama.oyun => _oyun(),
                    Asama.bitti => _bitti(),
                    Asama.kazandi => _kazandi(),
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buton(String yazi, VoidCallback f) => FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: pembe,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: f,
        child: Text(yazi, style: const TextStyle(fontSize: 20)),
      );

  Widget _giris() => Column(
        key: const ValueKey('giris'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('👩‍⚕️', style: TextStyle(fontSize: 110)),
          const SizedBox(height: 12),
          const Text('Nöbetteki Hemşire',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 34, fontWeight: FontWeight.w800, color: koyu)),
          const SizedBox(height: 16),
          const Text(
            'Hastalar sırayla geliyor!\nSüre bitmeden doğru malzemeye dokun.\n'
            '$hedef hastayı iyileştir, hiç hata hakkın yok!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 32),
          _buton('Nöbete başla 🩺', _basla),
        ],
      );

  Widget _oyun() {
    return Column(
      key: const ValueKey('oyun'),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hasta $_iyilesen / $hedef',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: koyu)),
            Text(_can > 0 ? '❤️' : '💔',
                style: const TextStyle(fontSize: 22)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AnimatedBuilder(
            animation: _sure,
            builder: (_, __) => LinearProgressIndicator(
              value: 1 - _sure.value,
              minHeight: 12,
              backgroundColor: Colors.black12,
              color: _sure.value > 0.7 ? Colors.redAccent : nane,
            ),
          ),
        ),
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (w, a) => ScaleTransition(scale: a, child: w),
          child: Column(
            key: ValueKey('$_iyilesen-$_can-${_dert.soz}'),
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 12)
                  ],
                ),
                child: Text(_dert.soz,
                    style: const TextStyle(fontSize: 20, color: koyu)),
              ),
              const SizedBox(height: 8),
              Text(_kilit && _dogru ? '😊' : _dert.hasta,
                  style: const TextStyle(fontSize: 120)),
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: _geriBildirim == null
              ? null
              : Text(_geriBildirim!,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: _dogru ? nane : Colors.redAccent)),
        ),
        const Spacer(),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final a in araclar)
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: _kilit ? null : () => _cevap(a.id),
                child: Container(
                  width: 96,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: nane, width: 2),
                  ),
                  child: Column(children: [
                    Text(a.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 4),
                    Text(a.ad,
                        style: const TextStyle(fontSize: 13, color: koyu)),
                  ]),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _bitti() => Column(
        key: const ValueKey('bitti'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😅', style: TextStyle(fontSize: 100)),
          const SizedBox(height: 12),
          const Text('Nöbet zor geçti!',
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.w800, color: koyu)),
          const SizedBox(height: 8),
          Text('$_iyilesen hastayı iyileştirdin. Bir daha dene!',
              style: const TextStyle(fontSize: 17)),
          const SizedBox(height: 28),
          _buton('Tekrar dene 🔁', _basla),
        ],
      );

  Widget _kazandi() => Column(
        key: const ValueKey('kazandi'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.9, end: 1.15).animate(
                CurvedAnimation(parent: _kalp, curve: Curves.easeInOut)),
            child: const Text('💛', style: TextStyle(fontSize: 120)),
          ),
          const SizedBox(height: 12),
          const Text('Nöbet bitti, herkes iyileşti! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: koyu)),
          const SizedBox(height: 16),
          const Text(finalMesaj,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w800, color: pembe)),
          const SizedBox(height: 10),
          const Text('Dünyanın en tatlı hemşiresine 👩‍⚕️\n— $gonderen',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontStyle: FontStyle.italic, color: koyu)),
          const SizedBox(height: 28),
          _buton('Tekrar oyna 🔁', _basla),
        ],
      );
}
