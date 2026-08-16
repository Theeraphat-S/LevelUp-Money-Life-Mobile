import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/domain/repositories/todo_repo.dart';
import 'package:mobile_app_standard/feature/todo/model/todo_model.dart';
import 'package:mobile_app_standard/locator.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final todoRepo = locator<TodoRepositoryInterface>();

  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<UpdatePriorityTodo>(_onUpdateTodoPriority);
    add(LoadTodos());
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await todoRepo.getAllTodoItems();
      if (kDebugMode) {
        debugPrint('Loaded todos: $todos');
      }
      final todoModels = todos.map(TodoModel.fromDrift).toList();
      emit(TodoLoaded(todoModels));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load todos: $e');
      }
      emit(TodoError('Failed to load todos.'));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await todoRepo.addTodoItem(event.title, event.content);
      add(LoadTodos());
    } catch (e) {
      emit(TodoError('Failed to add todo: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await todoRepo.deleteTodoItem(event.id);
      add(LoadTodos());
    } catch (e) {
      emit(TodoError('Failed to delete todo: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTodoPriority(
      UpdatePriorityTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await todoRepo.updatePriorityTodoItem(event.id, event.priority);
      add(LoadTodos());
    } catch (e) {
      emit(TodoError('Failed to update todo: ${e.toString()}'));
    }
  }
}
