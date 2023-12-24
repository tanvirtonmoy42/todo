import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/application/db_provider.dart';
import 'package:todo/domain/i_todo_repo.dart';
import 'package:todo/domain/todo_model.dart';
import 'package:todo/infrastructure/todo_repo.dart';

final todoRepoProvider = FutureProvider<ITodoRepo>((ref) async {
  final db = await ref.watch(dbfProvider.future);
  return TodoRepo(db: db);
});

final todoListProvider = FutureProvider<IList<TodoModel>>((ref) async {
  final repo = await ref.read(todoRepoProvider.future);
  return repo.getTodos();
});

final todoByIdProvider = FutureProvider.family<TodoModel, int>((ref, id) async {
  final repo = await ref.read(todoRepoProvider.future);
  return repo.getTodoById(id: id);
});
