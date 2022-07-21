import 'dart:io';    
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore    
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';    
import 'package:image_picker/image_picker.dart'; // For Image Picker    
 
import 'package:pharmacy/Constraint.dart';
import 'package:pharmacy/Registerationwidget.dart';
import 'package:path/path.dart' as Path;


class addcategory extends StatefulWidget {
  const addcategory({Key? key}) : super(key: key);

  @override
  State<addcategory> createState() => _addcategoryState();
}


class _addcategoryState extends State<addcategory> {
 File? _image;    
 String ?_uploadedFileURL; 
   final picker = ImagePicker(); 
FirebaseStorage storage = FirebaseStorage.instance;
 Future chooseFile() async {   
    final pickedfile = await picker.pickImage(source:ImageSource.gallery);
      setState(() {
        _image=File(pickedfile!.path);
      });
  
      
 } 
 
 uploadProfileImage() async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(_image.toString());
    UploadTask uploadTask = reference.putFile(_image!);
    TaskSnapshot snapshot = await uploadTask;
  _uploadedFileURL= await snapshot.ref.getDownloadURL();
    print(_uploadedFileURL);
  }

  TextEditingController Name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
 add()async{
     try {
    
 await FirebaseFirestore.instance.collection("category").doc().set(
  {
    "cname" : Name.text,
    "cimage" :_uploadedFileURL,
  
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
  
  
  @override

  
  Widget build(BuildContext context) {
    
    return  Scaffold(
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
          child: Text("add category",
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
                 ElevatedButton(    
                   child: Text('upload image'),    
                   onPressed: uploadProfileImage,   
                   style: ElevatedButton.styleFrom(
                    primary: Color(0xff02fa561),
                   ), ),
                  
                 
                 
                    const SizedBox(
                      height: 20,
                    ),
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
                    SizedBox(
                      height: 60,
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
      labelText: "category Name",
      obscureText: false,
      textInputType: TextInputType.name,
      actionKeyboard: TextInputAction.done,
      functionValidate: requiredValidator,
      controller: Name,);
    }
}
