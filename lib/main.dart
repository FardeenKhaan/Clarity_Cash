import 'package:clarity_cash/firebase_options.dart';
import 'package:clarity_cash/mob/expense_view_mobile.dart';
import 'package:clarity_cash/responsive_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clarity Cash',
      theme: ThemeData.dark(),
      home: ResponsiveHandler(),
      // home: ExpenseViewMobile(),
    );
  }
}
