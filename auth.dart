

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillbox/home.dart';
import 'package:pillbox/login.dart';

import 'main.dart';

class AuthController extends GetxController{
  //AuthController.instance..
  static AuthController instance =Get.find();
  //email,password..
  late Rx<User?> _User;
  FirebaseAuth auth=FirebaseAuth.instance;


  @override
  void onReady(){
    super.onReady();
    _User= Rx<User?>(auth.currentUser);
    //our user would be notified
    _User.bindStream(auth.userChanges());
    ever(_User,_initialScreen);
  }

  _initialScreen(User?user){
    if(user==null){
      print("login page");
      Get.offAll(()=>loginApp());
    }else{
      Get.offAll(()=>homeApp());
    }
  }

  void register(String email,password)async{
    try{
     await auth.createUserWithEmailAndPassword(email: email, password: password);
    }catch(e){
      Get.snackbar("About User", "User message",
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Account Created failed",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        messageText: Text(
        e.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }
  void login(String email,password)async{
    try{
     await auth.signInWithEmailAndPassword(email: email, password: password);
     // UserCredential userCredential = await FirebaseAuth.instance
       //   .signInWithEmailAndPassword(email: 'email', password: 'password');
      //String uid = userCredential.user!.uid;
      //print('UserId:$uid');
    }catch(e){
      Get.snackbar("About Login", "Login message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Login failed",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }



  void logout()async{
    await auth.signOut();

  }

}