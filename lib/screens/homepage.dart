import 'package:flutter/material.dart';
import 'package:to_do_list_app/database_helper.dart';
import 'package:to_do_list_app/widgets.dart';
import 'package:to_do_list_app/screens/taskpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32.0,
                      bottom: 32.0,
                    ),
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, AsyncSnapshot snapshot) {
                        //AsyncSnapshot
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Taskpage(
                                            task: snapshot.data[index])),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Taskpage(task: null)),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0XFF7349FE), Color(0xFF643FDB)],
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child:
                        Image(image: AssetImage("assets/images/add_icon.png")),
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
