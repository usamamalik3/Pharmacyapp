import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pay/pay.dart';
import 'package:pharmacy/Constraint.dart';

import 'package:pharmacy/Registerationwidget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pharmacy/models/order.dart';
import 'package:pharmacy/my_googleay.dart';





class checkout extends StatefulWidget {
  const checkout({Key? key}) : super(key: key);

  @override
  State<checkout> createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {

 double sum = 0;
       double total = 0;
  @override
  void initState() {
FirebaseFirestore.instance.collection("cart-items").get().then((querySnapshot) {
  querySnapshot.docs.forEach((result) {
    FirebaseFirestore.instance
       .collection("cart-items")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        sum = sum + result.data()['totalprice'];
      });
       setState(() {
          total = sum;
          });
     
    });
  });
 
});

    // TODO: implement initState
    super.initState();
  }





   TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();

  TextEditingController street = TextEditingController();

  TextEditingController city = TextEditingController();

  TextEditingController pincode = TextEditingController();
  final _formKey = GlobalKey<FormState>();

getdetail() async {
 var rng = Random();
 int code = rng.nextInt(900000) + 100000;
  final _fireStore = FirebaseFirestore.instance;

    // Get docs from collection reference
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _fireStore.collection("cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").get();

    // Get data from docs and convert map to List

  //for a specific field
  // final allData =
  //         querySnapshot.docs;
           final allData =
          querySnapshot.docs.map((doc) => doc.get('name')).toList();



    print(allData);


             
  try {
    
  FirebaseFirestore.instance.collection("orders").doc(FirebaseAuth.instance.currentUser!.email).set(
  {
    "first name" : firstName.text,
    "last name" : lastName.text,
    "mobile  no" : mobileNo.text,
    "order no"   : code,
    "Total price" : total,
    "product" : allData,
    "street" : street.text,
    "city" : city.text,
  
  }).then((value) =>  Fluttertoast.showToast(
                                msg:
                                    "Order succesfully your order no is  $code",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: primarycolor,
                                fontSize: 16.0),);
                       
} on PlatformException catch (e) {
  print(e);
    Fluttertoast.showToast(
                msg: "something went wrong",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: primarycolor,
                fontSize: 18.0);
  return;
}


   
}

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: const Center(
          child: Text("Confirm your order",
          style: TextStyle(color: Colors.white,
          fontSize: 24,
          ),),
        ),
      ),
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
                      "Add you address",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: primarycolor, fontSize: 40),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                   _firstname(),
                   _lastname(),
                   _Mobileno(),
                   _street(),
                   _city(),
                 
                    const SizedBox(
                      height: 20,
                    ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 90.0),
                          child: Text("Total price",
                           style: TextStyle(
                            color: primarycolor,
                                        
                                        fontWeight: FontWeight.w300,
                                        fontSize: 24,)),
                        ),
                        Text(total.toString(),
                     style:  TextStyle(
                        color: primarycolor,
                                        fontFamily: 'Roboto-Thin',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 24,)),
                    ],
                   ),
                      ),
                      GooglePayButton(
  paymentConfigurationAsset: 'sample_payment_configuration.json',
  paymentItems: [
  PaymentItem(
    label: 'Total',
    amount: total.toString(),
    status: PaymentItemStatus.final_price,
  )
],
  style: GooglePayButtonStyle.black,
  width: 200,

  type: GooglePayButtonType.pay,
  onPaymentResult: onGooglePayResult,
),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            getdetail();
                          
                         
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
                                  "Confirm order",
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
                    const SizedBox(
                      height: 20,
                    ),
                 
                  
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
  void onGooglePayResult(paymentResult) {
     getdetail();
  // Send the resulting Google Pay token to your server or PSP
}


  String? requiredValidator(value, messageError) {
    if (value.isEmpty) {
      return messageError;
    }
    return null;
  }
 

//  Form(child: Column(
   Widget _firstname() {
    return Regformwidget(
      labelText: "First Name",
      obscureText: false,
      textInputType: TextInputType.name,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller: firstName,
    );
  }
   Widget _lastname() {
    return Regformwidget(
      labelText: "Last Name",
      obscureText: false,
      textInputType: TextInputType.name,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller:lastName,
    );
  }

   Widget _Mobileno() {
    return Regformwidget(
      labelText: "Mobile no",
      obscureText: false,
      textInputType: TextInputType.phone,
      actionKeyboard: TextInputAction.done,
      functionValidate: MultiValidator([
           RequiredValidator(errorText: "Required"),
        MinLengthValidator(11, errorText: "phone no should be 11 character"),
      ]),
      controller: mobileNo,
    );
  }

  Widget _street() {
    return Regformwidget(
      labelText: "Street Adress",
      obscureText: false,
      textInputType: TextInputType.streetAddress,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller: street,
    );
  }
  Widget _city() {
    return Regformwidget(
      labelText: "City",
      obscureText: false,
      textInputType: TextInputType.streetAddress,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller: city,
    );
  }



    
  }
