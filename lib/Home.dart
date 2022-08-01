import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmacy/cart.dart';
import 'package:pharmacy/login.dart';
import 'package:pharmacy/categorydetail.dart';
import 'package:pharmacy/shop.dart';



import 'Detail.dart';

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
    QuerySnapshot p = await firestoreInstance.collection("products").where("ispopular", isEqualTo: true).get();
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
                   
                      SizedBox(height: 10.0),
                      Text(
                         FirebaseAuth.instance.currentUser!.email.toString(),
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
              leading: const Icon(Icons.home),
              title: const Text('Home Page', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Here you can give your route to navigate
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Homepage()));
              },
            ),
            const Divider(height: 3.0),
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Shop', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Here you can give your route to navigate
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Shop()));
              },
            ),
            Divider(height: 3.0),
          
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(70),
                bottomLeft: Radius.circular(70))),
        title: const Text(
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
                
                child:
                IconButton(
            onPressed: () {
             showSearch(context: context, delegate: Search());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
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
                child: 
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
                    
                       
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ctgshop(categoryname: cName)));
                    
                      },
                      categoryName: streamSnapshort.data!.docs[index]
                          ["cname"],
                      image: streamSnapshort.data!.docs[index]["cimage"].toString(),
                    ),
                  );
                },
              );
            }
              ),
              ),
              



             
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text('Popular products',
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


class Search extends SearchDelegate {

  CollectionReference collectionReference = FirebaseFirestore.instance.collection("products");
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
        stream: (query != "")
            ? FirebaseFirestore.instance.collection("products").snapshots()
             : null,
        builder: (context, AsyncSnapshot snapshot) {
             if (snapshot.hasError) {
               return const Text('Something went wrong');
             }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Column(
        children: const [
          Center(
              child: CupertinoActivityIndicator()
          )
        ],
      );
    }

   

    List<Product> products = snapshot.data.docs.map<Product>((doc) => Product(
      
     pCategory: doc["pCategory"], pDescription: doc["pDescription"],  pimageUrl: doc["pImage"], pName: doc["pName"], pPrice: doc["pPrice"], pID: doc.id,)).toList();
    products = products.where((s) => s.pName.toLowerCase().contains(query.toLowerCase())).toList();
    if(products.isEmpty){
      return Column(
        children: [
         const  SizedBox(height: 100),
          Center(
            child: Text("No products available", style: TextStyle(fontSize: 20, color: primarycolor)),
          )
        ],
      );

    }
    
    
    return
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MedDetail(product: products[index])));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                        color: primarycolor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                   
                                  Image.network(
                                 products[index].pimageUrl,
                                    width: 150,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  Text(
                                    products[index].pName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                      ),
                    );
                  }
              ),
            ),
          ],
        );
  },

      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   return  Center(child:  Text("Search anything here", style: TextStyle(
    color: primarycolor,
    fontSize: 22,
   ),));
  }

}