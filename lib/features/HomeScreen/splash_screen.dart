import 'package:crud_riverpod/Model_class/user_model.dart';
import 'package:crud_riverpod/features/auth/controller/auth_controller.dart';
import 'package:crud_riverpod/features/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  loggedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('uid')){
      String? uid = prefs.getString('uid');
      UserModel user = await ref.watch(authControllerProvider.notifier).getUserData(uid!).first;
      ref.read(userProvider.notifier).update((state) => user);
      Future.delayed(const Duration(seconds: 2))
          .then((value) =>Navigator.push(context, MaterialPageRoute(builder: (context) =>const HomeScreen() ,)));
    }else{
    Future.delayed(const Duration(seconds: 2))
        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) =>const LoginScreen(),)));
  }
      }
  @override
  void initState() {
    loggedPref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("💣",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: w*0.4,
                ),),
              Text("Boom..",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: w*0.2,
                ),),
            ],
          ),
        ],
      ),
    );
  }
}
