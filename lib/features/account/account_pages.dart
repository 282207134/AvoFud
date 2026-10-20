import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) => Screen(
    title: 'Account',
    tab: 4,
    child: ListView(
      padding: const EdgeInsets.only(top: 18),
      children: [
        Row(
          children: [
            const ClipOval(child: FoodImage('avatar', width: 60, height: 60)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ackerman',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 5),
                  const Text('+84 102 2810', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Row(
          children: [
            for (final label in ['Following: 100', 'Follower: 200'])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 28),
        for (final item in [
          (Icons.stars_rounded, const Color(0xFF5DAF60), 'Rewards', '/rewards'),
          (
            Icons.favorite_rounded,
            const Color(0xFFCF644D),
            'Love',
            '/favorites',
          ),
          (
            Icons.schedule_rounded,
            const Color(0xFF1AA798),
            'History',
            '/history',
          ),
          (Icons.account_balance_wallet_rounded, orange, 'Wallet', '/wallet'),
          (Icons.settings_rounded, ink, 'Setting', '/settings'),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SoftCard(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  item.$1,
                  size: 18,
                  color: item.$2 == ink
                      ? Theme.of(context).colorScheme.onSurface
                      : item.$2,
                ),
              ),
              title: Text(
                item.$3,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onTap: () => go(context, item.$4),
            ),
          ),
      ],
    ),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Screen(
      title: 'Setting',
      back: true,
      child: ListView(
        children: [
          const SizedBox(height: 24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark mode'),
            value: state.dark,
            activeThumbColor: orange,
            onChanged: state.setDark,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.language_rounded),
            title: const Text('Language preference'),
            subtitle: Text(state.language),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => go(context, '/language'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.grid_view_rounded),
            title: const Text('All screens'),
            subtitle: const Text('Browse the Pixso UI flow'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => go(context, '/gallery'),
          ),
          const SizedBox(height: 30),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AvoFud',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'A local food shopping demo based on the AvoFud Pixso UI Kit. Accounts, cards and orders stay on this device. No real payments or SMS messages are sent.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Text(
                  'Language selection is saved as a preference. UI copy follows the English design reference.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          PrimaryButton(
            'Sign out',
            secondary: true,
            onPressed: () async {
              await state.signIn(false);
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/signin',
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key, required this.kind});
  final String kind;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context),
        favorites = catalog
            .where((p) => AppScope.of(context).favorites.contains(p.id))
            .toList();
    return Screen(
      title: kind,
      back: true,
      child: ListView(
        padding: const EdgeInsets.only(top: 24, bottom: 24),
        children: [
          if (kind == 'Love') ...[
            if (favorites.isEmpty) ...[
              const SizedBox(height: 120),
              const Icon(
                Icons.favorite_border_rounded,
                size: 52,
                color: orange,
              ),
              const SizedBox(height: 24),
              const Center(child: Text('Your saved food will appear here.')),
              const SizedBox(height: 32),
              PrimaryButton(
                'Explore food',
                onPressed: () => go(context, '/shopping'),
              ),
            ],
            for (final p in favorites)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ProductRow(p),
              ),
          ] else if (kind == 'History') ...[
            if (state.orders.isEmpty) ...[
              const SizedBox(height: 120),
              const Icon(Icons.receipt_long_outlined, size: 52, color: orange),
              const SizedBox(height: 24),
              const Center(
                child: Text('No orders yet. Your next meal is waiting.'),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                'Start shopping',
                onPressed: () => go(context, '/shopping'),
              ),
            ],
            for (final order in state.orders)
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: SoftCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order['id']}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            money(order['total'] as num),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (order['date'] as String).substring(0, 10),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      for (final e in (order['items'] as Map).entries)
                        Text('${product(e.key as String).name} × ${e.value}'),
                      const SizedBox(height: 10),
                      const Text(
                        'Successful · local demo',
                        style: TextStyle(
                          color: Color(0xFF70A940),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ] else ...[
            const SizedBox(height: 70),
            const Icon(Icons.stars_rounded, color: orange, size: 80),
            const SizedBox(height: 24),
            Center(
              child: Text(
                '${state.orders.length * 10} points',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Earn 10 demo points for every completed order.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              'Find your next meal',
              onPressed: () => go(context, '/shopping'),
            ),
          ],
        ],
      ),
    );
  }
}

const screenCatalog = <(String, String, String)>[
  ('01', 'Splash', '/splash'),
  ('02', 'Welcome', '/welcome'),
  ('03', 'Jasmine tea intro', '/intro-tea'),
  ('04', 'Avocado intro', '/intro-avocado'),
  ('05', 'Cake intro', '/intro-cake'),
  ('06', 'Sign in', '/signin'),
  ('07', 'Sign up', '/signup'),
  ('08', 'OTP', '/otp'),
  ('09', 'Forgot password', '/forgot'),
  ('10', 'Language', '/language'),
  ('11', 'Calendar', '/calendar'),
  ('12', 'Product detail', '/detail'),
  ('13', 'Home', '/home'),
  ('14', 'Fruit yogurt', '/yogurt'),
  ('15', 'Statistics', '/statistics'),
  ('16', 'Fruit market', '/market'),
  ('17', 'Restaurant', '/restaurant'),
  ('18', 'Wallet', '/wallet'),
  ('19', 'Check out', '/checkout'),
  ('20', 'Order success', '/success'),
  ('21', 'Create card', '/create-card'),
  ('22', 'Tutorials', '/tutorials'),
  ('23', 'No result', '/empty'),
  ('24', 'Shopping', '/shopping'),
  ('25', 'Dimsum', '/dimsum'),
  ('26', 'Account', '/account'),
  ('27', 'Order failed', '/failure'),
  ('28', 'Reviews', '/reviews'),
];

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});
  @override
  Widget build(BuildContext context) => Screen(
    title: 'All screens',
    back: true,
    child: ListView(
      children: [
        const SizedBox(height: 12),
        Text(
          '28 screens from the Pixso UI Kit',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        for (final item in screenCatalog)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: orange.withValues(alpha: .12),
              child: Text(
                item.$1,
                style: const TextStyle(color: orange, fontSize: 13),
              ),
            ),
            title: Text(item.$2),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: () => go(context, item.$3),
          ),
      ],
    ),
  );
}
