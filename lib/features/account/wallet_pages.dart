import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';

class DebitCard extends StatelessWidget {
  const DebitCard({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 245,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: .16,
          child: Container(
            height: 198,
            margin: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: ink,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Container(
          height: 210,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8E8EC), Color(0xFF555866), ink],
              stops: [0, .25, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .12),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DEBIT CARD',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Spacer(),
              const Text(
                '1900 2830 0192 ****',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: .7,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Card holder',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          AppScope.of(context).cardHolder,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const FoodImage('logo', width: 30, height: 30),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Screen(
      title: 'Card',
      back: true,
      action: RoundButton(
        icon: Icons.tune_rounded,
        tooltip: 'Create card',
        size: 40,
        onPressed: () => go(context, '/create-card'),
      ),
      child: ListView(
        padding: const EdgeInsets.only(top: 18, bottom: 24),
        children: [
          const DebitCard(),
          const SizedBox(height: 38),
          Text('History', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          if (state.orders.isEmpty) ...[
            const SizedBox(height: 15),
            const Icon(Icons.receipt_long_outlined, size: 44),
            const SizedBox(height: 24),
            Text(
              'No transaction',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Explore our new products',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 34),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: PrimaryButton(
                'Explore',
                dark: true,
                onPressed: () => go(context, '/shopping'),
              ),
            ),
          ] else
            for (final order in state.orders)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: green,
                ),
                title: Text('Order #${order['id']}'),
                subtitle: Text((order['date'] as String).substring(0, 10)),
                trailing: Text(money(order['total'] as num)),
              ),
          const SizedBox(height: 30),
          Text(
            'Demo card · limit ${state.cardLimit}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class CreateCardPage extends StatefulWidget {
  const CreateCardPage({super.key});
  @override
  State<CreateCardPage> createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  final form = GlobalKey<FormState>(), holder = TextEditingController();
  String limit = '\$1,000';
  @override
  void dispose() {
    holder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Screen(
    title: 'Create card',
    back: true,
    bottom: PrimaryButton(
      'Create card',
      dark: true,
      onPressed: () async {
        if (!form.currentState!.validate()) return;
        await AppScope.of(context).createCard(holder.text, limit);
        if (context.mounted) {
          toast(context, 'Demo card created');
          Navigator.pushReplacementNamed(context, '/wallet');
        }
      },
    ),
    child: ListView(
      padding: const EdgeInsets.only(top: 40, bottom: 24),
      children: [
        Center(
          child: Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: ink,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .2),
                  blurRadius: 12,
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            child: const Icon(
              Icons.credit_card_rounded,
              color: Colors.white54,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 30),
        SoftCard(
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                TextFormField(
                  key: const ValueKey('card-holder'),
                  controller: holder,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Card holder',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) => (v ?? '').trim().length < 2
                      ? 'Enter the card holder name'
                      : null,
                ),
                const SizedBox(height: 24),
                Text(
                  'Card limit',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 22),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: [
                    for (final value in [
                      '\$500',
                      '\$1,000',
                      '\$2,000',
                      'No limit',
                    ])
                      ChoiceChip(
                        label: Center(child: Text(value)),
                        selected: limit == value,
                        selectedColor: orange.withValues(alpha: .16),
                        showCheckmark: false,
                        onSelected: (_) => setState(() => limit = value),
                        side: BorderSide.none,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Creates a local demo card only.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
