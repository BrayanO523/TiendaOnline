import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendaonline/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming auth provider exposes signOut or we access auth repo
    // For now ref.read(authRepositoryProvider).signOut()

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil de Administrador'),
            subtitle: Text(
              ref.watch(authRepositoryProvider).currentUser?.email ??
                  'No usuario',
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/admin/login');
            },
          ),
        ],
      ),
    );
  }
}
