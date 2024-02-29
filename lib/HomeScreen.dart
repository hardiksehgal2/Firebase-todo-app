import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:velocity_x/velocity_x.dart';

import 'db_service/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool Personal = true,
      College = false,
      Office = false;
  bool suggest = false;
 TextEditingController todoController=TextEditingController();
 Stream?todoStream;


 getOnTheLoad()async{
    todoStream = await DatabaseService().getTask(
      Personal?"Personal":
          College?"College": "Office"
    );
    setState(() {

    });
 }
  void initState(){
    super.initState();
  }
  Widget getWork(){
    return StreamBuilder(
      stream: todoStream,
        builder: (context,AsyncSnapshot snapshot){
        return snapshot.hasData?
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot docSnap = snapshot.data.docs[index];
                  return CheckboxListTile(
                    activeColor: Colors.deepPurpleAccent,
                    title: GestureDetector(
                      onTap: () {
                        // Handle tap on the text (to open a new screen)
                        // Add your navigation logic here
                      },
                      child: Text(
                        docSnap["Work"],
                      ),
                    ),
                    value: docSnap["Yes"],
                    onChanged: (newValue) async {
                      // Handle tap on the checkbox (to delete the task)
                      await DatabaseService().tickMethod(
                        docSnap["Id"],
                        Personal ? "Personal" : College ? "College" : "Office",
                      );
                      setState(() {
                        DatabaseService().removeMethod(
                          docSnap["Id"],
                          Personal ? "Personal" : College ? "College" : "Office",
                        );
                      });
                    },
                    //Where to place the control relative to the text.
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: IconButton(
                      icon: Icon(Icons.edit), // Edit icon
                      onPressed: () {
                        // Handle edit action
                        _editTask(context, docSnap);
                      },
                    ),
                  );
                },
              ),

            ):Center(child: CircularProgressIndicator());
        }
    );
  }
  void _editTask(BuildContext context, DocumentSnapshot docSnap) {
    TextEditingController updatedTextController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    SizedBox(width: 16),
                    "Edit Task".text.purple600.make(),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  controller: updatedTextController,
                  decoration: InputDecoration(
                    hintText: "Enter updated task",
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 70,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        String updatedText = updatedTextController.text;
                        if (updatedText.isNotEmpty) {
                          await DatabaseService().updateTask(
                            docSnap["Id"],
                            updatedText,
                            Personal ? "Personal" : College ? "College" : "Office",
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: "Update".text.white.makeCentered(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          openBox();
        },
        child: Icon(
          Icons.add,
          size: 25,
          color: Colors.white,
        ),
      ),
      body: Container(

        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration:const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white38,
                  Colors.white12
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: "Hey, Hardik".text.xl3.black.make(),
            ),
            // SizedBox(height: 10,),
            // Container(
            //   child: "Hardik".text.xl3.black.make(),
            // ),
            SizedBox(height: 10,),
            Container(
              child: "Let the work Begin".text.lg.black.make(),
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Personal ? Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: "Personal".text.xl2.black.bold.make(),
                  ),
                ) : GestureDetector(
                    onTap: ()async {
                      Personal = true;
                      College = false;
                      Office = false;
                      await getOnTheLoad();
                      setState(() {

                      });
                    },
                    child: "Personal".text.xl.make()
                ),
                College ? Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: "College".text.xl2.black.bold.make(),
                  ),
                ) : GestureDetector(
                    onTap: () async{
                      Personal = false;
                      College = true;
                      Office = false;
                      await getOnTheLoad();
                      setState(() {

                      });
                    },
                    child: "College".text.xl.make()
                ),
                Office ? Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: "Office".text.xl2.black.bold.make(),
                  ),
                ) : GestureDetector(
                    onTap: () async{
                      Personal = false;
                      College = false;
                      Office = true;
                      await getOnTheLoad();
                      setState(() {

                      });
                    },
                    child: "Office".text.xl.make()
                ),
              ],
            ),
            SizedBox(height: 20,),

            getWork(),
          ],

        ),
      ).px16().py12(),
    );
  }

  Future<void> openBox() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 24), // Add padding to the content
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Adjust the width of the AlertDialog
            height: MediaQuery.of(context).size.height * 0.4, // Set a custom height for the AlertDialog
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Ensure the Column takes minimum space
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    SizedBox(width: 16),
                    "Add ToDo task".text.purple600.make(),
                  ],
                ),
                SizedBox(height: 20,),
                "Add Notes".text.make(),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      )
                  ),
                  child: TextField(
                    controller: todoController,
                    decoration: InputDecoration(
                      hintText: "Enter the task !",
                    ),
                  ),
                ) ,
                SizedBox(height: 20,),
                Center(
                  child: Container(
                    width: 70,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: (){
                        String id=randomAlphaNumeric(10);
                        Map<String,dynamic> userToDo={
                          "Work":todoController.text,
                          "Id":id,
                          "Yes":false,
                        };
                        Personal? DatabaseService().addPersonalTask(userToDo, id)
                            :College?DatabaseService().addCollegeTask(userToDo, id)
                            :DatabaseService().addOfficeTask(userToDo, id);
                        Navigator.pop(context);
                      },
                      child: "Add".text.white.makeCentered(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
