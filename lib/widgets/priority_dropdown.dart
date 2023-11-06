import 'package:flutter/material.dart';
import 'package:todo_clean_solid/extension/text_style.dart';
import 'package:todo_clean_solid/features/todo_list/cubit/todo_cubit.dart';
import 'package:todo_clean_solid/shared_export.dart';

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
          child: Text(
            priority.toString().split('.').last,
            style:
                quickSandTextStyle.getQuicksand(MyFontWeight.regular).copyWith(color: getColorTodoPriority(priority)),
          ),
        );
      }).toList(),
    );
  }

  Color getColorTodoPriority(TodoPriority todoPriority) {
    Color todoPriorityColor = Colors.grey;
    switch (todoPriority) {
      case TodoPriority.low:
        todoPriorityColor = Colors.green;
        break;
      case TodoPriority.medium:
        todoPriorityColor = Colors.amber;
        break;
      case TodoPriority.high:
        todoPriorityColor = Colors.orange;
        break;
      case TodoPriority.maximum:
        todoPriorityColor = Colors.red;
        break;
    }
    return todoPriorityColor;
  }
}
