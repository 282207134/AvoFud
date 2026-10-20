import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.autoNavigate = true});
  final bool autoNavigate;
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    if (!widget.autoNavigate) return;
    timer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppScope.of(context).signedIn ? '/home' : '/welcome',
        );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FoodImage('splash_logo', width: 80, height: 100),
          SizedBox(height: 12),
          Icon(Icons.water_drop_rounded, color: orange, size: 32),
        ],
      ),
    ),
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, bounds) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: bounds.maxHeight),
            child: Stack(
              children: [
                Positioned(
                  bottom: -110,
                  right: -15,
                  child: Transform.rotate(
                    angle: -.4,
                    child: const FoodImage('tea', width: 300, height: 300),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      SizedBox(height: bounds.maxHeight * .12),
                      const SoftCard(
                        padding: EdgeInsets.all(18),
                        child: FoodImage('logo', height: 30, width: 30),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'Welcome to\nAvoFud',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Let’s explore the amazing food',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(fontSize: 16),
                      ),
                      SizedBox(height: bounds.maxHeight * .10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: GestureDetector(
                          onHorizontalDragEnd: (_) =>
                              go(context, '/intro-cake'),
                          child: PrimaryButton(
                            'Slide to go',
                            onPressed: () => go(context, '/intro-cake'),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => go(context, '/signin'),
                        child: const Text(
                          'I already have an account',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(height: bounds.maxHeight * .32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class IntroPage extends StatelessWidget {
  const IntroPage({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    final item = product(['cake', 'tea', 'avocado'][index]);
    final background = [ink, orange, const Color(0xFFA4C675)][index];
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (i) => Container(
                          margin: const EdgeInsets.all(3),
                          width: index == i ? 15 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: index == i ? 1 : .35,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      [
                        'Would you like\nto eat a cake?',
                        'How long since you had\na cup of tea?',
                        'We have a thousand\nfresh food suppliers',
                      ][index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.3,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 18),
                    FoodImage(
                      item.image,
                      height: constraints.maxHeight * .27,
                      width: 300,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SoftCard(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: FoodImage(item.image, height: 90)),
                            const SizedBox(height: 10),
                            Text(
                              item.name,
                              style: const TextStyle(
                                color: ink,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Stars(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  money(item.price),
                                  style: const TextStyle(color: ink),
                                ),
                                RoundButton(
                                  tooltip: 'Continue',
                                  color: orange,
                                  onPressed: () => go(
                                    context,
                                    [
                                      '/intro-tea',
                                      '/intro-avocado',
                                      '/signin',
                                    ][index],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => go(context, '/signin'),
                      child: const Text(
                        'Skip to sign in',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
