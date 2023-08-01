import 'package:flutter/material.dart';
import 'package:pillbox/auth.dart';
import 'package:pillbox/container1.dart';
import 'package:pillbox/container2.dart';
import 'package:pillbox/container3.dart';
import 'package:pillbox/container4.dart';


import 'package:pillbox/content.dart';
import 'package:pillbox/update.dart';


void main(){
  runApp(const homeApp());
}
// ignore: camel_case_types
class homeApp extends StatefulWidget {
  const homeApp({Key? key}) : super(key: key);

  @override
  State<homeApp> createState() => _homeAppState();
}

class _homeAppState extends State<homeApp> {
  Map<String, dynamic> pills = {'key': 'pills',};
  String containerName = '';


  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;    //access width
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title:const Text(
            "Add pills"
          ),
        backgroundColor: Colors.lightBlueAccent[100],
      ),
      drawer: Drawer(
        child:
        ListView(
    children:[ GestureDetector(
            onTap: (){

      Navigator.push(context, MaterialPageRoute(builder:(context)=>const FetchData()));
      },
        child:Container(
          //  margin: const EdgeInsets.only(left: 20,right: 20),
          margin: const EdgeInsets.only(left: 20,right: 30,top: 30,),
          width: w*0.02,                     //width of screen
          height: h*0.04,              //1/3rd height of the screen
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: const DecorationImage(
                image: AssetImage(
                    "assets/button1.jpg"
                ),
                fit: BoxFit.cover
            ),

          ),
          child:const Center(
            child: Text(
              "View Pill List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height:0 ,),
      GestureDetector(
          onTap: (){
            AuthController.instance.logout();
          },
      child:Container(
        margin: const EdgeInsets.only(left: 20,right: 20,top: 50,bottom: 5),
            width: w*0.08,                     //width of screen
            height: h*0.04,              //1/3rd height of the screen
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                  image: AssetImage(
                      "assets/button1.jpg"
                  ),
                  fit: BoxFit.cover
              ),

            ),
            child:const Center(
              child: Text(
                "Sign out",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ),
        ),
    ],
      ),
    ),
      body:

      GridView.count(
      primary: false,
      // padding: const EdgeInsets.all(20),
     padding: const EdgeInsets.only(left: 30,right: 30,top: 50,bottom: 80),
      crossAxisSpacing: 5,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      childAspectRatio: 1/1.75,
      children: <Widget>[
        Column(
      children: [
        GestureDetector(
          onTap: (){

              Navigator.push(
                context,MaterialPageRoute(builder: (context) =>const Container1()),);

          },
          child:Container(
            width: w*0.5,                     //width of screen
            height: h*0.2,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                  image: AssetImage(
                      "assets/addfinal.png"
                  ),
                  fit: BoxFit.cover
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        const Text("Container 1",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
        ],
        ),


        Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context) =>const Container2()),);
              },
              child:Container(
                width: w*0.5,                     //width of screen
                height: h*0.2,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                      image: AssetImage(
                          "assets/addfinal.png"
                      ),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            const Text("Container 2",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),),
          ],
        ),

        Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context) =>const Container3()),);
              },
              child:Container(
                width: w*0.5,                     //width of screen
                height: h*0.2,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                      image: AssetImage(
                          "assets/addfinal.png"
                      ),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            const Text("Container 3",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context) =>const Container4()),);
              },
              child:Container(
                width: w*0.5,                     //width of screen
                height: h*0.2,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                      image: AssetImage(
                          "assets/addfinal.png"
                      ),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            const Text("Container 4",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),),

          ],
        ),






      ],
    ),






    );

  }
}
