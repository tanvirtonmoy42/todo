import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/domain/add_todo_model.dart';
import 'package:todo/domain/i_todo_repo.dart';
import 'package:todo/domain/todo_model.dart';

class TodoRepo extends ITodoRepo {
  final Database db;
  TodoRepo({required this.db});

  @override
  Future<IList<TodoModel>> getTodos() async {
    final response = await db.query('todos');
    final list =
        response.map((e) => TodoModel.fromMap(e)).toList(growable: false);
    print(list);
    return list.toIList();
  }

  @override
  Future<TodoModel> getTodoById({required int id}) async {
    final response = await db.query('todos', where: 'id =?', whereArgs: [id]);
    return TodoModel.fromMap(response.first);
  }

  @override
  Future<void> addTodo({required AddTodoModel todo}) async {
    await db.insert('todos', todo.toMap());
  }

  @override
  Future<void> updateTodo({required AddTodoModel todo, required int id}) async {
    await db.update('todos', todo.toMap(), where: 'id =?', whereArgs: [id]);
  }

  @override
  Future<void> deleteTodo({required int id}) async {
    await db.delete('todos', where: 'id =?', whereArgs: [id]);
  }
}
