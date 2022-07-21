import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmacy/Constraint.dart';
import 'package:pharmacy/admin/addcategory.dart';
import 'package:pharmacy/admin/addproduct.dart';
import 'package:pharmacy/admin/orderdetail.dart';
import 'package:pharmacy/login.dart';
import 'package:pharmacy/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<OrderModel> orders = [];
  
  fetchorder() async {
   QuerySnapshot p = await FirebaseFirestore.instance.collection("orders").get();
    setState(() {
      for (var document in p.docs) {
        orders.add(OrderModel(
            product: document["product"],
            city: document["city"],
            firstName: document["first name"],
            lastName: document["last name"],
            mobileNo: document["mobile  no"],
            orderno: document["order no"].toString(),
            street: document["street"], 
            totalprice: document["Total price"]));
      }
    });
  }
    final FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    fetchorder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                 
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    
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

        
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('Add a product', style: TextStyle(fontSize: 18)),
              onTap: () {
              
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Addproduct()));
              },
            ),
            Divider(height: 3.0),
             ListTile(
              leading: Icon(Icons.add_box),
              title: Text('Add a category', style: TextStyle(fontSize: 18)),
              onTap: () {
                
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => addcategory()));
              },
            ),
            Divider(height: 3.0),
            ListTile(
              leading: Icon(Icons.shopping_bag_sharp),
              title: Text('orders list', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Admin()));
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
        title: const Center(
          child: Text(
            "Admin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child:  Column(
                  children: List.generate(
                  
                    orders.length,
                    
                    (index) => Dismissible(
                      key: UniqueKey(),
                  direction: DismissDirection.up,
                  onDismissed: (direction) {
                    setState(() {
                      
                       FirebaseFirestore.instance
                              .collection("orders")
                              .doc()
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
                      child: GestureDetector(
                        onTap: () => {
                         Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => orderdetail(order: orders[index]))),
  
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          children:  [
                                            
                                           const  SizedBox(width: 10),
                                            Text(
                                              orders[index].firstName,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                             const SizedBox(width: 5),
                                            Text(
                                              orders[index].lastName,
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  2.5,
                                          child: Text(
                                            orders[index].mobileNo
                                            ,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Text( "order no  "+ 
                                          orders[index].orderno.toString(),
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                       const SizedBox(
                                        height: 10,
                                       )
                                      ],
                                    ),
                                  ),
                                  
                                ],
                              ),
                               Text( "Total price "+ 
                                          orders[index].totalprice.toString(),
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        const SizedBox(
                                        height: 10,
                                       )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
