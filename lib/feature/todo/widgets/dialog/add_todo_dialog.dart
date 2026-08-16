import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/feature/todo/bloc/todo_bloc.dart';
import 'package:mobile_app_standard/i18n/i18n.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';
import 'package:mobile_app_standard/shared/tokens/p_size.dart';
import 'package:mobile_app_standard/shared/styles/p_style.dart';
import 'package:mobile_app_standard/shared/components/toasts/toast_helper.dart';

class AddTodoDialog extends StatelessWidget {
  AddTodoDialog({super.key});

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoBloc = context.read<TodoBloc>();
    final msg = AppLocalizations(context).todoPage;
    final msgGeneral = AppLocalizations(context).general;

    void onAdd() {
      todoBloc.add(
        AddTodo(title: _titleController.text, content: _contentController.text),
      );
      Navigator.of(context).pop();
      showSuccessToast(
        context: context,
        title: msg.text_added,
        description: msg.text_added_success,
      );
    }

    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.add_circled,
              color: PColor.primaryColor,
              size: PText.textXl,
            ),
            const SizedBox(width: 8),
            Text(msg.title_add_todo),
          ],
        ),
        content: Column(
          children: [
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: _titleController,
              placeholder: msg.label_title,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: _contentController,
              placeholder: msg.label_content,
              maxLength: 32,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(msgGeneral.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _titleController,
            builder: (context, titleValue, child) {
              return ValueListenableBuilder<TextEditingValue>(
                valueListenable: _contentController,
                builder: (context, contentValue, child) {
                  final isEnabled =
                      titleValue.text.isNotEmpty &&
                      (contentValue.text.isNotEmpty &&
                          contentValue.text.length >= 6);
                  return CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: isEnabled ? onAdd : null,
                    child: Text(
                      msgGeneral.add,
                      style: TextStyle(
                        color: isEnabled
                            ? PColor.primaryColor
                            : CupertinoColors.systemGrey,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      );
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.add, color: PColor.primaryColor, size: PText.text2xl),
          const SizedBox(width: 8),
          Text(msg.title_add_todo, style: const TextStyle(fontSize: PText.textXl)),
        ],
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: msg.label_title),
            ),
            TextField(
              maxLength: 32,
              controller: _contentController,
              decoration: InputDecoration(labelText: msg.label_content),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: PStyle.btnSecondary,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(msgGeneral.cancel),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _titleController,
          builder: (context, titleValue, child) {
            return ValueListenableBuilder<TextEditingValue>(
              valueListenable: _contentController,
              builder: (context, contentValue, child) {
                final isEnabled =
                    titleValue.text.isNotEmpty &&
                    (contentValue.text.isNotEmpty &&
                        contentValue.text.length >= 6);
                return TextButton(
                  onPressed: isEnabled ? onAdd : null,
                  child: Text(
                    msgGeneral.add,
                    style: TextStyle(
                      color: isEnabled ? PColor.primaryColor : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
