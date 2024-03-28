import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_riverpod/Model_class/category_model.dart';
import 'package:crud_riverpod/Model_class/product_model.dart';
import 'package:crud_riverpod/features/product/repository/product_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/providers/storage_repository_provider.dart';
import 'dart:io';


 final getProductProvider = StreamProvider((ref){
  return ref.watch(productControllerProvider.notifier).getProduct();
 });

final productControllerProvider= StateNotifierProvider<ProductController,bool>((ref) {
  final productRepository=ref.watch(productRepositoryProvider);
  final storageRepository=ref.watch(storageRepositoryProvider);
  return ProductController(
      productRepository: productRepository,
      ref: ref,
    storageRepository: storageRepository,
     );
});

class ProductController extends StateNotifier<bool> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  ProductController({
    required ProductRepository productRepository,
    required StorageRepository storageRepository,
    required Ref ref,

   }):_productRepository=productRepository,
        _storageRepository=storageRepository,
        _ref=ref,
        super(false);

  void addProduct({
   required String name,
    required double price,
    required bool delete,
    required bool available,
    required String description,
    required CategoryModel category,
    required BuildContext context,
    required File? file,
   })async{
    state =true;
    DocumentReference reference=_ref.watch(productRepositoryProvider).reference(name);
    String postId = const Uuid().v1();
    final imageRes = await _storageRepository.storeFile(
      path: 'products/${name}',
      id: postId,
      file: file,
      // webFile: webFile,
    );
    imageRes.fold((l) => showMessage(context,text:  l.message,color: Colors.red), (r) async {

    ProductList product=ProductList(
        prdctName: name,
        price: price,
        delete: delete,
        available: available,
        image: r,
        id: name,
        description: description,
        category: category.name,
        date: DateTime.now(),
        reference: reference
    );
    final res=await _productRepository.addProduct(product);
    state =false;
    res.fold((l) => showMessage(context,text:l.message,color: Colors.red), (r) {
      showMessage(context,text:"Product Created successfully..!",color: Colors.green);
      Navigator.of(context).pop();
    });
    });
  }

  void editProduct({
    required BuildContext context,
    required String name,
    required double price,
    required bool available,
    required String description,
    required String category,
    required File? file,
    required ProductList product
  })async{
    state=true;
    if(file != null){
      final res=await _storageRepository.storeFile(
          path: 'products/${product.id}',
          id: category,
          file: file);
      res.fold(
              (l) => showMessage(context,text: l.message,color: Colors.red),
              (r) => product=product.copyWith(image: r,));
    }

    final re=await _productRepository.editProductName(product.copyWith(
        prdctName: name
    ));
    re.fold(
          (l) => showMessage(context,text: l.message,color: Colors.red),
          (r) => null,
    );

    final result =await _productRepository.editProduct(product.copyWith(
        available: available,
        price: price,
        category: category,
        description: description
    ));
    state=false;
    result.fold(
            (l) => showMessage(context,text: l.message,color: Colors.red),
            (r) {
              showMessage(context,text: "Updated Successfully..!",color: Colors.green);
              Navigator.of(context).pop();
            }
    );
  }

  // Future<void> editProductName(BuildContext context,String name, ProductList product) async {
  //   final re=await _productRepository.editProductName(product.copyWith(
  //       prdctName: name
  //   ));
  //   re.fold(
  //         (l) => showMessage(context,text: l.message,color: Colors.red),
  //         (r) => null,
  //   );
  // }

  Future<void> deleteProduct(ProductList product,BuildContext context) async {
    final result =await _productRepository.deleteProduct(product.copyWith(
        delete: true
    ));
    state=false;
    result.fold(
            (l) => showMessage(context,text: l.message,color: Colors.red),
            (r) {
              showMessage(context, text: "Deleted Successfully..!", color: Colors.green);
              Navigator.pop(context);
            }
    );
  }

  Stream<List<ProductList>> getProduct(){
    return _productRepository.getProduct();
  }
}