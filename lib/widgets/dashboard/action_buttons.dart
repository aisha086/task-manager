import 'package:flutter/material.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onViewFullList;
  final VoidCallback onAddNewTask;

  const ActionButtonsWidget({
    super.key,
    required this.onViewFullList,
    required this.onAddNewTask,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: onViewFullList,
          child: const Text('View Full List'),
        ),
        ElevatedButton(
          onPressed: onAddNewTask,
          child: const Text('Add New Task'),
        ),
      ],
    );
  }
}
