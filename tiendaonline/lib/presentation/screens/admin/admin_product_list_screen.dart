import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendaonline/presentation/providers/providers.dart';

import 'package:go_router/go_router.dart';

class AdminProductListScreen extends ConsumerWidget {
  const AdminProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/admin/products/new');
            },
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text('Producto')),
                  DataColumn(label: Text('SKU (Var)')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Costo')),
                  DataColumn(label: Text('Precio')),
                  DataColumn(label: Text('Prov.')),
                  DataColumn(label: Text('Ubic.')),
                ],
                rows: products.map((p) {
                  final totalStock = p.hasVariants
                      ? p.variants.fold(0, (sum, v) => sum + v.stock)
                      : (p.variants.isEmpty ? 0 : p.variants.first.stock);

                  return DataRow(
                    onSelectChanged: (_) {
                      context.go('/admin/products/edit/${p.id}');
                    },
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 200,
                          child: Text(p.title, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      DataCell(
                        Text(
                          p.hasVariants ? '${p.variants.length} vars' : 'N/A',
                        ),
                      ),
                      DataCell(Text(totalStock.toString())),
                      DataCell(Text(p.cost.toStringAsFixed(2))),
                      DataCell(Text(p.price.base.toStringAsFixed(2))),
                      DataCell(Text(p.supplierName)),
                      DataCell(Text(p.warehouseLocation)),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
