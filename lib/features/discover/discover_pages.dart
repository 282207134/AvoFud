import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({super.key});
  @override
  Widget build(BuildContext context) => Screen(
    back: true,
    child: ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const FoodImage(
            'restaurant',
            height: 258,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'Avo restaurant',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Free delivery',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: orange, size: 19),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '886 Pinewood Avenue,\nMarquette, Michigan',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 34),
        Row(
          children: [
            for (final stat in [
              ('4.5', 'Ratings'),
              ('346', 'Photos'),
              ('12k', 'Subscribers'),
            ])
              Expanded(
                child: Column(
                  children: [
                    Text(
                      stat.$1,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(stat.$2, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 38),
        Text('Reviews', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 24),
        const ReviewComment(
          name: 'Banan',
          message: 'I love all of these fresh flavours!',
          photos: true,
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        const ReviewComment(
          name: 'Ackerman',
          message: 'Awesome! A lovely place to share a meal.',
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => go(context, '/reviews'),
            child: const Text(
              'See all 47 comments',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class ReviewComment extends StatelessWidget {
  const ReviewComment({
    super.key,
    required this.name,
    required this.message,
    this.photos = false,
  });
  final String name, message;
  final bool photos;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ClipOval(child: FoodImage('avatar', width: 42, height: 42)),
      const SizedBox(width: 18),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const Stars(size: 11),
              ],
            ),
            Text(
              '2 min ago',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontSize: 11),
            ),
            const SizedBox(height: 12),
            Text(message),
            if (photos) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  for (final image in ['tea', 'avocado', 'cake'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: orange.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: FoodImage(image, width: 52, height: 52),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});
  @override
  Widget build(BuildContext context) => Screen(
    title: 'Review',
    back: true,
    action: const CartButton(),
    child: ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const FoodImage('review', height: 240),
        const SizedBox(height: 26),
        Text('Customer reviews', style: Theme.of(context).textTheme.bodySmall),
        Row(
          children: [
            Text('5.0', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(width: 10),
            const Text(
              '(1k Votes)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            const Stars(size: 17),
          ],
        ),
        const SizedBox(height: 30),
        for (final item in [(5, 75), (4, 16), (3, 7), (2, 1), (1, 1)])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '${item.$1}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: item.$2 / 100,
                      minHeight: 7,
                      color: orange,
                      backgroundColor: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 37,
                  child: Text(
                    '${item.$2}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 30),
        Text('Comment', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 24),
        const ReviewComment(
          name: 'Ackerman',
          message: 'Awesome! It’s pretty much perfect.',
        ),
      ],
    ),
  );
}

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({super.key});
  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> {
  Timer? timer;
  double seconds = 0;
  bool playing = false, savedView = false;
  static const steps = [
    'Prepare yogurt, honey and fresh seasonal fruit.',
    'Slice the fruit and arrange it in your favourite bowl.',
    'Add a spoonful of honey. Serve fresh and enjoy!',
  ];
  void toggle() {
    if (playing) {
      timer?.cancel();
      setState(() => playing = false);
      return;
    }
    if (seconds >= 120) seconds = 0;
    setState(() => playing = true);
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        seconds = (seconds + 1).clamp(0, 120);
        if (seconds == 120) {
          playing = false;
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context),
        saved = AppScope.of(context).favorites.contains('recipe');
    return Screen(
      title: 'Video',
      tab: 3,
      action: IconButton(
        tooltip: 'Save recipe',
        onPressed: () => state.toggleFavorite('recipe'),
        icon: Icon(
          saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          color: orange,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          if (savedView && !saved) ...[
            const SizedBox(height: 100),
            const Icon(Icons.bookmark_border_rounded, color: orange, size: 52),
            const SizedBox(height: 24),
            const Center(child: Text('Save a recipe to find it here.')),
            const SizedBox(height: 30),
            PrimaryButton(
              'Browse tutorials',
              onPressed: () => setState(() => savedView = false),
            ),
          ] else ...[
            SoftCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(22),
                        ),
                        child: const FoodImage(
                          'tutorial',
                          height: 265,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton.filled(
                        key: const ValueKey('recipe-play'),
                        tooltip: playing ? 'Pause recipe' : 'Play recipe',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: .9),
                          foregroundColor: ink,
                        ),
                        iconSize: 28,
                        onPressed: toggle,
                        icon: Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 20, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: seconds,
                            max: 120,
                            activeColor: orange,
                            onChanged: (v) => setState(() => seconds = v),
                          ),
                        ),
                        Text(
                          '${(120 - seconds).floor() ~/ 60}:${((120 - seconds).floor() % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (playing || seconds > 0)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SoftCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guided recipe · Step ${(seconds ~/ 40).clamp(0, 2) + 1}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(steps[(seconds ~/ 40).clamp(0, 2)]),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var album = 0; album < 2; album++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: album == 0 ? 16 : 0),
                      child: Column(
                        children: [
                          SoftCard(
                            padding: const EdgeInsets.all(14),
                            onTap: () => setState(() => savedView = album == 1),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              children: [
                                for (final name
                                    in album == 0
                                        ? [
                                            'tutorial',
                                            'yogurt',
                                            'cereal_one',
                                            'tea',
                                          ]
                                        : [
                                            'salad_one',
                                            'salad_two',
                                            'salad_three',
                                            'salad_four',
                                          ])
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      color: orange.withValues(alpha: .1),
                                      child: FoodImage(name, fit: BoxFit.cover),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            album == 0 ? 'Tutorial' : 'Saved',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'A 2-minute guided recipe',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
