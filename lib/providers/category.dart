import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/models/product.dart';

class ctgoryprovider with ChangeNotifier {
  List<categorymodel> categorymodellist = [];
  categorymodel? Categorymodel;
  Future<void> getCategoryproduct() async {
    List<categorymodel> list = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("category").get();
    querySnapshot.docs.forEach((element) {
      Categorymodel = categorymodel(
          cimageUrl: element.data()["cimage"], pName: element.data()["cname"]);
      list.add(Categorymodel!);
    });
    categorymodellist = list;
  }

  List<categorymodel> get getcategorymodellist {
    return categorymodellist;
  }
}
