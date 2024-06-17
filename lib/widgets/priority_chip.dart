import 'package:flutter/material.dart';
import 'package:todo_clean_solid/constants/todo_constants.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/services/context_extension.dart';
import 'package:todo_clean_solid/shared_export.dart';

class PriorityChip extends StatefulWidget {
  PriorityChip(
      {super.key,
      required this.onTap,
      required this.isSelected,
      required this.priority,
      required this.currentBrightness});

  Function() onTap;
  bool isSelected;
  TodoPriority priority;
  Brightness currentBrightness;

  @override
  State<PriorityChip> createState() => _PriorityChipState();
}

class _PriorityChipState extends State<PriorityChip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        width: 120,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          border: Border.all(
            color: getColorTodoPriority(widget.priority),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          color: widget.isSelected ? getColorTodoPriority(widget.priority) : null,
        ),
        child: Center(
          child: Text(
            getTralatedPriority(widget.priority.name),
            style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(
                  color: widget.isSelected ? appColors.white : getColorTodoPriority(widget.priority),
                ),
          ),
        ),
      ),
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
