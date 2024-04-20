import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_solid/constants/todo_constants.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/features/todo_list/cubit/todo_cubit.dart';
import 'package:todo_clean_solid/shared_export.dart';

class ListViewCategory extends StatefulWidget {
  const ListViewCategory({Key? key}) : super(key: key);

  @override
  _ListViewCategoryState createState() => _ListViewCategoryState();
}

class _ListViewCategoryState extends State<ListViewCategory> {
  int selectedIndex = 0; // Initialize with no category selected

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: TodoCategory.values.length,
      itemBuilder: (context, index) {
        bool isSelected = index == selectedIndex;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              selectedIndex = index; // Update selected index on tap
            });
            context.read<TodoCubit>().getTodosByCategory(TodoCategory.values[index]);
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
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                  : null, // Set background color to red if selected
            ),
            child: Center(
              child: Text(
                TodoCategory.values[index].name,
                style: appTextStyle.getQuicksand(MyFontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}
