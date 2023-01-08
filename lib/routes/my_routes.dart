import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:topup_shop/main.dart';
import 'package:topup_shop/screens/admin_screen.dart';
import 'package:topup_shop/screens/login_screen.dart';
import 'package:topup_shop/screens/offers_screen.dart';

final GoRouter routerConfig = GoRouter(
  initialLocation: Routes.home,
  routes: <RouteBase>[
    GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) {
          return const MyHomePage();
        },
        routes: [
          GoRoute(
            path: Routes.offers,
            builder: (BuildContext context, GoRouterState state) {
              Map<String, dynamic> extra;
              if (state.extra != null) {
                extra = state.extra as Map<String, dynamic>;
              } else {
                extra = {};
              }
              return OfferScreen(
                name: extra["name"],
                gameId: extra["gameId"],
              );
            },
          ),
          GoRoute(
            path: Routes.login,
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
          ),
          GoRoute(
            path: Routes.adming,
            builder: (BuildContext context, GoRouterState state) {
              return const AdminScreen();
            },
          ),
        ]),
  ],
);

class Routes {
  static const String home = "/";
  static const String offers = "offers";
  static const String adming = "admin";
  static const String login = "login";

  static get getOffers {
    return home + offers;
  }

  static get getLogin {
    return home + login;
  }

  static get getAdmin {
    return home + adming;
  }
}
