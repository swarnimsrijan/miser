import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'destinations.dart';

/// Responsive scaffold: navigation rail on wide screens, bottom bar on phones.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  static int _indexFor(List<AppDestination> dests, String location) {
    final i = dests.indexWhere(
      (d) => d.path == '/' ? location == '/' : location.startsWith(d.path),
    );
    return i;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= railBreakpoint) {
      final index = _indexFor(allDestinations, location);
      return Scaffold(
        body: Row(
          children: [
            _ScrollableRail(
              extended: width >= 1240,
              selectedIndex: index < 0 ? null : index,
              onSelected: (i) => context.go(allDestinations[i].path),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }
    var index = _indexFor(phoneDestinations, location);
    if (index < 0 && moreDestinations.any((d) => location.startsWith(d.path))) {
      index = phoneDestinations.indexOf(moreDest);
    }
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (i) => context.go(phoneDestinations[i].path),
        destinations: [
          for (final d in phoneDestinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}

class _ScrollableRail extends StatelessWidget {
  const _ScrollableRail({
    required this.extended,
    required this.selectedIndex,
    required this.onSelected,
  });

  final bool extended;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: NavigationRail(
              extended: extended,
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelected,
              labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.savings, color: theme.colorScheme.primary, size: 32),
                    if (extended) ...[
                      const SizedBox(width: 8),
                      Text('Miser', style: theme.textTheme.titleLarge),
                    ],
                  ],
                ),
              ),
              destinations: [
                for (final d in allDestinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Phone-only page listing the destinations that don't fit the bottom bar.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          for (final d in moreDestinations)
            ListTile(
              leading: Icon(d.icon),
              title: Text(d.label),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(d.path),
            ),
        ],
      ),
    );
  }
}
