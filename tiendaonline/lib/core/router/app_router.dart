import 'package:go_router/go_router.dart';

import 'package:tiendaonline/presentation/screens/home_screen.dart';
import 'package:tiendaonline/presentation/screens/product_detail_screen.dart';

import 'package:tiendaonline/presentation/screens/admin/admin_layout.dart';
import 'package:tiendaonline/presentation/screens/admin/admin_dashboard_screen.dart';
import 'package:tiendaonline/presentation/screens/admin/admin_product_list_screen.dart';
import 'package:tiendaonline/presentation/screens/admin/admin_product_edit_screen.dart';
import 'package:tiendaonline/presentation/screens/admin/admin_settings_screen.dart';
import 'package:tiendaonline/presentation/screens/admin/login_screen.dart';
import 'package:flutter/foundation.dart';

final appRouter = GoRouter(
  initialLocation: kIsWeb ? '/' : '/admin/login',
  routes: [
    GoRoute(
      path: '/admin/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/product/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return ProductDetailScreen(slug: slug);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AdminLayout(currentLocation: state.uri.path, child: child);
      },
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/products',
          builder: (context, state) => const AdminProductListScreen(),
          routes: [
            GoRoute(
              path: 'edit/:id', // Sub-route for editing
              builder: (context, state) =>
                  AdminProductEditScreen(productId: state.pathParameters['id']),
            ),
            GoRoute(
              path: 'new',
              builder: (context, state) => const AdminProductEditScreen(),
            ),
            GoRoute(
              path: 'new',
              builder: (context, state) => const AdminProductEditScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/admin/settings',
          builder: (context, state) => const AdminSettingsScreen(),
        ),
      ],
    ),
  ],
);
