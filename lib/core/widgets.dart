import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../data/image_geometry.dart';
import 'app_state.dart';
import 'theme.dart';

void go(BuildContext context, String path, {Object? arguments}) =>
    Navigator.pushNamed(context, path, arguments: arguments);
void home(BuildContext context) =>
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
void openProduct(BuildContext context, Product item) =>
    go(context, switch (item.id) {
      'yogurt' => '/yogurt',
      'dimsum' => '/dimsum',
      _ => '/detail',
    }, arguments: item);
void toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );

class FoodImage extends StatelessWidget {
  const FoodImage(
    this.name, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });
  final String name;
  final double? height, width;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    final g = imageGeometry[name]!;
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: FittedBox(
          fit: fit,
          child: SizedBox(
            width: g.$5,
            height: g.$6,
            child: Stack(
              children: [
                Positioned(
                  left: -g.$3,
                  top: -g.$4,
                  width: g.$1,
                  height: g.$2,
                  child: Image.asset(
                    'assets/images/$name.png',
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.onTap,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color:
          color ??
          (Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2D303E)
              : Colors.white),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .065),
          blurRadius: 16,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.dark = false,
    this.secondary = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool dark, secondary;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 54,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: secondary
            ? Theme.of(context).dividerColor
            : dark
            ? ink
            : orange,
        foregroundColor: secondary
            ? Theme.of(context).colorScheme.onSurface
            : Colors.white,
        disabledBackgroundColor: orange.withValues(alpha: .35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: Text(label),
    ),
  );
}

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    this.icon = Icons.add,
    required this.onPressed,
    this.color,
    this.size = 44,
    this.tooltip,
  });
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;
  final String? tooltip;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: SoftCard(
      padding: EdgeInsets.zero,
      color: color,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        iconSize: 19,
        color: color == orange ? Colors.white : null,
        icon: Icon(icon),
      ),
    ),
  );
}

class Stars extends StatelessWidget {
  const Stars({super.key, this.size = 13});
  final double size;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (_) => Icon(Icons.star_rounded, size: size, color: orange),
    ),
  );
}

class Screen extends StatelessWidget {
  const Screen({
    super.key,
    required this.child,
    this.title,
    this.tab,
    this.back = false,
    this.action,
    this.bottom,
    this.padding = const EdgeInsets.symmetric(horizontal: 28),
  });
  final Widget child;
  final String? title;
  final int? tab;
  final bool back;
  final Widget? action, bottom;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: tab != null
        ? BottomTabs(selected: tab!)
        : bottom == null
        ? null
        : SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
              child: bottom,
            ),
          ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              if (title != null || back || action != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(back ? 14 : 28, 14, 20, 12),
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        if (back)
                          IconButton(
                            tooltip: 'Back',
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                home(context);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 21,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            title ?? '',
                            textAlign: back ? TextAlign.center : TextAlign.left,
                            style: back
                                ? Theme.of(context).textTheme.titleMedium
                                : Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        if (action != null)
                          action!
                        else if (back)
                          const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Padding(padding: padding, child: child),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key, required this.selected});
  final int selected;
  static const paths = [
    '/home',
    '/calendar',
    '/shopping',
    '/tutorials',
    '/account',
  ];
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: List.generate(5, (i) {
          const icons = [
            Icons.storefront_outlined,
            Icons.calendar_month_outlined,
            Icons.shopping_cart_outlined,
            Icons.slow_motion_video_rounded,
            Icons.person_outline_rounded,
          ];
          const labels = [
            'Home',
            'Calendar',
            'Shopping',
            'Tutorials',
            'Account',
          ];
          return Expanded(
            child: InkWell(
              key: ValueKey('tab-$i'),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                paths[i],
                (_) => false,
              ),
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 48,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          icons[i],
                          size: 21,
                          color: i == selected
                              ? Theme.of(context).colorScheme.onSurface
                              : const Color(0xFFBFBFBF),
                        ),
                        if (i == selected)
                          const Positioned(
                            bottom: -2,
                            right: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: orange,
                                shape: BoxShape.circle,
                              ),
                              child: SizedBox(width: 6, height: 6),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 10,
                        color: i == selected
                            ? Theme.of(context).colorScheme.onSurface
                            : const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}

class CartButton extends StatelessWidget {
  const CartButton({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Badge(
      isLabelVisible: state.count > 0,
      label: Text('${state.count}'),
      backgroundColor: orange,
      child: IconButton(
        tooltip: 'Shopping bag',
        onPressed: () => go(context, '/cart'),
        icon: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}

class ProductRow extends StatelessWidget {
  const ProductRow(
    this.item, {
    super.key,
    this.subtitle = 'Mix fruits',
    this.trailing,
  });
  final Product item;
  final String subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => SoftCard(
    onTap: () => openProduct(context, item),
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        FoodImage(item.image, width: 78, height: 78),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: Theme.of(context).textTheme.titleMedium),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(
                money(item.price),
                style: const TextStyle(color: orange, fontSize: 13),
              ),
            ],
          ),
        ),
        trailing ??
            IconButton(
              tooltip: 'Save ${item.name}',
              onPressed: () => AppScope.of(context).toggleFavorite(item.id),
              icon: Icon(
                AppScope.of(context).favorites.contains(item.id)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: orange,
                size: 19,
              ),
            ),
      ],
    ),
  );
}
