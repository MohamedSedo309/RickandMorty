import 'package:flutter/material.dart';
import 'package:rick_and_morty_bloc/app_router.dart';

void main() {
  runApp( Rick_and_Morty_App(app_router: App_Router(),));
}

class Rick_and_Morty_App extends StatelessWidget {
  final App_Router app_router;

  const Rick_and_Morty_App({super.key, required this.app_router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: app_router.generateRoute,
    );
  }
}

