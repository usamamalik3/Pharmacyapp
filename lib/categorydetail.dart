import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:pharmacy/Detail.dart';
import 'package:pharmacy/constraint.dart';
import 'package:pharmacy/models/product.dart';



class ctgshop extends StatefulWidget {
    final String categoryname;
 final FirebaseAuth auth = FirebaseAuth.instance;

  ctgshop({Key? key, required this.categoryname}) : super(key: key);

  @override
  State<ctgshop> createState() => _ctgshopState();
}

class _ctgshopState extends State<ctgshop> {
  List<Product> _products = [];
  fetchproduct() async {
    QuerySnapshot p = await firestoreInstance.collection("products").where("pCategory", isEqualTo : widget.categoryname).get();
    setState(() {
      for (var document in p.docs) {
        _products.add(Product(
          pimageUrl: document["pImage"],
          pID: document.id,
          pName: document["pName"],
          pPrice: document['pPrice'],
          pDescription: document['pDescription'],
          pCategory: document['pCategory'],
        ));
      }
    });

   
  }
  @override
  void initState() {
    fetchproduct();
    super.initState();
  }
    final firestoreInstance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Center(child: Text(widget.categoryname)),
      backgroundColor: primarycolor,
      ),
      body:   GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          
      itemBuilder: (BuildContext context, int index) {
       
       
        return
         SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MedDetail(product: _products[index])));
          },
          child: Card(
             semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            
                color: primarycolor,
                 shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
                 elevation: 5,
            margin: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    
                    AspectRatio(aspectRatio: 1.5 /1,child: Image.network(_products[index].pimageUrl),),
                   
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                    _products[index].pName ,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text("${_products[index].pPrice}\$",
                    style: const TextStyle(color: Colors.white),)
                  ],
                ),
              ),
        ),
      ),
    );
        //  Singleproduct(pName: data["pName"], pimageUrl: data["pImage"], pPrice: data["pPrice"].toString());
      },
      itemCount: _products.length,
    ),
    );
  }

  }

