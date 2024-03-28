import 'package:crud_riverpod/core/common/error_text.dart';
import 'package:crud_riverpod/core/common/loader.dart';
import 'package:crud_riverpod/features/product/screen/product_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../controller/product_controller.dart';

class viewProduct extends ConsumerStatefulWidget {
  const viewProduct({super.key});

  @override
  ConsumerState<viewProduct> createState() => _viewProductState();
}

class _viewProductState extends ConsumerState<viewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ref.watch(getProductProvider).when(
                data: (products) => products.isEmpty
                    ? const Center(child: Text('noData'))
                    : Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = products[index];
                            return Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: w * 0.4,
                                      width: w * 0.3,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(w * 0.03),
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage(product.image),
                                              fit: BoxFit.cover)),
                                    ),
                                    Positioned(
                                      bottom: w * 0.025,
                                      child: Container(
                                        height: w * 0.07,
                                        width: w * 0.3,
                                        color: Colors.white60,
                                        child: Center(
                                            child: Text(
                                          product.available
                                              ? "Available"
                                              : "Not Available",
                                          style: TextStyle(
                                              fontSize: w * 0.04,
                                              fontWeight: FontWeight.w600),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text("Name: ${product.prdctName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: w * 0.04)),
                                    SizedBox(
                                      height: w * 0.03,
                                    ),
                                    Text("price: ${product.price.toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: w * 0.04)),
                                    SizedBox(
                                      height: w * 0.03,
                                    ),
                                    Text(
                                        "description: ${product.description.toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: w * 0.04)),
                                    SizedBox(
                                      height: w * 0.03,
                                    ),
                                    Text(
                                        "category: ${product.category.toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: w * 0.04)),
                                  ],
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductEdit(
                                                productDetails: product),
                                          ));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: w * 0.08,
                                      color: Colors.blueAccent,
                                    )),
                                InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Do you want to delete?"),
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // var a =product.copyWith( delete: true );
                                                    // product.reference.update(a.toJson());
                                                    ref.watch(productControllerProvider.notifier)
                                                        .deleteProduct(product, context);
                                                  },
                                                  child: Container(
                                                    height: w * 0.1,
                                                    width: w * 0.15,
                                                    decoration: BoxDecoration(
                                                      color: Colors.purple,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  w * 0.03),
                                                    ),
                                                    child: const Center(
                                                      child: Text("Yes",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    height: w * 0.1,
                                                    width: w * 0.15,
                                                    decoration: BoxDecoration(
                                                      color: Colors.purple,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  w * 0.03),
                                                    ),
                                                    child: const Center(
                                                      child: Text("No",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: w * 0.08,
                                      color: Colors.redAccent,
                                    )),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: w * 0.03,
                            );
                          },
                        ),
                      ),
                error: (error, StackTrace stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => Loader(),
              )
        ],
      ),
    );
  }
}
