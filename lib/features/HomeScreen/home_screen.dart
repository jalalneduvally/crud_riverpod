import 'package:crud_riverpod/features/product/screen/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../auth/controller/auth_controller.dart';
import '../auth/screen/login_screen.dart';
import '../category/screen/category_tabbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  
  Future<void> logOut(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("uid");
    ref.read(authControllerProvider.notifier).logout();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TabBarScreen(),));
              },
              child: Container(
                  height: w*0.15,
                  width: w*1,
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(w*0.03)
                  ),
                  child: Center(child: Text("Add Product",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w*0.06,
                      fontWeight: FontWeight.w800
                    ),))
              ),
            ),
            SizedBox(height: w*0.07,),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryTabbar(),));
              },
              child: Container(
                  height: w*0.15,
                  width: w*1,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(w*0.03)
                  ),
                  child: Center(child: Text("Add Category",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w*0.06,
                      fontWeight: FontWeight.w800
                    ),))
              ),
            ),
            SizedBox(height: w*0.2,),
            Row(
              children: [
                SizedBox(width: w*0.05,),
                Icon(Icons.logout_rounded,color: Colors.redAccent,size: w*0.075,),
                SizedBox(width: w*0.03,),
                InkWell(
                  onTap: ()=>logOut(ref),
                  child: Text("Log out",
                    style: TextStyle(
                        fontSize:w*0.06 ,
                        fontWeight: FontWeight.w800,
                        color: Colors.redAccent
                    ),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
