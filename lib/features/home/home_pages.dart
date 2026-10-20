import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Screen(
      tab: 0,
      child: ListView(
        padding: const EdgeInsets.only(top: 40, bottom: 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Avo',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'We have some new...',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(fontSize: 17),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => go(context, '/account'),
                child: const ClipOval(
                  child: FoodImage('avatar', width: 44, height: 44),
                ),
              ),
              const CartButton(),
            ],
          ),
          const SizedBox(height: 34),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SoftCard(
                  onTap: () => go(context, '/wallet'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: orange.withValues(alpha: .08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.credit_card_rounded,
                          color: orange,
                          size: 21,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Visa card',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Linked successfully',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        '\$120.00',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 28),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    RoundButton(
                      tooltip: 'Create card',
                      onPressed: () => go(context, '/create-card'),
                    ),
                    const SizedBox(height: 22),
                    TextButton(
                      onPressed: () => go(context, '/statistics'),
                      child: const Text(
                        'Statistics',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order list',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () => go(context, '/history'),
                child: const Text('See all', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          if (state.orders.isEmpty) ...[
            for (final entry in [
              ('Avocado', 'avocado', 21.0, 'Successful'),
              ('Banana', 'banana', 3.0, 'Successful'),
              ('Fruit yogurt', 'yogurt', 30.0, 'Pending'),
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(context).dividerColor,
                      child: FoodImage(entry.$2, width: 44, height: 44),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.$1,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            entry.$4,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      money(entry.$3),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
          ] else
            ...state.orders
                .take(3)
                .map(
                  (o) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: green,
                    ),
                    title: Text('Order #${o['id']}'),
                    subtitle: const Text('Successful'),
                    trailing: Text(money(o['total'] as num)),
                    onTap: () => go(context, '/history'),
                  ),
                ),
          const SizedBox(height: 20),
          ProductRow(product('yogurt'), subtitle: 'Fresh pick for you'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  'Fruit market',
                  secondary: true,
                  onPressed: () => go(context, '/market'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  'Restaurant',
                  secondary: true,
                  onPressed: () => go(context, '/restaurant'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime month = DateTime(2026, 9);
  int selected = 21;
  static const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1).weekday - 1;
    final days = DateTime(month.year, month.month + 1, 0).day;
    return Screen(
      title: 'Calendar',
      tab: 1,
      child: ListView(
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      months[month.month - 1],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You have a note on $selected',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              RoundButton(
                icon: Icons.chevron_left_rounded,
                tooltip: 'Previous month',
                onPressed: () => setState(() {
                  month = DateTime(month.year, month.month - 1);
                  selected = 1;
                }),
              ),
              const SizedBox(width: 12),
              RoundButton(
                icon: Icons.chevron_right_rounded,
                tooltip: 'Next month',
                onPressed: () => setState(() {
                  month = DateTime(month.year, month.month + 1);
                  selected = 1;
                }),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              for (final d in ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ((first + days) / 7).ceil() * 7,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemBuilder: (context, i) {
              final day = i - first + 1;
              if (day < 1 || day > days) return const SizedBox.shrink();
              final active = day == selected;
              return Center(
                child: InkWell(
                  onTap: () => setState(() => selected = day),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active
                          ? ink
                          : day == 15
                          ? orange
                          : null,
                    ),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                        color: active || day == 15 ? Colors.white : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          SoftCard(
            onTap: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acker Event',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${months[month.month - 1]} $selected, ${month.year} · 18:00',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Meet local chefs and discover seasonal ingredients. Your calendar note is selected for this day.',
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      'Got it',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Acker Event',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const Icon(Icons.calendar_month_outlined, size: 18),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('“A great chef is an artist that\nI truly respect”'),
                const SizedBox(height: 38),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_rounded, size: 13),
                    const Text(' 21'),
                    const SizedBox(width: 14),
                    const Icon(Icons.person_rounded, size: 14),
                    const Text(' 1,200'),
                    const Spacer(),
                    Text(
                      '${months[month.month - 1]} $selected',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});
  @override
  Widget build(BuildContext context) => Screen(
    back: true,
    child: ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Statistic',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const Chip(
              label: Text('Month', style: TextStyle(fontSize: 12)),
              side: BorderSide.none,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 265,
          child: CustomPaint(
            painter: _SpendingPainter(),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    money(
                      AppScope.of(context).orders.fold<num>(
                        1200,
                        (sum, o) => sum + (o['total'] as num),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Limit: \$1,400',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: .85,
          children: [
            for (final item in [
              (Icons.shopping_basket_outlined, orange, '30', 'Order'),
              (Icons.bolt_rounded, const Color(0xFF57AF67), '42%', 'Increase'),
              (Icons.layers_rounded, const Color(0xFFCF644D), '23', 'Code'),
              (
                Icons.chat_bubble_outline_rounded,
                const Color(0xFF17AA9A),
                '2',
                'Review',
              ),
            ])
              SoftCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.$1, color: item.$2),
                    const SizedBox(height: 20),
                    Text(
                      item.$3,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(item.$4, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Sample monthly overview + your local orders',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
        ),
      ],
    ),
  );
}

class _SpendingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var layer = 0; layer < 3; layer++) {
      final path = Path();
      for (var i = 0; i <= 360; i++) {
        final angle = i * math.pi / 180;
        final radius = 103 + 11 * math.sin(angle * (5 + layer) + layer * 1.9);
        final point =
            center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = [
            const Color(0xFFCE6A66),
            const Color(0xFF5CBFB9),
            const Color(0xFF71AFA3),
          ][layer].withValues(alpha: .42),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF719D99).withValues(alpha: .6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .7,
      );
    }
    canvas.drawCircle(center, 76, Paint()..color = ink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
