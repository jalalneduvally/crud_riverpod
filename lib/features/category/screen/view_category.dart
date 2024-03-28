
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_riverpod/core/common/error_text.dart';
import 'package:crud_riverpod/core/common/firebase_constants.dart';
import 'package:crud_riverpod/core/common/loader.dart';
import 'package:crud_riverpod/features/category/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model_class/category_model.dart';
import '../../../Model_class/product_model.dart';
import '../../../main.dart';

class ViewCategory extends ConsumerStatefulWidget {
  const ViewCategory({super.key});

  @override
  ConsumerState<ViewCategory> createState() => _ViewCategoryState();
}

class _ViewCategoryState extends ConsumerState<ViewCategory> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.05),
        child: Column(
          children: [
            ref.watch(getCategoryProvider).when(
          data: (categories) =>categories.isEmpty?const Center(child: Text('noData'))
              :
            Expanded(
              child:  ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        CategoryModel category =categories[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Category name: ${category.name}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w*0.06
                                    )),
                              ],
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Do you want to delete?"),
                                        content: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                var a =category.copyWith(
                                                    delete: true
                                                );
                                                category.reference.update(a.toJson());
                                                showMessage(context, text: "Deleted successfully", color: Colors.green);
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: w*0.1,
                                                width: w*0.15,
                                                decoration: BoxDecoration(
                                                  color: Colors.purple,
                                                  borderRadius: BorderRadius.circular(w*0.03),
                                                ),
                                                child: const Center(
                                                  child: Text("Yes",style:
                                                  TextStyle(
                                                      color: Colors.white
                                                  )),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: w*0.1,
                                                width: w*0.15,
                                                decoration: BoxDecoration(
                                                  color: Colors.purple,
                                                  borderRadius: BorderRadius.circular(w*0.03),
                                                ),
                                                child: const Center(
                                                  child: Text("No",style:
                                                  TextStyle(
                                                      color: Colors.white
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },);
                                },
                                child: Icon(Icons.delete,color: Colors.redAccent,size: w*0.1,)),
                          ],
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: w*0.05,);
                    },
                    )

              ), error: (error, StackTrace stackTrace)=>ErrorText(error: error.toString()),
          loading: () =>const Loader(),

            )
          ],
        ),
      ),
    );
  }
}
