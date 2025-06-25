import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ 追加

  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temple List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(
            Colors.greenAccent.withOpacity(0.4),
          ),
        ),
        useMaterial3: false,
      ),
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
