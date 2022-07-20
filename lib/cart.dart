import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmacy/Checkout.dart';
import 'package:pharmacy/constraint.dart';
class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  
  State<Cart> createState() => _CartState();
}


class _CartState extends State<Cart> {
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

  @override
  Widget build(BuildContext context) {
    
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: const Center(
          child: Text("Cart",
          style: TextStyle(color: Colors.white,
          fontSize: 24,
          ),),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
              .collection("cart-items")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
              .snapshots(),
                builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                int total = 0;
                  if (snapshot.hasError) {
              return const Center(
                child: Text("Something is wrong"),
              );
                  }
            
                  return ListView.builder(
                itemCount:
                snapshot.data == null ? 0 : snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot _documentSnapshot =
                  snapshot.data!.docs[index];
                  num total=0;
                  total += _documentSnapshot["price"];
                  print(total);

            
                  return  Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      
                       FirebaseFirestore.instance
                              .collection("cart-items")
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("items")
                              .doc(_documentSnapshot.id)
                              .delete();
                     
                    });
                  },
                   background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        SvgPicture.asset("icon/Trash.svg"),
                      ],
                    ),
                  ),
                 
                  child: Row(
                    
                  children: [
              SizedBox(
                width: 88,
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    padding: EdgeInsets.all((10)),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(_documentSnapshot['images']),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _documentSnapshot['name'],
                    style: TextStyle(color: primarycolor, fontSize: 16),
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: "\$ ${_documentSnapshot['price']}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: primarycolor),
                      children: [
                        TextSpan(
                            text: " x",
                            style: Theme.of(context).textTheme.bodyText1),
                             TextSpan(
                            text: _documentSnapshot['Quantity'].toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                            TextSpan(
                              text: "=",
                              style: Theme.of(context).textTheme.bodyText1
                            ),
                          
                            TextSpan(
                            text: _documentSnapshot['totalprice'].toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  )
                ],
              )
                  ],
                ),
            
                  
                
                  );
                });
                },
              ),
            ),
            
            Align(
              alignment: Alignment.bottomCenter,
              child:  
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: ElevatedButton(
                            onPressed: () {
                               Navigator.push(
            context, MaterialPageRoute(builder: (context) => checkout()));
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
                                child:  Center(
                                  child: Text(
                                    total.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Roboto-Thin',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            ),
                       ),
            
                    ),
        
                 
                 
                   
        
          ],
        ),
      
      ),
    );
  }
}