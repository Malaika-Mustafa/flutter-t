import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/add_task.dart';
import 'package:flutter_todo_app/todo_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';




class ListPage extends StatefulWidget {
  @override
  ListPageState createState() => ListPageState();
}



class ListPageState extends State<ListPage> {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: const Color(0xFFF5F7FA),
        scrolledUnderElevation: 0,
        title: Text('Tasks',
         style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
               
              ),),
        ),

      body: Padding(
        padding: const EdgeInsets.only(top:15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
         
          children: [
            Expanded(
              child: Consumer<ToDoProvider>(
                builder: (context, provider, _) {
                  final tasks = provider.getTasks();
                  return tasks.isNotEmpty
                      ? ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 251, 251),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              height: 80,
                              child: ListTile(
                                title: Text(tasks[index]),
                  
                                titleTextStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 41, 8, 131),
                                ),
                                
                                trailing: Row(
                                   mainAxisSize:MainAxisSize.min,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                  
                                 children: [
                                 
                                    InkWell(
                                   onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddData(
                                              existingTask: tasks[index],
                                              taskIndex: index,
                                            ),
                                          ),
                                        );
                                      },

                                    child: Icon(Icons.edit, color:const Color.fromARGB(255, 41, 8, 131),),
                                  ),

                                    SizedBox(width: 14),
                                    InkWell(
                                      onTap: () {
                                        context.read<ToDoProvider>().deleteTask(index);
                                      },
                                      child: Icon(Icons.delete, color:const Color.fromARGB(255, 41, 8, 131),),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: Text('No tasks yet!'));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
        heroTag: 'add_task',
        backgroundColor: const Color.fromARGB(255, 41, 8, 131),
        shape: CircleBorder(),
        elevation: 5,
        
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddData()),
          );
          
        },
        child: Icon(Icons.add, color: Colors.white,size: 35,),
      
      ),
    );
  }
}