import 'package:flutter/material.dart';
import 'package:todo_clean_solid/constants/todo_constants.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/shared_export.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({super.key, required this.onChanged});

  final ValueChanged<TodoCategory?>? onChanged;

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  TodoCategory? _selectedCategory = TodoCategory.All;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TodoCategory?>(
      value: _selectedCategory,
      onChanged: (TodoCategory? newValue) {
        setState(() {
          _selectedCategory = newValue;
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
