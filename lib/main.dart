import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:las_palmas/src/providers/plants_provider.dart';
import 'package:las_palmas/src/widgets/tabbar_bottom.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Status bar color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return ChangeNotifierProvider(
      create: (_) => PlantsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'SegoeUI',
            textSelectionTheme:
                const TextSelectionThemeData(cursorColor: Color(0xFF0EEB93))),
        home: const TabbarBottom(),
      ),
    );
  }
}
