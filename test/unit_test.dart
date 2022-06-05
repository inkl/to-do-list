import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';

import 'package:todo/models/data_model.dart';

void main() {

  group('To-Do', () {
    ObservableList<TodoListBase> todoList = ObservableList<TodoListBase>.of([]);
    test('should start at 0', () {
      expect(todoList.length, 0);
    });

    test('should be incremented when adding', () {
      final TodoListBase todo = TodoListBase();
      todo.id = 100;
      todo.title = 'Testing id is 100';
      todo.startDate = DateTime.now().microsecondsSinceEpoch;
      todo.endDate = DateTime.now().add(Duration(days: 1)).microsecondsSinceEpoch;
      todoList.add(todo);
      expect(todoList.isNotEmpty, true);
    });

    test('should retrieve todo items', () {
      TodoListBase? todo = todoList.where((element) => element.id == 100).first;
      expect(todo != null, true);
    });

    test('should be changed when updating', () {
      TodoListBase? todo = todoList.where((element) => element.id == 100).first;
      var title = todo.title;
      todo.title = 'Testing id confirmed is 100';

      expect(title != todo.title, true);
    });
  });

}
