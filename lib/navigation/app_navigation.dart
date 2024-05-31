import 'package:final_project/screens/favorite_screen.dart';
import 'package:final_project/screens/history_order_screen.dart';
import 'package:final_project/screens/home_screen.dart';
import 'package:final_project/screens/main_wrapper.dart';
import 'package:final_project/screens/order_detail_screen.dart';
import 'package:final_project/screens/profile_screen.dart';
import 'package:final_project/screens/shopping_cart_screen.dart';
import 'package:final_project/screens/sign_in_screen.dart';
import 'package:final_project/screens/sign_up_screen.dart';
import 'package:final_project/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  AppNavigation._();

  static String initial = "/splash-screen";

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorMyOrders = GlobalKey<NavigatorState>(debugLabel: 'shellMyOrders');
  static final _shellNavigatorFavorite = GlobalKey<NavigatorState>(debugLabel: 'shellFavorite');
  static final _shellNavigatorProfile = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// Splash Screen
      GoRoute(
        path: "/splash-screen",
        name: "splash-screen",
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),

      /// SignUp
      GoRoute(
        path: "/signup",
        name: "signup",
        builder: (BuildContext context, GoRouterState state) => const SignUpScreen(),
      ),

      /// SignIn
      GoRoute(
        path: "/signin",
        name: "signin",
        builder: (BuildContext context, GoRouterState state) => const SignInScreen(),
      ),

      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: "/home",
                name: "home",
                builder: (BuildContext context, GoRouterState state) =>
                const HomeScreen(),
              ),
              GoRoute(
                path: "/shopping-cart",
                name: "shopping-cart",
                builder: (BuildContext context, GoRouterState state) =>
                const ShoppingCartScreen(),
              ),
            ],
          ),

          /// My Orders
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMyOrders,
            routes: <RouteBase>[
              GoRoute(
                path: "/history-order",
                name: "history-order",
                builder: (BuildContext context, GoRouterState state) =>
                const HistoryOrderScreen(),
              ),
            ],
          ),

          /// Favorite
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFavorite,
            routes: <RouteBase>[
              GoRoute(
                path: "/favorite",
                name: "favorite",
                builder: (BuildContext context, GoRouterState state) =>
                const FavoriteScreen(),
              ),
            ],
          ),

          /// Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: "/profile",
                name: "profile",
                builder: (BuildContext context, GoRouterState state) =>
                const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
