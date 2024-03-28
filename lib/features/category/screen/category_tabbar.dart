import 'package:crud_riverpod/features/category/screen/view_category.dart';
import 'package:flutter/material.dart';
import 'add_category.dart';
import '../../../main.dart';


class CategoryTabbar extends StatefulWidget {
  const CategoryTabbar({super.key});

  @override
  State<CategoryTabbar> createState() => _CategoryTabbarState();
}

class _CategoryTabbarState extends State<CategoryTabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Category"),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: w*0.07
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: "add",
              ),
              Tab(
                text: "view",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                  children: [
                    catogaryPage(),
                    ViewCategory()

                  ]),
            )
          ],
        ),
      ),

    );
  }
}
