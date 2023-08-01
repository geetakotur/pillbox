import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pillbox/content.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:pillbox/home.dart';
import 'auth.dart';

void main() {
  runApp(const Container3());
}

class Container3 extends StatefulWidget {
  const Container3({Key? key}) : super(key: key);

  @override
  State<Container3> createState() => _Container3State();
}

class _Container3State extends State<Container3> {
  bool status = false;
  // String? v;
  String containerText = "Container 3";
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 0, minute: 00);
  DateTime selectedDate = DateTime.now();
  final PillnameController = TextEditingController();
  final PillDoseController = TextEditingController();
  final desc = TextEditingController();
  List<dynamic> listItem=<dynamic>[
    "Before Breakfast",
    "After Breakfast",
    "Before Lunch",
    "After Lunch",
    "Before Dinner",
    "After Dinner"
  ];
  var currentItemSelected="Before Breakfast";
  late DatabaseReference dbRef;

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Pills').child('Container3');
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[100],
        title: const Text("Smart PillBox"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FetchData()));
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 30, top: 30),
                width: w * 0.02,
                height: h * 0.04,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                      image: AssetImage("assets/button1.jpg"),
                      fit: BoxFit.cover),
                ),
                child: const Center(
                  child: Text(
                    "View List",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.02),
            GestureDetector(
              onTap: () {
                AuthController.instance.logout();
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 30, bottom: 700),
                width: w * 0.2,
                height: h * 0.04,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                      image: AssetImage("assets/button1.jpg"),
                      fit: BoxFit.cover),
                ),
                child: const Center(
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: w,
              height: h * 0.1,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/login1.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Container 1",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(1, 1),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ],
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: PillnameController,
                decoration: InputDecoration(
                  hintText: "Pill Name",
                  prefixIcon: const Icon(
                    Icons.add_box_sharp,
                    color: Colors.lightBlueAccent,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      PillnameController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(1, 1),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ],
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: PillDoseController,
                decoration: InputDecoration(
                  hintText: "Add Dose",
                  prefixIcon: const Icon(
                    Icons.add_box_sharp,
                    color: Colors.lightBlueAccent,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      PillDoseController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
            ),
            // Container(
            //   child: Column(
            //     children: [
            //       RadioListTile(
            //         title: const Text("Breakfast"),
            //         activeColor: Colors.lightBlueAccent[100]!,
            //         value: "Breakfast",
            //         groupValue: v,
            //         onChanged: (value) {
            //           setState(() {
            //             v = value.toString();
            //           });
            //         },
            //       ),
            //       RadioListTile(
            //         title: const Text("Lunch"),
            //         activeColor: Colors.lightBlueAccent[100]!,
            //         value: "Lunch",
            //         groupValue: v,
            //         onChanged: (value) {
            //           setState(() {
            //             v = value.toString();
            //           });
            //         },
            //       ),
            //       RadioListTile(
            //         title: const Text("Dinner"),
            //         activeColor: Colors.lightBlueAccent[100]!,
            //         value: "Dinner",
            //         groupValue: v,
            //         onChanged: (value) {
            //           setState(() {
            //             v = value.toString();
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(width: 30,height: 20,),
            Container(
              margin: const EdgeInsets.only(left: 60, right: 20),
              child:Row(
                children:[
                  Text("Select Slot:",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),),
                  SizedBox(width: 20,),
                  DropdownButton<dynamic>(
                    value:currentItemSelected ,
                    items:listItem.map((dynamic dropdownStringitem){
                      return DropdownMenuItem<dynamic>(
                        value:dropdownStringitem ,
                        child: Text(dropdownStringitem),
                      );
                    }
                    ).toList(),
                    onChanged:(dynamic? newValue){
                      setState(() {
                        this.currentItemSelected=newValue!;
                      });
                    },

                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        _timeOfDay.format(context).toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      MaterialButton(
                        onPressed: _showTimePicker,
                        color: Colors.lightBlueAccent[100],
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Set Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                        style: const TextStyle(fontSize: 20),
                      ),
                      MaterialButton(
                        color: Colors.lightBlueAccent[100],
                        onPressed: () => _selectDate(context),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Set Date',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: desc,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Add the Description',
                  border: const UnderlineInputBorder(),
                  labelText: 'Description',
                  suffixIcon: IconButton(
                    onPressed: () {
                      desc.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                int hour = _timeOfDay.hour;
                int minute = _timeOfDay.minute;

                String hourString = hour.toString().padLeft(2, '0');
                String minuteString = minute.toString().padLeft(2, '0');

                Map<String, dynamic> data = {
                  'pillname': PillnameController.text.toString(),
                  'pilldose': PillDoseController.text.toString(),
                  // 'radio': v.toString(),
                  'slot':currentItemSelected,
                  'hour': hour,
                  'minute': minute,
                  'Date': "${selectedDate.toLocal()}".split(' ')[0],
                  'Description': desc.text.toString(),
                  'title': containerText.toString(),
                };

                dbRef.set(data).then((value) {});

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FetchData()));
              },
              color: Colors.lightBlueAccent[100],
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const homeApp()));
        },
        backgroundColor: Colors.lightBlueAccent[100]!,
        splashColor: Colors.lightBlueAccent,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
