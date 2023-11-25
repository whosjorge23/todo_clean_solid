import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:todo_clean_solid/constants/todo_contants.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/features/todo_list/cubit/todo_cubit.dart';
import 'package:todo_clean_solid/shared_export.dart';

class ListViewCategory extends StatelessWidget {
  const ListViewCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: TodoCategory.values.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.read<TodoCubit>().getTodosByCategory(TodoCategory.values[index]);
          },
          child: Container(
            padding: const EdgeInsets.all(7),
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(5),
                Text(
                  TodoCategory.values[index].name,
                  style: appTextStyle.getQuicksand(MyFontWeight.bold),
                ),
                const Gap(5),
              ],
            ),
          ),
        );
      },
    );
  }
}
