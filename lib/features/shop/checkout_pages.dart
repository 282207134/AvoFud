import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Screen(
      title: 'Shopping bag',
      back: true,
      bottom: state.cart.isEmpty
          ? null
          : PrimaryButton(
              'Check out · ${money(state.total)}',
              onPressed: () => go(context, '/checkout'),
            ),
      child: state.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 58,
                    color: orange,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your bag is empty',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add something delicious to get started.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    'Explore food',
                    onPressed: () => go(context, '/shopping'),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              children: [
                for (final e in state.cart.entries.toList())
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SoftCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              FoodImage(
                                product(e.key).image,
                                width: 80,
                                height: 80,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product(e.key).name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Text(
                                      '${money(product(e.key).price)} · ${cartOption(e.key)}',
                                      style: const TextStyle(color: orange),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: 'Remove ${product(e.key).name}',
                                onPressed: () =>
                                    state.changeQuantity(e.key, -e.value),
                                icon: const Icon(Icons.close_rounded, size: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip: 'Decrease ${product(e.key).name}',
                                onPressed: () =>
                                    state.changeQuantity(e.key, -1),
                                icon: const Icon(
                                  Icons.remove_circle_outline_rounded,
                                ),
                              ),
                              Text(
                                '${e.value}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              IconButton(
                                tooltip: 'Increase ${product(e.key).name}',
                                onPressed: () => state.changeQuantity(e.key, 1),
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                money(product(e.key).price * e.value),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total payment'),
                    Text(
                      money(state.total),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool failure = false, busy = false;
  Future<void> editAddress() async {
    final state = AppScope.of(context),
        controller = TextEditingController(text: AppScope.of(context).address);
    final form = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delivery address'),
        content: Form(
          key: form,
          child: TextFormField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Street, city and postcode',
            ),
            validator: (v) => (v ?? '').trim().length >= 10
                ? null
                : 'Please enter a complete address',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) await state.updateAddress(result);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    controller.dispose();
  }

  Future<void> pay() async {
    if (busy) return;
    setState(() => busy = true);
    final ok = await AppScope.of(context).checkout(simulateFailure: failure);
    if (!mounted) return;
    setState(() => busy = false);
    go(context, ok ? '/success' : '/failure');
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Screen(
      title: 'Check out',
      back: true,
      bottom: PrimaryButton(
        busy ? 'Processing…' : 'Pay out',
        dark: true,
        onPressed: state.cart.isEmpty || busy ? null : pay,
      ),
      child: ListView(
        padding: const EdgeInsets.only(top: 20, bottom: 24),
        children: [
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Invoice code: #${2101 + state.orders.length}'),
                ),
                const _ReceiptDivider(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (state.cart.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Your bag is empty. Add food before checking out.',
                          ),
                        ),
                      for (final e in state.cart.entries)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${product(e.key).name} x${e.value}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      cartOption(e.key),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                money(product(e.key).price * e.value),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const _ReceiptDivider(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Lovely Home',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: editAddress,
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: orange),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        state.address,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(22),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total payment'),
                      Text(
                        money(state.total),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.credit_card_rounded, color: orange),
            title: const Text('Demo card •••• 0192'),
            subtitle: const Text(
              'No real payment will be made',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => go(context, '/wallet'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Simulate payment failure',
              style: TextStyle(fontSize: 13),
            ),
            value: failure,
            activeThumbColor: orange,
            onChanged: (v) => setState(() => failure = v),
          ),
        ],
      ),
    );
  }
}

class _ReceiptDivider extends StatelessWidget {
  const _ReceiptDivider();
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        (constraints.maxWidth / 12).floor(),
        (_) => Container(
          width: 5,
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
      ),
    ),
  );
}

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, this.success = true});
  final bool success;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Screen(
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            success ? 'Continue shopping' : 'Order again',
            onPressed: () => success ? home(context) : go(context, '/checkout'),
          ),
          if (!success) ...[
            const SizedBox(height: 16),
            PrimaryButton(
              'Check my card',
              secondary: true,
              onPressed: () => go(context, '/wallet'),
            ),
          ],
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 92),
            if (success)
              const FoodImage('success', height: 220, width: 310)
            else ...[
              const SizedBox(height: 60),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFCF644D),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.credit_card_off_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),
              const SizedBox(height: 32),
            ],
            const SizedBox(height: 30),
            Text(
              success ? 'Successful Order' : 'Order failed!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              success
                  ? 'Order will arrive in 3 days'
                  : 'Your payment encountered an error',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontSize: 15),
            ),
            if (success) ...[
              const SizedBox(height: 52),
              if (state.orders.isNotEmpty) ...[
                for (final entry
                    in (state.orders.first['items'] as Map).entries.take(2))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProductRow(
                      product(entry.key as String),
                      subtitle: 'Quantity: ${entry.value}',
                      trailing: Text(
                        money(
                          product(entry.key as String).price *
                              (entry.value as num),
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
              ] else
                ProductRow(
                  product('cereal2'),
                  subtitle: 'Mix fruits',
                  trailing: const Text('\$20.00'),
                ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
