import 'package:flutter/material.dart';
import 'package:to_do_list_app/database_helper.dart';
import 'package:to_do_list_app/models/task.dart';
import 'package:to_do_list_app/models/todo.dart';
import '../widgets.dart';

class Taskpage extends StatefulWidget {
  //const Taskpage({Key? key}) : super(key: key);
  final Task? task;
  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  int? _taskId = 0;
  String? _taskTitle = "";

  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      //set visibility to true
      _contentVisible = true;

      _taskTitle = widget.task!.title;
      _taskId = widget.task!.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _titleFocus?.dispose();
    _descriptionFocus?.dispose();
    _todoFocus?.dispose();

    super.dispose();
  }

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
                          focusNode: _titleFocus,
                          onSubmitted: (value) async {
                            //check if field is not empty
                            if (value != "") {
                              //check if task is null
                              if (widget.task == null) {
                                Task _newTask = Task(title: value);

                                _taskId = await _dbHelper.insertTask(_newTask);
                                setState(() {
                                  _contentVisible = true;
                                  _taskTitle = value;
                                });
                              } else {
                                print("update");
                              }

                              _descriptionFocus?.requestFocus();
                            }
                          },
                          controller: TextEditingController()
                            ..text = _taskTitle.toString(),
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
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) {
                          _todoFocus?.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Enter description for task",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ), // description
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTodo(_taskId!),
                        builder: (context, AsyncSnapshot snapshot) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      //Switch the todo completion state
                                    },
                                    child: TodoWidget(
                                      text: snapshot.data[index].title,
                                      isDone: snapshot.data[index].isDone == 0
                                          ? false
                                          : true,
                                    ),
                                  );
                                }),
                          );
                        }),
                  ), //builds todo list
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          margin: EdgeInsets.only(
                            right: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                              color: Color(0xFF868290),
                              width: 1.5,
                            ),
                          ),
                          child: Image(
                              image:
                                  AssetImage('assets/images/check_icon.png')),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _todoFocus,
                            onSubmitted: (value) async {
                              //check if field is not empty
                              if (value != "") {
                                //check if task is null
                                if (widget.task != null) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();

                                  Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    taskId: widget.task!.id,
                                  );

                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                } else {
                                  print("doesn't exist");
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Todo item...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ) //Todo item text field
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
