import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:pharmacy/Detail.dart';
import 'package:pharmacy/constraint.dart';
import 'package:pharmacy/models/product.dart';



class ctgorysho extends StatefulWidget {
    final String categoryname;
 final FirebaseAuth auth = FirebaseAuth.instance;

  ctgorysho({Key? key, required this.categoryname}) : super(key: key);

  @override
  State<ctgorysho> createState() => _ctgoryshoState();
}

class _ctgoryshoState extends State<ctgorysho> {
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
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          
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
                    Text(_products[index].pPrice.toString(),
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



// class ctgoryshop extends StatelessWidget {
//   final String categoryname;
//  final FirebaseAuth auth = FirebaseAuth.instance;
//   final firestoreInstance = FirebaseFirestore.instance;

//   ctgoryshop({Key? key,  required this.categoryname}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     return  Scaffold(
//       appBar: AppBar(title: Center(child: Text(categoryname)),
//       backgroundColor: primarycolor,
//       ),
//       body:  StreamBuilder(
//       stream: firestoreInstance.collection("products").where("pCategory", isEqualTo : categoryname).snapshots(),
//   builder: (BuildContext context, AsyncSnapshot snapshot) {
//     if (!snapshot.hasData) {
//       return Center(child: const Text('Sold out'));
//     }
//     else if (snapshot.hasError) {
//         return const Center(
//             child: CircularProgressIndicator());
//       }
//     return GridView.builder(
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          
//       itemBuilder: (BuildContext context, int index) {
//          var data = snapshot.data.docs[index];
       
//         return
//          Container(
//       height: 300,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: InkWell(
//           onTap: () {
//            Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     MedDetail(product: [index])));
//           },
//           child: Card(
//              semanticContainer: true,
//             clipBehavior: Clip.antiAliasWithSaveLayer,
            
//                 color: primarycolor,
//                  shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//                  elevation: 5,
//             margin: const EdgeInsets.all(5),
//                 child: Column(
//                   children: [
                    
//                     AspectRatio(aspectRatio: 1.5 /1,child: Image.network(data["pImage"]),),
                   
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Text(
//                       data["pName"],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Text(data["pPrice"].toString(),
//                     style: const TextStyle(color: Colors.white),)
//                   ],
//                 ),
//               ),
//         ),
//       ),
//     );
//         //  Singleproduct(pName: data["pName"], pimageUrl: data["pImage"], pPrice: data["pPrice"].toString());
//       },
//       itemCount: snapshot.data!.docs.length,
//     );
//   },
// ),
//    );
//   }
// }




// class Singleproduct extends StatelessWidget {
//   final String pName;
//  final String pimageUrl;
//   final String pPrice; 
//    Singleproduct({Key? key, required this.pName, required this.pimageUrl, required this.pPrice}) : super(key: key);

   

//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       height: 300,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: InkWell(
//           onTap: () {
//            Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     MedDetail(product: var[index])));
//           },
//           child: Card(
//              semanticContainer: true,
//             clipBehavior: Clip.antiAliasWithSaveLayer,
            
//                 color: primarycolor,
//                  shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//                  elevation: 5,
//             margin: const EdgeInsets.all(5),
//                 child: Column(
//                   children: [
                    
//                     AspectRatio(aspectRatio: 1.5 /1,child: Image.network(pimageUrl),),
                   
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Text(
//                       pName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Text(pPrice,
//                     style: const TextStyle(color: Colors.white),)
//                   ],
//                 ),
//               ),
//         ),
//       ),
//     );
    
//   }
// }