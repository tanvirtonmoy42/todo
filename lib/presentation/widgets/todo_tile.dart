import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:todo/application/todo_provider.dart';
import 'package:todo/domain/add_todo_model.dart';
import 'package:todo/domain/todo_model.dart';
import 'package:todo/presentation/add_edit_todo_page.dart';
import 'package:todo/presentation/todo_details_page.dart';

class TodoTile extends ConsumerWidget {
  final TodoModel todo;
  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context, ref) {
    return Material(
      borderRadius: BorderRadius.circular(10.sp),
      elevation: 2,
      child: ListTile(
        onTap: () {
          // ref.invalidate(todoDetailsProvider(todo.id));
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TodoDetailsPage(id: todo.id)));
        },
        tileColor: Theme.of(context).colorScheme.primary.withOpacity(.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        title: Text(todo.title),
        subtitle: Text(
          todo.isCompleted == 1 ? 'Completed' : 'Pending',
          style: TextStyle(
            fontSize: 16.sp,
            color: todo.isCompleted == 1 ? Colors.greenAccent : Colors.yellow,
          ),
        ),
        trailing: PopupMenuButton(
          onSelected: (value) async {
            if (value == 1) {
              showDialog(
                  context: context,
                  builder: (context) => AddEditTodoPage(todo: todo));
            } else if (value == 2) {
              final addTodo = AddTodoModel(
                  title: todo.title,
                  description: todo.description,
                  isCompleted: todo.isCompleted == 1 ? 0 : 1);

              final repo = await ref.read(todoRepoProvider.future);
              await repo.updateTodo(todo: addTodo, id: todo.id);
              if (context.mounted) {
                ref.invalidate(todoListProvider);
              }
            } else if (value == 3) {
              final repo = await ref.read(todoRepoProvider.future);
              repo.deleteTodo(id: todo.id);
              if (context.mounted) {
                ref.invalidate(todoListProvider);
              }
            }
          },
          color: Colors.white,
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 1,
              child: Text('Edit'),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(todo.isCompleted == 1
                  ? 'Mark as Pending'
                  : 'Mark as Completed'),
            ),
            const PopupMenuItem(
              value: 3,
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
