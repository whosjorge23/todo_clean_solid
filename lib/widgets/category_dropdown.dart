import 'package:flutter/material.dart';
import 'package:todo_clean_solid/constants/todo_constants.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/shared_export.dart';

class CategoryDropdown extends StatefulWidget {
  CategoryDropdown({super.key, required this.onChanged, this.selectedCategory = TodoCategory.All});

  final ValueChanged<TodoCategory?>? onChanged;
  late TodoCategory? selectedCategory;

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<TodoCategory?>(
      value: widget.selectedCategory,
      onChanged: (TodoCategory? newValue) {
        setState(() {
          if (widget.selectedCategory != null) {
            widget.selectedCategory = newValue;
          }
        });
        widget.onChanged?.call(newValue);
      },
      items: TodoCategory.values.map((TodoCategory category) {
        return DropdownMenuItem<TodoCategory?>(
          value: category,
          child: Text(
            category.toString().split('.').last,
            style: appTextStyle.getQuicksand(MyFontWeight.regular),
          ),
        );
      }).toList(),
    );
  }
}
