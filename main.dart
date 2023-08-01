import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillbox/auth.dart';
import 'package:pillbox/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value)=>Get.put(AuthController()));
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Pillbox',
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
        },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     //home:const Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const loginApp()));

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent[100]!,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/main1.png',height: 500,width: 500,),
            const SizedBox(height: 50,width: 5,),
            if(Platform.isIOS)
              const CupertinoActivityIndicator(
                radius: 30,
              )
            else
              const CircularProgressIndicator(
                color: Colors.blue,
              )


          ],

        ),

      ),
    );
  }
}


