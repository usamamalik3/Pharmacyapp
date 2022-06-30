import 'package:flutter/cupertino.dart';

class Product {
  String pName, pDescription, pCategory, pID;
  String pimageUrl;
  int pPrice;
  int? pQuantity;

  Product({
    this.pQuantity,
    required this.pimageUrl,
    required this.pID,
    required this.pName,
    required this.pPrice,
    required this.pDescription,
    required this.pCategory,
  });
}

class categorymodel {
  final String cimageUrl;
  final String pName;
  

  categorymodel( {

    required this.cimageUrl,
    required this.pName,
  });
}
