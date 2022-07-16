import 'package:flutter/material.dart';
import 'package:to_do_list_app/database_helper.dart';
import 'package:to_do_list_app/models/task.dart';
import '../widgets.dart';

class Taskpage extends StatefulWidget {
  const Taskpage({Key? key}) : super(key: key);

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/back_arrow_icon.png"),
                            ),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          onSubmitted: (value) async {
                            if (value != "") {
                              DatabaseHelper _dbHelper = DatabaseHelper();

                              Task _newTask = Task(title: value);

                              await _dbHelper.insertTask(_newTask);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Task Title...",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211551),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 12.0,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter description for task",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                      ),
                    ),
                  ),
                  TodoWidget(
                    text: "Create your first task",
                    isDone: false,
                  ),
                  TodoWidget(
                    text: "Create your first todo ",
                    isDone: true,
                  ),
                  TodoWidget(),
                  TodoWidget(),
                  TodoWidget(),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Taskpage()),
                    );
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Color(0XFFFE3577),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image(
                        image: AssetImage("assets/images/delete_icon.png")),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
