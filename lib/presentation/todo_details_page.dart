import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:todo/application/todo_provider.dart';
import 'package:todo/domain/add_todo_model.dart';

import 'add_edit_todo_page.dart';

class TodoDetailsPage extends ConsumerWidget {
  final int id;
  const TodoDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, ref) {
    final todo = ref.watch(todoByIdProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: todo.when(
          data: (data) => Text(data.title),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(
            child: Text(
              e.toString(),
            ),
          ),
        ),
        elevation: 0,
        actions: [
          todo.when(
            data: (data) => PopupMenuButton(
              onSelected: (value) async {
                if (value == 1) {
                  //on edit click
                  showDialog(
                      context: context,
                      builder: (context) => AddEditTodoPage(todo: data));
                  ref.invalidate(todoListProvider);
                  ref.invalidate(todoByIdProvider);
                } else if (value == 2) {
                  //on status update
                  final addTodo = AddTodoModel(
                      title: data.title,
                      description: data.description,
                      isCompleted: data.isCompleted == 1 ? 0 : 1);
                  final repo = await ref.read(todoRepoProvider.future);
                  await repo.updateTodo(todo: addTodo, id: data.id);
                  if (context.mounted) {
                    ref.invalidate(todoListProvider);
                    ref.invalidate(todoByIdProvider);
                  }
                } else if (value == 3) {
                  final repo = await ref.read(todoRepoProvider.future);
                  repo.deleteTodo(id: data.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
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
                  child: Text(data.isCompleted == 1
                      ? 'Mark as Pending'
                      : 'Mark as Completed'),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text('Delete'),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(
              child: Text(
                e.toString(),
              ),
            ),
          )
        ],
      ),
      body: todo.when(
        data: (data) => Padding(
          padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ----- title ------///
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 1.h),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.sp),
                      color: Colors.grey.withOpacity(.3)),
                  child: Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),

              /// ----- description ------///
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 1.h),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.sp),
                      color: Colors.grey.withOpacity(.3)),
                  child: Text(
                    data.description,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),

              /// ----- status ------///
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 1.h),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.sp),
                      color: Colors.grey.withOpacity(.3)),
                  child: Text(
                    data.isCompleted == 1 ? 'Completed' : 'Pending',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color:
                          data.isCompleted == 1 ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),
    );
  }
}
