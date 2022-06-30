import 'package:flutter/material.dart';
import 'package:pharmacy/Registerationwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pharmacy/constraint.dart';

import 'login.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final firestoreInstance = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  TextEditingController cnfrmpasswordController = new TextEditingController();

  TextEditingController username = new TextEditingController();

  TextEditingController address = new TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 60.0),
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
                      "Sign Up",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: primarycolor, fontSize: 40),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildemail(),
                    _buildusrname(),
                    _buildAdress(),
                    _buildPassword(),
                    _buildcnfrmPassword(),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            _signup();
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
                                  "Register",
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
                      "Already have a account ?",
                      style: TextStyle(fontFamily: 'Roboto-Thin', fontSize: 14),
                    )),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
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

//  Form(child: Column(
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
      textInputType: TextInputType.visiblePassword,
      suffixicon:  IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          }),
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

  Widget _buildcnfrmPassword() {
    return Regformwidget(
      labelText: "Confirm Password",
      obscureText: _isObscure,
      textInputType: TextInputType.visiblePassword,
      suffixicon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          }),
      actionKeyboard: TextInputAction.done,
      functionValidate: (val) {
        if (val!.isEmpty) {
          return "Required";
        }
        return MatchValidator(errorText: "Passwords don't match")
            .validateMatch(val, passwordController.text);
      },
      controller: cnfrmpasswordController,
    );
  }

  Widget _buildusrname() {
    return Regformwidget(
      labelText: "Username",
      obscureText: false,
      textInputType: TextInputType.name,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller: username,
    );
  }

  Widget _buildAdress() {
    return Regformwidget(
      labelText: "Adress",
      obscureText: false,
      textInputType: TextInputType.streetAddress,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller: address,
    );
  }

  _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        var firebaseUser = FirebaseAuth.instance.currentUser;

        firestoreInstance.collection("users").doc(firebaseUser!.uid).set({
          "email": emailController.text,
          "user name": username.text,
          "address": address.text,
          "password": passwordController.text,
          "role": "user",
        }).then((value) {
          print("success!");
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "email-already-in-use":
            Fluttertoast.showToast(
                msg: e.message!,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: primarycolor,
                fontSize: 18.0);
            return e.message;
        }
      }
    }
  }
}
