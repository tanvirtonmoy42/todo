import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:todo/domain/add_todo_model.dart';
import 'package:todo/domain/todo_model.dart';

abstract class ITodoRepo {
  Future<IList<TodoModel>> getTodos();
  Future<TodoModel> getTodoById({required int id});
  Future<void> addTodo({required AddTodoModel todo});
  Future<void> updateTodo({required AddTodoModel todo, required int id});
  Future<void> deleteTodo({required int id});
}
