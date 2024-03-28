import 'package:crud_riverpod/features/category/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../main.dart';

class catogaryPage extends ConsumerStatefulWidget {
  const catogaryPage({super.key});

  @override
  ConsumerState<catogaryPage> createState() => _catogaryPageState();
}

class _catogaryPageState extends ConsumerState<catogaryPage> {

  addCategory(){
    ref.read(categoryControllerProvider.notifier).addCategory(
        name: categoryController.text.trim(),
        context: context);
  }

  TextEditingController categoryController=TextEditingController();

  @override
  void dispose() {
    super.dispose();
    categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(
                  hintText: "add category",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03)
                  )
              ),
            ),
            SizedBox(height: w*0.03,),
            InkWell(
              onTap: () {
                if(
                categoryController.text.isNotEmpty){
                  addCategory();

                }else{
                  showMessage(context,text: "please enter category", color: Colors.red);
                }
              },
              child: Container(
                height: w*0.1,
                width: w*0.2,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(w*0.03)
                ),
                child: const Center(child: Text("Add")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
