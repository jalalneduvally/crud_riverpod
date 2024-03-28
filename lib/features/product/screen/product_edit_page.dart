import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../Model_class/category_model.dart';
import '../../../Model_class/product_model.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/common/loader.dart';
import '../../../main.dart';
import '../../category/controller/category_controller.dart';
import '../controller/product_controller.dart';

class ProductEdit extends ConsumerStatefulWidget {
  final ProductList productDetails;
  const ProductEdit({super.key, required this.productDetails});

  @override
  ConsumerState<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends ConsumerState<ProductEdit> {
  TextEditingController nameController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  final RegExp priceValidation=RegExp(r'[0-9]$');
  var imgurl;
  var file;
  void selectImage() async {
    final res= await pickImage();
    if(res !=null){
      setState(() {
        file=File(res.path);
      });
    }
  }

  String? dropDownValue;



  void editProduct(){
    ref.read(productControllerProvider.notifier).
    editProduct(
        name: nameController.text.trim(),
        price:double.tryParse(priceController.text.trim().toString())??0 ,
        available: toggle,
        description: descriptionController.text.trim(),
        category: dropDownValue ?? widget.productDetails.category,
        context: context,
        file: file,
        product: widget.productDetails
    );
  }

  bool toggle=false;

  @override
  void initState() {
   imgurl= widget.productDetails.image;
   dropDownValue= widget.productDetails.category;
   nameController.text= widget.productDetails.prdctName;
   priceController.text= widget.productDetails.price.toString();
   descriptionController.text= widget.productDetails.description;
   toggle =widget.productDetails.available;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                file !=null?
                CircleAvatar(
                  backgroundImage: FileImage(file),
                  radius: w*0.2,):
                CircleAvatar(
                  backgroundImage: NetworkImage(imgurl),
                  radius: w*0.2,),
                Positioned(
                  top: w*0.25,
                  left: w*0.25,
                  child: InkWell(
                    onTap: () {
                      selectImage();
                    },
                    child: CircleAvatar(
                      radius: w*0.07,
                      backgroundColor: Colors.purple,
                      child: const Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: w*0.05,),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText:"name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03)
                  )
              ),
            ),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if(!priceValidation.hasMatch(value!)){
                  return "Enter valid price";
                }
              },
              decoration: InputDecoration(
                  labelText:"price",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03)
                  )
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText:"description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03)
                  )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: w*0.1,
                  width:w* 0.5,
                  margin: EdgeInsets.only(left:w*0.02),
                  padding: EdgeInsets.only(left:w*0.02,right: w*0.02),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(w*0.03)
                  ),
                  child: ref.watch(getCategoryProvider).when(
                    data: (data) {
                      List<String> category=[];
                      for(CategoryModel doc in data){
                        category.add(doc.name);
                      }
                      // print(category);
                      if(data.isEmpty){
                        return const SizedBox();
                      }
                      return DropdownButton(
                        underline: const SizedBox(),
                        isExpanded: true,
                        hint: const Text("select Category"),
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        borderRadius: BorderRadius.circular(w*0.03),
                        value: dropDownValue,
                        items: category.map((e) =>
                            DropdownMenuItem(
                                value: e,
                                child: Text(e))).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropDownValue =value;
                          });
                        },);
                    },
                    error: (error, stackTrace) => ErrorText(error: error.toString()),
                    loading: () => const Loader(),)
                ),
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        toggle = !toggle;
                        setState(() {});
                      },
                      child: Container(
                        height: w* 0.08,
                        width: w * 0.2,
                        decoration: BoxDecoration(
                            color: toggle ? Colors.green : Colors.grey[300],
                            borderRadius: BorderRadius.circular(w * 0.05)),
                      ),
                    ),
                    AnimatedPositioned(
                      curve: Curves.easeIn,
                      left: toggle ? w * 0.12 : 0,
                      right: toggle ? 0 : w * 0.12,
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      child: InkWell(
                        onTap: () {
                          toggle = !toggle;
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          height: w * 0.08,
                          width: w * 0.08,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      // left: toggle? width*0.08:0,
                      top: w * 0.015,
                      left: toggle ? w * 0.015 : w * 0.12,
                      child: Text(
                        toggle ? "ON" : "OFF",
                        style: TextStyle(
                            color: toggle ? Colors.white : Colors.black),
                      ),
                    )
                  ],
                ),
              ],
            ),
            ElevatedButton(onPressed: () {
              if(nameController.text.isNotEmpty&&
                  priceController.text.isNotEmpty&&
                  descriptionController.text.isNotEmpty){
                editProduct();
              }else{
                nameController.text.isEmpty?showMessage(context,text: "please enter name", color: Colors.red):
                priceController.text.isEmpty?showMessage(context,text: "please enter price ", color: Colors.red):
                showMessage(context,text: "please enter description", color: Colors.red);
              }
            }, child: const Text("Update"))
          ],
        ),
      ),
    );
  }
}
