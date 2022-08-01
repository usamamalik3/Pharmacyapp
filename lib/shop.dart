import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Detail.dart';

import 'constraint.dart';
import 'models/product.dart';

class Shop extends StatefulWidget {
  Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
    List<Product> _products = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  



  fetchproduct() async {
    QuerySnapshot p = await firestoreInstance.collection("products").get();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: primarycolor,
       
        title: const Text(
          'pharmacy',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
                    children: List.generate(
                    
                      _products.length,
                      (index) => GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MedDetail(product: _products[index])))
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 25, left: 20, top: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(blurRadius: 10, color: Colors.grey)
                            ],
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 25, left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                           
                                            
                                            Text(
                                              _products[index].pName,
                                              style: const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                       const  SizedBox(height: 15),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  2.2,
                                          child: Text(
                                            _products[index].pCategory,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Text(
                                          "${_products[index].pPrice} \$",
                                          style:const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                 const  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 45, vertical: 20),
                                        decoration: BoxDecoration(
                                            color: primarycolor,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            )),
                                        child: Icon(Icons.add, size: 20),
                                      ),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                transform:
                                    Matrix4.translationValues(30.0, 25.0, 0.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 20)
                                    ]),
                                child: Hero(
                                  tag: _products[index].pimageUrl,
                                  child: Image.network(_products[index].pimageUrl,
                                      width: MediaQuery.of(context).size.width /
                                          2.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}