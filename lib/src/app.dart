import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'ui/navigation/main_scaffold.dart';

class RiverStoreApp extends StatelessWidget {
  const RiverStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RiverStore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const MainScaffold(),
    );
  }
}
