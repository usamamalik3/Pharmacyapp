import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pharmacy/Home.dart';
import 'package:pharmacy/Register.dart';

import '../Constraint.dart';
import 'Registerationwidget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String role = "user";
  bool _isObscure = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (Context) => Homepage()));
      }
    });

    @override
    void initState() {
      super.initState();
      this.checkAuthentification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 90.0),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // if you need this
              side: BorderSide(
                color: Colors.black.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign in",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: primarycolor, fontSize: 40),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildemail(),
                    _buildPassword(),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            _login();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: primarycolor,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Container(
                              height: 60,
                              width: 300,
                              child: const Center(
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                    fontFamily: 'Roboto-Thin',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Text(
                      "Do not have account ?",
                      style: TextStyle(fontFamily: 'Roboto-Thin', fontSize: 14),
                    )),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                          child: Text(
                            "Signin",
                            style: TextStyle(
                                fontFamily: 'Roboto-Thin',
                                fontSize: 16,
                                color: primarycolor),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildemail() {
    return Regformwidget(
      labelText: "Email",
      obscureText: false,
      textInputType: TextInputType.emailAddress,
      actionKeyboard: TextInputAction.done,
      functionValidate: MultiValidator([
        RequiredValidator(errorText: "Required"),
        EmailValidator(errorText: "Email is not valid")
      ]),
      controller: emailController,
    );
  }

  String? requiredValidator(value, messageError) {
    if (value.isEmpty) {
      return messageError;
    }
    return null;
  }

  Widget _buildPassword() {
    return Regformwidget(
      labelText: "Password",
      obscureText: _isObscure,
      suffixicon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          }),
      textInputType: TextInputType.visiblePassword,
      actionKeyboard: TextInputAction.done,
      functionValidate: MultiValidator([
        RequiredValidator(errorText: "Required"),
        MinLengthValidator(8, errorText: "Password should b 8 character"),
        PatternValidator(r'(?=.*?[#?!@$%^&*-])',
            errorText: "Password must have atleast one special character"),
      ]),
      controller: passwordController,
    );
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      role = snap["role"];
    });
    print(role);
    if (role == "user") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    }
<<<<<<< HEAD
    // } else if (role == "admin") {
    //   // Navigator.push(
    //   //     context, MaterialPageRoute(builder: (context) => AdminScreen()));
    // }
=======
    else if (role == "admin") {
      Text("WAit for admin");
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => AdminScreen()));
    }
>>>>>>> acd91ed (category)
  }

  _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // ignore: deprecated_member_use
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        if (user != null) {
          _checkRole();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    showError(errormessage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Error"),
            content: new Text(errormessage),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
