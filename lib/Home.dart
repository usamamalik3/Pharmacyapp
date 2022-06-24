import 'package:flutter/material.dart';

import 'constraint.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
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
                    BoxShadow(
                        blurRadius: 7, spreadRadius: 3, color: primarycolor)
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
                  width: 10,
                ),
                
                SizedBox(
                  width: 26,
                )
              ],
            )
          ],
        ),

        body: ListView(
          children: [],
        ),
        
        );
  }
}
