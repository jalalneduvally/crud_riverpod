import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_riverpod/Model_class/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../Model_class/product_model.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/typedef.dart';

final productRepositoryProvider =Provider((ref) {
  return ProductRepository(firestore: ref.watch(firestoreProvider));
});
class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({required FirebaseFirestore firestore})
      :_firestore=firestore;


  FutureVoid addProduct(ProductList product) async{
    try{
      var productDoc = await _product.doc(product.prdctName).get();
      if (productDoc.exists){
        throw "Product with the same name exist!";
      }
      return right(_product.doc(product.prdctName).set(product.toJson()));
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<ProductList>> getProduct(){
    return _product
        .where('delete', isEqualTo: false).orderBy('date', descending: true)
        .snapshots().map((event) => event.docs
        .map((e) => ProductList.fromJson(
      e.data() as Map<String, dynamic>,
    ),
    ).toList(),
    );
  }

  FutureVoid editProduct(ProductList productList)async{
    try{

      return right(_product.doc(productList.id).update(productList.toJson()));

    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editProductName(ProductList productList)async{
    try{
      var productDoc = await _product.where("prdctName",isEqualTo:productList.prdctName ).get();
      if (productDoc.docs.isEmpty){
        return right(_product.doc(productList.id).update(productList.toJson()));
      }else {
        throw "Product with the same name exist!";
      }
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteProduct(ProductList product)async{
    try{
      return right(_product.doc(product.id).update(product.toJson()));
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

   reference(String name){
   return _product.doc(name);
  }

  CollectionReference get _product => _firestore.collection(Constants.product);
}