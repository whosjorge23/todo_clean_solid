import 'package:flutter/material.dart';
import 'package:todo_clean_solid/constants/todo_constants.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/services/context_extension.dart';
import 'package:todo_clean_solid/shared_export.dart';

class CategoryChip extends StatefulWidget {
  CategoryChip(
      {super.key,
      required this.onTap,
      required this.isSelected,
      required this.category,
      required this.currentBrightness});

  Function() onTap;
  bool isSelected;
  TodoCategory category;
  Brightness currentBrightness;

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          color: widget.isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.7) : null,
        ),
        child: Center(
          child: Text(
            getTralatedCategory(widget.category.name),
            style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(
                  color: widget.isSelected
                      ? appColors.white
                      : widget.currentBrightness == Brightness.light
                          ? appColors.blue
                          : null,
                ),
          ),
        ),
      ),
    );
  }

  String getTralatedCategory(String category) {
    String translatedCategory = "";
    switch (category) {
      case "All":
        translatedCategory = context.l10n.category_all;
      case "Grocery":
        translatedCategory = context.l10n.category_grocery;
      case "Shopping":
        translatedCategory = context.l10n.category_shopping;
      case "Todo":
        translatedCategory = context.l10n.category_todo;
      case "CheckList":
        translatedCategory = context.l10n.category_checklist;
    }
    return translatedCategory;
  }
}
