import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/cart.dart';
import 'package:pharmacy/constraint.dart';

import 'models/product.dart';

class MedDetail extends StatefulWidget {
  final Product product;
  MedDetail({Key? key, required this.product}) : super(key: key);

  @override
  State<MedDetail> createState() => _MedDetailState();
}

class _MedDetailState extends State<MedDetail> {
  Future addToCart(int quantity) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    int totalprice=widget.product.pPrice*quantity;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("cart-items");

    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc(widget.product.pID)
        .set({
      "name": widget.product.pName,
      "price": widget.product.pPrice,
      "images": widget.product.pimageUrl,
      "Quantity": quantity,
      "totalprice" : totalprice,
    }).then((value) => print("Added to cart"));
  }

  checkcart() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    bool _sameItemCheck = false;

    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection("cart-items").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        firestoreInstance
            .collection("cart-items")
            .doc(currentUser!.email)
            .collection("items")
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs
              .any((element) => element.id == widget.product.pID)) {
            _sameItemCheck = true;

            Fluttertoast.showToast(
                msg: "product is already added",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: primarycolor,
                fontSize: 18.0);
          } else {
            _sameItemCheck = false;
            addToCart(quantity);
          }
        });
      });
    });
  }

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primarycolor,
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()));
            },
            icon: const Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .35,
            padding: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            child: Image.network(widget.product.pimageUrl),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.pCategory,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product.pName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${widget.product.pPrice}\$",
                              style:const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          widget.product.pDescription,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
            
          ),
        
         
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
         
              children: [
             const Padding(
                padding:  EdgeInsets.only(right: 150.0),
                child:   Text("Quantity",  style:  TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),),
              ),
             
                quantity != 0
                    ? IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            quantity--;
                          });
                        },
                      )
                    : Container(),
                Text(quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Icon(
                Icons.heart_broken,
                size: 30,
                color: primarycolor,
              ),
            ),
            SizedBox(width: 20),
            
            Expanded(
              child: InkWell(
                onTap: () {
                  checkcart();

                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primarycolor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '+ Add to Cart',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
