import 'package:flutter/material.dart';
import 'package:todo_clean_solid/features/cubit/todo_cubit.dart';

class PriorityDropdown extends StatefulWidget {
  const PriorityDropdown({super.key, required this.onChanged});

  final ValueChanged<TodoPriority?>? onChanged;

  @override
  State<PriorityDropdown> createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<PriorityDropdown> {
  TodoPriority? _selectedPriority = TodoPriority.low;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TodoPriority?>(
      value: _selectedPriority,
      onChanged: (TodoPriority? newValue) {
        setState(() {
          _selectedPriority = newValue;
        });
        widget.onChanged?.call(newValue);
      },
      items: TodoPriority.values.map((TodoPriority priority) {
        return DropdownMenuItem<TodoPriority?>(
          value: priority,
          child: Text(priority.toString().split('.').last),
        );
      }).toList(),
    );
  }
}
