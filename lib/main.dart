import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add your providers here
      ],
      child: MaterialApp(
        title: 'Bali Raja',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('id', 'ID'),
        ],
        home: AuthWrapper(),
      ),
    );
  }
}
