import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmacy/constraint.dart';

import 'models/product.dart';

class MedDetail extends StatelessWidget {
  final Product product;
  const MedDetail({Key? key, required this.product}) : super(key: key);

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
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
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
            child: Image.network(product.pimageUrl),
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
                          product.pCategory,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.pName,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              product.pPrice.toString(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          product.pDescription,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Text(
                        //   'Similar This',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        // SizedBox(
                        //   height: 110,
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: smProducts.length,
                        //     itemBuilder: (context, index) => Container(
                        //       margin: const EdgeInsets.only(right: 6),
                        //       width: 110,
                        //       height: 110,
                        //       decoration: BoxDecoration(
                        //         color: primarycolor,
                        //         borderRadius: BorderRadius.circular(20),
                        //       ),
                        //       // child: Center(
                        //       //   child: Image(
                        //       //     height: 70,
                        //       //     image: AssetImage([index].image),
                        //       //   ),
                        //       // ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        padding: EdgeInsets.all(10),
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
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 20),
<<<<<<< HEAD
            // Expanded(
            //   child: InkWell(
            //     onTap: () {
            //       productController.addToCart();
            //     },
            //     child: Container(
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //         color: Colors.black,
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //       child: Obx(
            //         () => productController.isAddLoading.value
            //             ? SizedBox(
            //                 width: 20,
            //                 height: 20,
            //                 child: CircularProgressIndicator(
            //                   color: Colors.white,
            //                   strokeWidth: 3,
            //                 ),
            //               )
            //             : Text(
            //                 '+ Add to Cart',
            //                 style: TextStyle(
            //                   fontSize: 15,
            //                   fontWeight: FontWeight.w500,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //       ),
            //     ),
            //   ),
            // ),
=======
            Expanded(
              child: InkWell(
                onTap: () {
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primarycolor,
                    borderRadius: BorderRadius.circular(15),
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
           
>>>>>>> acd91ed (category)
          ],
        ),
      ),
    );
  }
}
