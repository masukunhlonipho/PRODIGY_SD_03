import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/contact_provider.dart';
import 'screens/contact_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactProvider(),
      child: MaterialApp(
        title: 'Contact App',
        debugShowCheckedModeBanner: false, // Removes the debug banner
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100], // Light background
        ),
        home: ContactListScreen(),
        // Add routes here for easier navigation as the app grows
        routes: {
          '/contactList': (context) => ContactListScreen(),
        },
      ),
    );
  }
}
