
import 'package:crud_riverpod/features/product/screen/view_product.dart';
import 'package:flutter/material.dart';

import 'add_product.dart';
import '../../../main.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text("Product"),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: w*0.07
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: "Add",
              ),
              Tab(
                text: "View",
              ),
            ],
          ),
        ),
        body: const Column(
          children: [
            Expanded(
              child: TabBarView(
                  children: [
                    AddProduct(),
                    viewProduct()

                  ]),
            )
          ],
        ),
      ),

    );
  }
}
