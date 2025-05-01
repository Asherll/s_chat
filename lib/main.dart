import 'package:chatapp/pages/testtlg.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Chat());
}

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optional: removes debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:Testtlg(), // This loads your custom page
    );
  }
}
