import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendaonline/presentation/providers/providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),

            // KPIs
            productsAsync.when(
              data: (products) {
                final totalValue = products.fold<double>(
                  0,
                  (sum, p) => sum + (p.price.base),
                ); // Simplified logic
                final totalCost = products.fold<double>(
                  0,
                  (sum, p) => sum + p.cost,
                );
                final margin = totalValue - totalCost;

                return GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 4
                      : 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _StatCard(
                      title: 'Productos Totales',
                      value: products.length.toString(),
                      icon: Icons.inventory,
                    ),
                    _StatCard(
                      title: 'Valor Inventario',
                      value: 'L ${totalValue.toStringAsFixed(0)}',
                      icon: Icons.attach_money,
                    ),
                    _StatCard(
                      title: 'Costo Inventario',
                      value: 'L ${totalCost.toStringAsFixed(0)}',
                      icon: Icons.money_off,
                    ),
                    _StatCard(
                      title: 'Margen Latente',
                      value: 'L ${margin.toStringAsFixed(0)}',
                      icon: Icons.trending_up,
                      color: Colors.green,
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 32),

            Text('Actividad Reciente', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Nueva orden #1023'),
                subtitle: Text('Hace 5 minutos'),
                trailing: Text('L 12,500'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color ?? theme.colorScheme.primary),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
