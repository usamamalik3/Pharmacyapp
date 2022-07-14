import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmacy/login.dart';
import 'package:pharmacy/shop.dart';

import 'package:provider/provider.dart';

import 'Detail.dart';
import 'constant.dart';
import 'constraint.dart';
import 'models/product.dart';

class Homepage extends StatefulWidget {

  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
    // ctgoryprovider? Ctgoryprovider;


  List<Product> _products = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  

  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

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
    // Ctgoryprovider = Provider.of<ctgoryprovider>(context);
    // Ctgoryprovider!.getCategoryproduct();
    return Scaffold(
      drawer: Drawer(
        elevation: 10.0,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: primarycolor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    // backgroundImage: NetworkImage(
                    //     'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                    // radius: 40.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Asad',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Asad@gmail.com',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0),
                      ),
                    ],
                  )
                ],
              ),
            ),

            //Here you place your menu items
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home Page', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Here you can give your route to navigate
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Homepage()));
              },
            ),
            Divider(height: 3.0),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Here you can give your route to navigate
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out', style: TextStyle(fontSize: 18)),
              onTap: () {
                signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: primarycolor,
        toolbarHeight: 100,
        elevation: 14,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(70),
                bottomLeft: Radius.circular(70))),
        title: Text(
          'pharmacy',
        ),
        actions: [
          Row(
            children: [
              Container(
                height: 40,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(blurRadius: 7, spreadRadius: 3, color: primarycolor)
                ], shape: BoxShape.circle, color: primarycolor),
                child: Icon(
                  Icons.search,
                  size: 20,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 3,
                      color: primarycolor,
                    )
                  ],
                  shape: BoxShape.circle,
                  color: primarycolor,
                ),
                child: Icon(
                  Icons.notifications,
                  size: 20,
                ),
              ),
              SizedBox(
                width: 30,
              ),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Categories',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
                ),
                 SizedBox(
          height: 200,
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("category").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
              if (!streamSnapshort.hasData) {
                return Center(child: const CircularProgressIndicator());
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: streamSnapshort.data!.docs.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 25 : 0),
                    child: Categories(
                      onTap: () {


                         var cName= streamSnapshort.data!.docs[index]
                          ["cname"];
                          print(cName);
                       
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ctgorysho(categoryname: cName)));
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => GridViewWidget(
                        //       subCollection: streamSnapshort.data!.docs[index]
                        //           ["categoryName"],
                        //       collection: "categories",
                        //       id: streamSnapshort.data!.docs[index].id,
                        //     ),
                        //   ),
                        // );
                      },
                      categoryName: streamSnapshort.data!.docs[index]
                          ["cname"],
                      image: streamSnapshort.data!.docs[index]["cimage"],
                    ),
                  );
                },
              );
            }
              ),
              ),
              



                // SizedBox(
                 
                  // height: 240,
                  // child: ,
                  // child: ListView.builder(
                  //   scrollDirection: Axis.horizontal,
                  //   itemCount: Ctgoryprovider!.categorymodellist.length,
                  //   itemBuilder: (context, index) => Padding(
                  //     padding: EdgeInsets.only(left: index == 0 ? 25 : 0),
                  //     child: medCategoryCard( Ctgoryprovider!.categorymodellist[index].cimageUrl,  Ctgoryprovider!.categorymodellist[index].pName, index)
                  //   ),
                  // ),
                // ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text('Popular',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
                ),
                Column(
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
                                          Icon(
                                            Icons.star,
                                            color: primarycolor,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'top of the week',
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Text(
                                          _products[index].pName,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        _products[index].pCategory,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
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
              ],
            ),
          )
        ],
      ),

      
    );

  }





  

  
  // Widget medCategoryCard(String? imagePath, String? name, int index) {
  //   return GestureDetector(
  //     onTap:() {
        
  //     },
  //     child: Container(
  //               margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
  //               padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(20),
  //                   color: primarycolor,
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.grey,
  //                       blurRadius: 15,
  //                     )
  //                   ]),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Image.network(
  //                      imagePath!,
  //                       width: 40),
                    // Text(name!,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w800,
  //                         fontSize: 16,
  //                         color: Colors.white,
  //                       )),
  //                   RawMaterialButton(
  //                       onPressed: null,
  //                       fillColor: selectedFoodCard == index
  //                           ? Colors.greenAccent
  //                           : Colors.white,
  //                       shape: CircleBorder(),
  //                       child: Icon(Icons.chevron_right_rounded,
  //                           size: 20,
  //                           color: selectedFoodCard == index
  //                               ? Colors.white
  //                               : primarycolor))
  //                 ],
  //               ),
  //             ),
  //   );
            
          
  // }
}

class Categories extends StatelessWidget {
  final String image;
  final String categoryName;
  final Function()? onTap;
  const Categories({
    Key? key,
    required this.onTap,
    required this.categoryName,
    required this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:  Container(
        width: 100,
                margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primarycolor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15,
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                    image,
                        width: 40),
                    Text(categoryName,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Colors.white,
                        )),
                   
                  ],
                ),
              ),
    );
  }
}
