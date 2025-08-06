import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String taskName;
  final String taskDescription;
  final bool isDone;
  final Function(bool?) checkboxCallback;

  const TaskTile({
    super.key,
    required this.taskName,
    required this.taskDescription,
    required this.isDone,
    required this.checkboxCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        taskName,
        style: TextStyle(
          decoration: isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: taskDescription.isNotEmpty ? Text(taskDescription) : null,
      trailing: Checkbox(
        value: isDone,
        onChanged: checkboxCallback,
      ),
    );
  }
}
