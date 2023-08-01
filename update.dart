import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateRecord extends StatefulWidget {
  final String pillsKey;
  final Map<dynamic, dynamic> containerData;

  const UpdateRecord({Key? key, required this.pillsKey, required this.containerData})
      : super(key: key);

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  late int _hour;
  late int _minute;
  late DateTime selectedDate;
  final PillnameController = TextEditingController();
  final PillDoseController = TextEditingController();
  final desc = TextEditingController();
  //late String v = '';
  List<dynamic> listItem=<dynamic>[
    "Before Breakfast",
    "After Breakfast",
    "Before Lunch",
    "After Lunch",
    "Before Dinner",
    "After Dinner"
  ];
  var currentItemSelected="Before Breakfast";

  void _showTimePicker() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
    );

    if (timeOfDay != null) {
      setState(() {
        _hour = timeOfDay.hour;
        _minute = timeOfDay.minute;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _hour = TimeOfDay.now().hour;
    _minute = TimeOfDay.now().minute;
    selectedDate = DateTime.now();

    // Populate the text fields with the existing data
    PillnameController.text = widget.containerData['pillname'];
    PillDoseController.text = widget.containerData['pilldose'];
    desc.text = widget.containerData['Description'];
    currentItemSelected= widget.containerData['slot'];

    // Parse _hour and _minute from String to int
    try {
      _hour = int.parse(widget.containerData['hour']);
    } catch (e) {
      // Handle the error when parsing fails, you can provide a default value here
      print('Error parsing hour: $e');
    }

    try {
      _minute = int.parse(widget.containerData['minute']);
    } catch (e) {
      // Handle the error when parsing fails, you can provide a default value here
      print('Error parsing minute: $e');
    }

    selectedDate = DateTime.parse(widget.containerData['Date']);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[100],
        title: Text('Update record'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: PillnameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'pillName',
                    hintText: 'Enter the pillName',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: PillDoseController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'pill dose',
                    hintText: 'no of tablets',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

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
                const SizedBox(
                  height: 10,
                ),
                SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Time: $_hour:$_minute',
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
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                            style: const TextStyle(fontSize: 20),
                          ),
                          MaterialButton(
                            onPressed: () => _selectDate(context),
                            color: Colors.lightBlueAccent[100],
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
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: desc,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'Enter the details of tablet',
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                MaterialButton(
                  onPressed: () {
                    Map<String, dynamic> data = {
                      'pillname': PillnameController.text.toString(),
                      'pilldose': PillDoseController.text.toString(),
                      'slot': currentItemSelected,
                      'hour': _hour.toString(), // Convert _hour to String
                      'minute': _minute.toString(), // Convert _minute to String
                      'Date': "${selectedDate.toLocal()}".split(' ')[0],
                      'Description': desc.text.toString(),
                    };

                    print('Update Data: $data');

                    DatabaseReference containerRef = FirebaseDatabase.instance
                        .ref()
                        .child('Pills')
                        .child(widget.pillsKey);

                    // Update the existing data within the container
                    containerRef.update(data).then((_) {
                      // Optionally, show a snackbar or toast to inform the user about the update
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Data updated successfully!'),
                        duration: Duration(seconds: 2),
                      ));

                      // Pass the updated data back to the previous page
                      Navigator.pop(context, data);
                    }).catchError((error) {
                      // Handle errors if any
                      print('Error updating data: $error');
                    });
                  },
                  child: const Text('Update Data'),
                  color: Colors.lightBlueAccent[100],
                  textColor: Colors.white,
                  minWidth: 300,
                  height: 40,
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
