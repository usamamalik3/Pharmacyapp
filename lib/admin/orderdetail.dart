import 'package:flutter/material.dart';

import 'package:pharmacy/constraint.dart';

import 'package:pharmacy/models/order.dart';

class orderdetail extends StatefulWidget {
  final OrderModel order;
  const orderdetail({Key? key, required this.order}) : super(key: key);

  @override
  State<orderdetail> createState() => _orderdetailState();
}

class _orderdetailState extends State<orderdetail> {
   
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: primarycolor,
        title: const Center(
          child: Text("individual order detail",
          style: TextStyle(color: Colors.white,
          fontSize: 24,
          ),),
          
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
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
                            widget.order.firstName,
                            style:  TextStyle(
                              fontSize: 17,
                              color: primarycolor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.order.lastName,
                                style:  TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: primarycolor,
                                ),
                              ),
                              Text(
                                widget.order.totalprice.toString(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: primarycolor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            widget.order.product.toString(),
                            style:  TextStyle(
                              fontSize: 20,
                              color: primarycolor,
                            ),
                        ),
                         const SizedBox(height: 40),
                          Text(
                            "Mobile no:   ${widget.order.mobileNo}",
                            style:  TextStyle(
                              fontSize: 20,
                              color: primarycolor,
                            ),),
                            const SizedBox(height: 40),
                          Text(
                            "street:   ${widget.order.street}",
                            style:  TextStyle(
                              fontSize: 20,
                              color: primarycolor,
                            ),),
                            const SizedBox(height: 40),
                          Text(
                            "city :   ${widget.order.city}",
                            style:  TextStyle(
                              fontSize: 20,
                              color: primarycolor,
                            ),),
                            

                        ]
                         
                       )) )
                ]))
          
          ],
        ),
      ),
    );
    
  }
}