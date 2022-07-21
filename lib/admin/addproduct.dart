import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy/Constraint.dart';
import 'package:pharmacy/Registerationwidget.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({Key? key}) : super(key: key);

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  File? _image;    
 String ?_uploadedFileURL; 
   final picker = ImagePicker(); 
FirebaseStorage storage = FirebaseStorage.instance;
 Future chooseFile() async {   
    final pickedfile = await picker.pickImage(source:ImageSource.gallery);
      setState(() {
        _image=File(pickedfile!.path);
      });
        Reference reference = FirebaseStorage.instance
        .ref()
        .child(_image.toString());
    UploadTask uploadTask = reference.putFile(_image!);
    TaskSnapshot snapshot = await uploadTask;
  _uploadedFileURL= await snapshot.ref.getDownloadURL();
  
      
 } 
 
//  uploadProfileImage() async {
  
//     print(_uploadedFileURL);
//   }

  
   TextEditingController productName = TextEditingController();
  TextEditingController productdesc = TextEditingController();
  TextEditingController productprice = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  add()async{
     try {
    
 await FirebaseFirestore.instance.collection("products").doc().set(
  {
    "pName" : productName.text,
    "pImage" :_uploadedFileURL,
    "pDescription" : productdesc.text,
    "pPrice" : int.parse(productprice.text),
    "pCategory" : _selectedValue,
  }).then((value) =>  Fluttertoast.showToast(
                                msg:
                                    "category added successfully",
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
 
  
  
  var _selectedValue;
  @override
  Widget build(BuildContext context) {

   return Scaffold(
      appBar: AppBar(
         elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: primarycolor,
        title: const Center(
          child: Text("Add a product",
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
                   
                  name(),
                  price(),
                  desc(),
                   StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('category')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            List<DropdownMenuItem> typeItems = [];

                            for (int i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              DocumentSnapshot snap = snapshot.data!.docs[i];
                              typeItems.add(DropdownMenuItem(
                                value: '${snap["cname"]}',
                                child: Text(snap["cname"]),
                              ));
                            }

                            return DropdownButton<dynamic>(
                                hint: const Text('choose category'),
                                value: _selectedValue,
                                items: typeItems,
                                onChanged: (typeValue) {
                                  setState(() {
                                    _selectedValue = typeValue;
                                  });
                                });
                          }
                        }),
                        _image != null    
               ? Image.file(    
                   _image!,    
                   height: 150,    
                 )    
               : Text("No image selcted"),    
           _image == null    
               ?  ElevatedButton(    
                   child: Text('Choose File'),    
                   onPressed: chooseFile,   
                   style: ElevatedButton.styleFrom(
                    primary: Color(0xff02fa561),
                   ), 
                       
                 ):
                 Container(),
                 SizedBox(height: 20,),
                
 Center(
                      child: ElevatedButton(
                          onPressed: () {
                            add();
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
                                  "ADD",
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
                  ]
                ))
            )
          )
        )
          )
      )
    );

           
  }
  String? requiredValidator(value, messageError) {
    if (value.isEmpty) {
      return messageError;
    }
    return null;
  }
 
    Widget name() {
    return Regformwidget(
      labelText: "product Name",
      obscureText: false,
      textInputType: TextInputType.name,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller: productName,
    );
  }
   Widget desc() {
    return Regformwidget(
      labelText: "Description",
      obscureText: false,
      textInputType: TextInputType.multiline,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller:productdesc,
    );
  }

   Widget price() {
    return Regformwidget(
      labelText: "price",
      obscureText: false,
      textInputType: TextInputType.number,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller: productprice,
    );
  }

  
 
}