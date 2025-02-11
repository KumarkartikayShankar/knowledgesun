import 'package:flutter/material.dart';
import 'package:knowledgesun/components/drawer.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar:  AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const CustomDrawer(),
      body: Text("Account"),
    );;
  }
}