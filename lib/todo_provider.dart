import 'package:flutter/material.dart';

class ToDoProvider extends ChangeNotifier {
  final List<String> _tasks = [];

  void addTask(String task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void updateTask(int index, String newTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = newTask;
      notifyListeners();
    }
  }

  List<String> getTasks() => _tasks;
}