import 'package:flutter/material.dart';
import 'package:todo_clean_solid/constants/todo_constants.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/services/context_extension.dart';
import 'package:todo_clean_solid/shared_export.dart';

class PriorityDropdown extends StatefulWidget {
  PriorityDropdown({super.key, required this.onChanged, this.selectedPriority = TodoPriority.Low});

  final ValueChanged<TodoPriority?>? onChanged;
  late TodoPriority? selectedPriority;

  @override
  State<PriorityDropdown> createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<PriorityDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<TodoPriority?>(
      value: widget.selectedPriority,
      onChanged: (TodoPriority? newValue) {
        setState(() {
          if (widget.selectedPriority != null) {
            widget.selectedPriority = newValue;
          }
        });
        widget.onChanged?.call(newValue);
      },
      items: TodoPriority.values.map((TodoPriority priority) {
        return DropdownMenuItem<TodoPriority?>(
          value: priority,
          child: Text(
            getTralatedPriority(priority.toString().split('.').last),
            style: appTextStyle.getQuicksand(MyFontWeight.regular).copyWith(color: getColorTodoPriority(priority)),
          ),
        );
      }).toList(),
    );
  }

  Color getColorTodoPriority(TodoPriority todoPriority) {
    Color todoPriorityColor = Colors.grey;
    switch (todoPriority) {
      case TodoPriority.Low:
        todoPriorityColor = appColors.green;
        break;
      case TodoPriority.Medium:
        todoPriorityColor = appColors.yellow;
        break;
      case TodoPriority.High:
        todoPriorityColor = appColors.orange;
        break;
      case TodoPriority.Maximum:
        todoPriorityColor = appColors.red;
        break;
    }
    return todoPriorityColor;
  }

  String getTralatedPriority(String priority) {
    String translatedPriority = "";
    switch (priority) {
      case "Low":
        translatedPriority = context.l10n.priority_low;
      case "Medium":
        translatedPriority = context.l10n.priority_medium;
      case "High":
        translatedPriority = context.l10n.priority_high;
      case "Maximum":
        translatedPriority = context.l10n.priority_maximum;
    }
    return translatedPriority;
  }
}
