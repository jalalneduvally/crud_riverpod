
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_riverpod/features/product/controller/product_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


import '../../../Model_class/category_model.dart';
import '../../../Model_class/product_model.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/common/loader.dart';
import '../../../main.dart';
import '../../category/controller/category_controller.dart';

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key});
  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {

  TextEditingController nameController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  final RegExp priceValidation=RegExp(r'[0-9]$');

  var file;

  void selectImage() async {
    final res= await pickImage();
    if(res !=null){
      setState(() {
        file=File(res.path);
      });
    }
  }

  List <CategoryModel> category=[];
  CategoryModel? dropdownvalue;

  bool toggle = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();

  }
  void addProduct(){
    ref.read(productControllerProvider.notifier).
    addProduct(
        name: nameController.text.trim(),
        price:double.tryParse(priceController.text.trim().toString())??0 ,
        delete: false,
        available: toggle,
        description: descriptionController.text.trim(),
        category: dropdownvalue ?? category[0],
        context: context,
        file: file,
    );
  }
  @override
  Widget build(BuildContext context) {
    final isLoading=ref.watch(productControllerProvider);
    return isLoading?
    const Loader():
     Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: w*0.05,),
              Stack(
                children: [
                  file!=null?
                  CircleAvatar(
                    radius: w*0.25,
                    backgroundImage: FileImage(file),
                  ):
                  CircleAvatar(
                    backgroundColor: Colors.deepOrangeAccent,
                    radius: w*0.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("👀",style: TextStyle(fontSize: w*0.2),),
                        SizedBox(width: w*0.03,)
                      ],
                    ),),
                  Positioned(
                    top: w*0.35,
                    left: w*0.35,
                    child: InkWell(
                      onTap: () {
                        selectImage();
                      },
                      child: CircleAvatar(
                        radius: w*0.07,
                        backgroundColor: Colors.black54,
                        child: const Icon(Icons.camera_alt_outlined,color: Colors.white,),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: w*0.08,),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText:"name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w*0.03)
                    )
                ),
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                controller: priceController,
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
              SizedBox(height: w*0.05,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText:"description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w*0.03)
                    )
                ),
              ),
              SizedBox(height: w*0.08,),
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
                    child:  ref.watch(getCategoryProvider).when(
                      data: (data) {
                        category =data;
                        if(data.isEmpty){
                          return const SizedBox();
                        }
                        return DropdownButton(
                          underline: const SizedBox(),
                          isExpanded: true,
                          hint: const Text("select Category"),
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          borderRadius: BorderRadius.circular(w*0.03),
                          value: dropdownvalue,
                          items: data.map((e) =>
                              DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name))).toList(),
                          onChanged: (value) {
                            setState(() {
                              dropdownvalue =value;
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
              SizedBox(height: w*0.05,),
              ElevatedButton(onPressed: (){
                if(file!=null&& nameController.text.isNotEmpty&&
                    priceController.text.isNotEmpty&&
                    descriptionController.text.isNotEmpty
                     &&dropdownvalue!=null
                ){
               addProduct();
                }else{
                  file==null?showMessage(context,text: "please upload image", color: Colors.red):
                  nameController.text.isEmpty?showMessage(context,text: "please enter name", color: Colors.red):
                  priceController.text.isEmpty?showMessage(context,text: "please enter price ", color: Colors.red):
                  descriptionController.text.isEmpty?showMessage(context,text: "please enter description ", color: Colors.red):
                  showMessage(context,text: "please select value", color: Colors.red);
                }
              },
               child: Text("Add"))
            ],
          ),
        ),
      ),
    );
  }
}
