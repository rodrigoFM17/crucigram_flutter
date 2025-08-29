import 'dart:typed_data';

import 'package:go_router/go_router.dart';
import 'package:pdf_test/src/features/main/screens/main_screen.dart';
import 'package:pdf_test/src/features/print/screens/print_screen.dart';

final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/print',
      builder: (context, state) {
        final pdf = state.extra! as Uint8List;
        return PrintScreen(pdf: pdf);
      }
    )
  ]
);