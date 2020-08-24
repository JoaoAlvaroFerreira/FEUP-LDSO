import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
    );
  }
}
