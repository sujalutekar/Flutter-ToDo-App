import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFEEEFF5),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar(
            //   backgroundColor: const Color(0xFFEEEFF5),
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            // ),
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'Sujal Uttekar',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
