import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/catalog.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key, this.market = false});
  final bool market;
  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String category = 'Salad', query = '';
  bool sortPrice = false;
  Future<void> filters() async {
    final text = TextEditingController(text: query);
    var sort = sortPrice;
    final result = await showModalBottomSheet<(String, bool)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => Padding(
          padding: EdgeInsets.fromLTRB(
            28,
            12,
            28,
            MediaQuery.viewInsetsOf(context).bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find something fresh',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              TextField(
                key: const ValueKey('search'),
                controller: text,
                decoration: const InputDecoration(
                  hintText: 'Search food',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Price: low to high'),
                value: sort,
                activeThumbColor: orange,
                onChanged: (v) => update(() => sort = v),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                'Apply',
                onPressed: () => Navigator.pop(context, (text.text, sort)),
              ),
            ],
          ),
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        query = result.$1;
        sortPrice = result.$2;
      });
    }
    // The sheet transition must finish before disposing its field controller.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    text.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final items =
        (widget.market
                ? catalog.where(
                    (p) => [
                      'zucchini',
                      'cabbage',
                      'garlic',
                      'mushroom',
                      'pepper',
                      'banana',
                    ].contains(p.id),
                  )
                : catalog.where((p) => p.category == category))
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    if (sortPrice) items.sort((a, b) => a.price.compareTo(b.price));
    return Screen(
      title: widget.market ? 'Fruit market' : 'Shopping',
      back: widget.market,
      tab: widget.market ? null : 2,
      action: const CartButton(),
      child: Column(
        children: [
          if (!widget.market)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 22),
              child: Row(
                children: [
                  for (final c in ['Salad', 'Fruit', 'Meat'])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TextButton(
                          onPressed: () => setState(() => category = c),
                          style: TextButton.styleFrom(
                            backgroundColor: category == c
                                ? orange
                                : Colors.transparent,
                            foregroundColor: category == c
                                ? Colors.white
                                : null,
                          ),
                          child: Text(c, style: const TextStyle(fontSize: 13)),
                        ),
                      ),
                    ),
                  RoundButton(
                    icon: Icons.tune_rounded,
                    tooltip: 'Search and filter',
                    size: 40,
                    onPressed: filters,
                  ),
                ],
              ),
            ),
          if (query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Results for “$query”',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Clear search',
                    onPressed: () => setState(() => query = ''),
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                ],
              ),
            ),
          Expanded(
            child: items.isEmpty
                ? EmptyContent(
                    onRetry: () => setState(() {
                      query = '';
                      category = 'Salad';
                    }),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.only(top: 6, bottom: 24),
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 20,
                      mainAxisExtent: widget.market ? 193 : 252,
                    ),
                    itemBuilder: (context, index) {
                      final p = items[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: widget.market ? 182 : 188,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned.fill(
                                  bottom: 12,
                                  child: SoftCard(
                                    padding: EdgeInsets.zero,
                                    color: widget.market ? p.color : null,
                                    onTap: () => openProduct(context, p),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!widget.market) ...[
                                            const Stars(),
                                            const SizedBox(height: 10),
                                          ],
                                          Expanded(
                                            child: Center(
                                              child: FoodImage(
                                                p.image,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                          if (widget.market) ...[
                                            const SizedBox(height: 12),
                                            Text(
                                              p.name,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -4,
                                  right: 12,
                                  child: RoundButton(
                                    key: ValueKey('add-${p.id}'),
                                    tooltip: 'Add ${p.name}',
                                    onPressed: () {
                                      state.add(p);
                                      toast(context, '${p.name} added to bag');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!widget.market) ...[
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(money(p.price)),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class EmptyContent extends StatelessWidget {
  const EmptyContent({super.key, required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      child: Column(
        children: [
          const FoodImage('empty', width: 280, height: 210),
          const SizedBox(height: 28),
          Text('No result', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(
            'Try a different food or category',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: PrimaryButton('Try again', onPressed: onRetry),
          ),
        ],
      ),
    ),
  );
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});
  @override
  Widget build(BuildContext context) => Screen(
    back: true,
    child: EmptyContent(onRetry: () => go(context, '/shopping')),
  );
}

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.item});
  final Product item;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int size = 0, quantity = 1;
  late Product item = widget.item;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Screen(
      title: 'Detail',
      back: true,
      action: const CartButton(),
      child: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 26),
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 319,
                decoration: BoxDecoration(
                  color: item.id == 'burger' ? orange : item.color,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: FoodImage(
                    item.image,
                    width: double.infinity,
                    height: 280,
                  ),
                ),
              ),
              Positioned(
                bottom: -23,
                child: Row(
                  children: [
                    RoundButton(
                      icon: Icons.chevron_left_rounded,
                      tooltip: 'Previous product',
                      onPressed: () => setState(() {
                        item =
                            catalog[(catalog.indexOf(item) -
                                    1 +
                                    catalog.length) %
                                catalog.length];
                        size = 0;
                      }),
                    ),
                    const SizedBox(width: 18),
                    RoundButton(
                      icon: Icons.chevron_right_rounded,
                      tooltip: 'Next product',
                      onPressed: () => setState(() {
                        item =
                            catalog[(catalog.indexOf(item) + 1) %
                                catalog.length];
                        size = 0;
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => go(context, '/reviews'),
                  child: Row(
                    children: [
                      const Text(
                        'Available',
                        style: TextStyle(
                          color: Color(0xFF95BF58),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.star_rounded, color: orange, size: 16),
                      const SizedBox(width: 5),
                      const Text('4.5 (120)', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    for (var i = 0; i < 3; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i == 2 ? 0 : 8),
                          child: ChoiceChip(
                            label: Center(
                              child: Text(
                                ['Small', 'Medium', 'Large'][i],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: size == i ? Colors.white : null,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            showCheckmark: false,
                            selected: size == i,
                            selectedColor: ink,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                            onSelected: (_) => setState(() => size = i),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        'Order ${money(item.price * quantity)}',
                        onPressed: () async {
                          await state.add(
                            item,
                            quantity,
                            ['Small', 'Medium', 'Large'][size],
                          );
                          if (context.mounted) go(context, '/cart');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      tooltip: 'Save product',
                      onPressed: () => state.toggleFavorite(item.id),
                      icon: Icon(
                        state.favorites.contains(item.id)
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Size preference: ${['Small', 'Medium', 'Large'][size]}',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YogurtPage extends StatelessWidget {
  const YogurtPage({super.key});
  @override
  Widget build(BuildContext context) => Screen(
    back: true,
    action: const CartButton(),
    child: ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const FoodImage('yogurt', height: 245),
        const SizedBox(height: 25),
        Text('Fruit yogurt', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          product('yogurt').description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Text('\$30.00', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(width: 18),
            RoundButton(
              tooltip: 'Add fruit yogurt',
              onPressed: () {
                AppScope.of(context).add(product('yogurt'));
                toast(context, 'Fruit yogurt added to bag');
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
        ProductRow(product('cereal1'), subtitle: '230 sales'),
        const SizedBox(height: 18),
        ProductRow(product('cereal2'), subtitle: '800 sales'),
      ],
    ),
  );
}

class DimsumPage extends StatefulWidget {
  const DimsumPage({super.key});
  @override
  State<DimsumPage> createState() => _DimsumPageState();
}

class _DimsumPageState extends State<DimsumPage> {
  int quantity = 1;
  bool more = false;
  @override
  Widget build(BuildContext context) => Screen(
    back: true,
    action: const CartButton(),
    bottom: PrimaryButton(
      'Add to bag · ${money(18 * quantity)}',
      onPressed: () {
        AppScope.of(context).add(product('dimsum'), quantity);
        go(context, '/cart');
      },
    ),
    child: ListView(
      children: [
        const FoodImage('dimsum', height: 250),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chinese food',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Dimsum',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Decrease quantity',
              onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
              icon: const Icon(Icons.remove_circle_rounded),
            ),
            Text('$quantity', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              tooltip: 'Increase quantity',
              onPressed: () => setState(() => quantity++),
              icon: const Icon(Icons.add_circle_rounded),
            ),
          ],
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () => setState(() => more = !more),
          child: Text(
            product('dimsum').description,
            maxLines: more ? null : 3,
            overflow: more ? null : TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => more = !more),
          child: Text(more ? 'Less' : 'More'),
        ),
        const SizedBox(height: 6),
        Text('Pairs well with', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        SizedBox(
          height: 136,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              for (final id in ['avocado', 'tea', 'banana'])
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 110,
                    child: SoftCard(
                      padding: const EdgeInsets.all(12),
                      onTap: () =>
                          go(context, '/detail', arguments: product(id)),
                      child: Column(
                        children: [
                          FoodImage(product(id).image, height: 65),
                          const SizedBox(height: 8),
                          Text(
                            product(id).name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            money(product(id).price),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}
