import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/todo_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;


class AddData extends StatefulWidget {
  final String? existingTask;
  final int? taskIndex;


  const AddData({super.key,
    this.existingTask,
    this.taskIndex,
    
  });

  @override
  AddDataState createState() => AddDataState();
}

class AddDataState extends State<AddData> {
  
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color textColor = const Color.fromARGB(255, 41, 8, 131);
  

  final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late Location local;
 
@override
  void initState() {
    super.initState();
    init();
    if (widget.existingTask != null) {
    _taskController.text = widget.existingTask!;
  }
  }
     Future<void> init() async {
  tz.initializeTimeZones();

  try {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    local = getLocation(currentTimeZone);
  } catch (e) {
    local = getLocation('Asia/Karachi');
  }
  setLocalLocation(local);
 

  const androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // const DarwinInitializationSettings iosSettings =
  //     DarwinInitializationSettings();

  const InitializationSettings initializationSettings =
      InitializationSettings(
    android: androidSettings,
    // iOS: iosSettings,
  );
  
  await notificationsPlugin.initialize(initializationSettings);
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }
   Future<void> pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

   if (pickedTime != null){
    setState(() { 
        selectedTime = pickedTime;      
        _timeController.text = "${pickedTime.hour}:${pickedTime.minute}";
      });
   }
    }


  
  Future<void> scheduleReminder(BuildContext context, String text, TimeOfDay time,DateTime date) async {
 
    TZDateTime scheduledDate = TZDateTime(
      local,
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );


     int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    if (!scheduledDate.isAfter(DateTime.now())) {
      // avoid scheduling in the past
      return;
    }
    await notificationsPlugin.zonedSchedule(
      id, // notification ID
      'Reminder: ',
      text,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Channel for scheduled reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        // iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

      // matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }


  @override
  void dispose() {
    _taskController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      
      debugShowCheckedModeBanner: false,
     theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
        ),
     ),
      home: Scaffold(

        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor,size:25),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Hero(
            tag: 'add_task',
           
            child: Text(
              'New Task',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 41, 8, 131),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 41, 8, 131),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 1,
                          color: Color.fromRGBO(225, 230, 239, 1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            blurRadius: 0.5,
                            spreadRadius: 0.8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        
                        controller: _taskController,
                        
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintText: 'Enter Task',
                          hintStyle: TextStyle(
                            letterSpacing: -0.6,
                            color: const Color.fromRGBO(225, 230, 239, 1),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Reminder Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 41, 8, 131),
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(225, 230, 239, 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 0.5,
                              spreadRadius: 0.8,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today,
                             color: const Color.fromARGB(255, 41, 8, 131),
                      ),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                            hintText: 'Set Date',
                            hintStyle: TextStyle(
                              letterSpacing: -0.6,
                              color: const Color.fromRGBO(225, 230, 239, 1),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Reminder Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 41, 8, 131),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          width: 1,
                          color: Color.fromRGBO(225, 230, 239, 1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            blurRadius: 0.5,
                            spreadRadius: 0.8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.alarm),
                            color: const Color.fromARGB(255, 41, 8, 131),
                            iconSize: 26,
                            onPressed: () {
                              pickTime(context);
                            },
                          ),
                          hintText: 'Set Time',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintStyle: TextStyle(
                            letterSpacing: -0.6,
                            color: const Color.fromRGBO(225, 230, 239, 1),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      final task = _taskController.text.trim();
                      final dateText = _dateController.text;
                      final timeText = _timeController.text;
                     

                      if (task.isEmpty || dateText.isEmpty || timeText.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error',
                               style: TextStyle(
                              color: Colors.red,
                              
                            ),),
                              content: Text('Please fill in all fields.',
                               style: TextStyle(
                              color: textColor,
                             
                            ),),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      // Check if selected date is today
                      final now = DateTime.now();
                      
                      final scheduledDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    if (scheduledDateTime.isBefore(now)) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Invalid Time',
                             style: TextStyle(
                              color: Colors.red,
                             
                            ),),
                            content: Text('Please select a future time.',
                            style: TextStyle(
                              color: textColor,
                              
                            ),),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                   if (widget.taskIndex != null) {
                    context.read<ToDoProvider>().updateTask(widget.taskIndex!, task);
                  } else {
                    context.read<ToDoProvider>().addTask(task);
                              }

                      scheduleReminder(context, task, selectedTime, selectedDate);
                      Navigator.pop(context);
                      showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green,size: 40,),
                              SizedBox(width: 10),
                              Text('Task Added',style:TextStyle(color: textColor),),
                            ],
                          ),
                          // content: Text('Your task has been added successfully!',style:TextStyle(color: textColor),),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close',style:TextStyle(color: textColor),),
                            ),
                          ],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        );
                      },
                    );

                    },
                    
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 8, 131),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text('Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      
                      _dateController.clear();
                      _taskController.clear();
                      _timeController.clear();
                      selectedDate = DateTime.now();
                      selectedTime = TimeOfDay.now();
                       
                      
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 8, 131),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text('Clear',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
           
            ],
          ),
        ),
      ),
    );
  }
}