import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_standard/shared/components/appbar/language_dropdown.dart';

class AppBarCustom extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final String? currentRouteName;
  final String? title;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const AppBarCustom({
    super.key,
    this.currentRouteName,
    this.title,
    this.automaticallyImplyLeading = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? 'LevelUp Money Life';

    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        automaticallyImplyLeading: automaticallyImplyLeading,
        border: const Border(
          bottom: BorderSide(color: Color(0x33000000), width: 0.0),
        ),
        middle: Text(
          displayTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Material(
          type: MaterialType.transparency,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LanguageDropdown(context: context),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      );
    }

    // Android/Material implementation
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          displayTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          LanguageDropdown(context: context),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
