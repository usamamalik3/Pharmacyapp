import 'package:flutter/material.dart';
import 'package:pharmacy/Constraint.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: const Center(
          child: Text("Admin",
          style: TextStyle(color: Colors.white,
          fontSize: 24,
          ),),
        ),
      ),
      body: Container(),
    );
    
  }
}