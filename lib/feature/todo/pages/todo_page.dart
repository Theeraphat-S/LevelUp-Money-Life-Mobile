import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_app_standard/feature/todo/bloc/todo_bloc.dart';
import 'package:mobile_app_standard/feature/todo/model/todo_model.dart';
import 'package:mobile_app_standard/feature/todo/widgets/dialog/add_todo_dialog.dart';
import 'package:mobile_app_standard/i18n/i18n.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';
import 'package:mobile_app_standard/shared/tokens/p_size.dart';
import 'package:mobile_app_standard/shared/tokens/p_spacing.dart';
import 'package:mobile_app_standard/shared/components/appbar/appbar_custom.dart';
import 'package:mobile_app_standard/shared/components/appbar/bottombar_custom.dart';

@RoutePage()
class TodoPage extends HookWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRouteName = context.routeData.name;
    final msg = AppLocalizations(context).todoPage;

    final displayedItems = useState(8);
    final scrollController = useScrollController();

    useEffect(() {
      void onScroll() {
        if (scrollController.position.extentAfter < 200) {
          displayedItems.value += 3;
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    void showAddTodoDialog() {
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (dialogContext) => BlocProvider.value(
            value: context.read<TodoBloc>(),
            child:
                AddTodoDialog(), // Note: AddTodoDialog likely returns Dialog/AlertDialog which are Material. Should adaptive that too? Assuming it works for now or needs fix later.
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (dialogContext) => BlocProvider.value(
            value: context.read<TodoBloc>(),
            child: AddTodoDialog(),
          ),
        );
      }
    }

    final appBarActions = Platform.isIOS
        ? [
            IconButton(
              icon: const Icon(CupertinoIcons.add, color: Colors.blue),
              onPressed: showAddTodoDialog,
            ),
          ]
        : null;

    final bodyContent = Container(
      decoration: BoxDecoration(color: PColor.backgroundColor),
      child: Column(
        children: [
          if (!Platform.isIOS)
            Padding(
              padding: const EdgeInsets.all(PSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(PSpacing.xs),
                        decoration: BoxDecoration(
                          color: PColor.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.list_alt_rounded,
                          color: PColor.primaryColor,
                        ),
                      ),
                      const SizedBox(width: PSpacing.md),
                      Text(
                        msg.title_todo,
                        style: const TextStyle(
                          fontSize: PText.text2xl,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (todoContext, state) {
                final List<TodoModel> items = [];
                if (state is TodoLoading) {
                  return Center(
                    child: Platform.isIOS
                        ? const CupertinoActivityIndicator()
                        : const CircularProgressIndicator(),
                  );
                }
                if (state is TodoLoaded) {
                  items.addAll(state.todos);
                }

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 80,
                          color: PColor.textNeutralColor.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: PSpacing.lg),
                        Text(
                          msg.text_no_todo,
                          style: const TextStyle(
                            fontSize: PText.textLg,
                            color: PColor.textNeutralColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: PSpacing.sm),
                        Text(
                          'Tap + to create a new task',
                          style: TextStyle(
                            fontSize: PText.textSm,
                            color: PColor.textNeutralColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final limitedItems = items.take(displayedItems.value).toList();

                if (Platform.isIOS) {
                  return CupertinoListSection.insetGrouped(
                    backgroundColor: Colors.transparent,
                    header: Text(msg.title_todo),
                    children: [
                      ...limitedItems.map((item) {
                        return CupertinoListTile(
                          title: Text(item.title),
                          subtitle: Text(item.content),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Icon(CupertinoIcons.up_arrow),
                                onPressed: () {
                                  context.read<TodoBloc>().add(
                                    UpdatePriorityTodo(
                                      id: item.id,
                                      priority: item.priority + 1,
                                    ),
                                  );
                                },
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Icon(CupertinoIcons.down_arrow),
                                onPressed: () {
                                  context.read<TodoBloc>().add(
                                    UpdatePriorityTodo(
                                      id: item.id,
                                      priority: item.priority - 1,
                                    ),
                                  );
                                },
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  CupertinoIcons.delete,
                                  color: PColor.errorColor,
                                ),
                                onPressed: () {
                                  context.read<TodoBloc>().add(
                                    DeleteTodo(id: item.id),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      if (items.length > displayedItems.value)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CupertinoActivityIndicator()),
                        ),
                    ],
                  );
                }

                // Android / Material implementation
                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200 &&
                        items.length > displayedItems.value) {
                      displayedItems.value += 3;
                    }
                    return true;
                  },
                  child: ListView.separated(
                    itemCount: limitedItems.length + 1,
                    padding: const EdgeInsets.symmetric(
                      horizontal: PSpacing.lg,
                      vertical: PSpacing.lg,
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: PSpacing.md),
                    itemBuilder: (context, index) {
                      if (index == limitedItems.length) {
                        return items.length > displayedItems.value
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(PSpacing.lg),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox.shrink();
                      }

                      final item = limitedItems[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              // Optional: Add tap handling details
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(PSpacing.md),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 4,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: PColor.primaryColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: PSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: PText.textBase,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: PSpacing.xs),
                                        Text(
                                          item.content,
                                          style: const TextStyle(
                                            fontSize: PText.textSm,
                                            color: PColor.textNeutralColor,
                                            height: 1.4,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_upward_rounded,
                                        ),
                                        iconSize: 20,
                                        color: PColor.textNeutralColor,
                                        tooltip: 'Increase Priority',
                                        onPressed: () {
                                          context.read<TodoBloc>().add(
                                            UpdatePriorityTodo(
                                              id: item.id,
                                              priority: item.priority + 1,
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_downward_rounded,
                                        ),
                                        iconSize: 20,
                                        color: PColor.textNeutralColor,
                                        tooltip: 'Decrease Priority',
                                        onPressed: () {
                                          context.read<TodoBloc>().add(
                                            UpdatePriorityTodo(
                                              id: item.id,
                                              priority: item.priority - 1,
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                        ),
                                        iconSize: 20,
                                        color: PColor.errorColor,
                                        tooltip: 'Delete',
                                        onPressed: () {
                                          context.read<TodoBloc>().add(
                                            DeleteTodo(id: item.id),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar:
            AppBarCustom(
                  currentRouteName: currentRouteName,
                  actions: appBarActions,
                )
                as ObstructingPreferredSizeWidget,
        child: SafeArea(
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                Expanded(child: bodyContent),
                BottomBarCustom(currentRouteName: currentRouteName),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarCustom(currentRouteName: currentRouteName),
      bottomNavigationBar: BottomBarCustom(currentRouteName: currentRouteName),
      backgroundColor: PColor.backgroundColor,
      body: bodyContent,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: PColor.primaryColor,
          foregroundColor: Colors.white,
          onPressed: showAddTodoDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
