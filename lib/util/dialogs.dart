import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:las_palmas/src/pages/plants/widgets/multi_select_dialog.dart';

enum DialogAction { accept, cancel }

class Dialogs {
  static bool _dialogVisible = false;
  static Future<List<String>?> showMultiSelect(
    BuildContext context, {
    bool multiSelect = true,
    String? title,
    required List<MultiSelectDialogItem<String>> items,
    List<String> initialSelectedValues = const [],
  }) async {
    final selectedValues = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: initialSelectedValues,
          multiSelect: multiSelect,
          title: title ?? '',
        );
      },
    );
    return selectedValues;
  }

  static Future<DialogAction> nativeDialog(
      {required BuildContext context,
      String? title,
      required String body,
      bool dismissible = false,
      String? cancelText,
      String? acceptText}) async {
    if (_dialogVisible) return DialogAction.cancel;

    _dialogVisible = true;
    if (Platform.isIOS) {
      var action = DialogAction.cancel;
      await showCupertinoDialog(
          context: context,
          barrierDismissible: dismissible,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: title != null ? Text(title) : null,
              content: Text(body),
              actions: <Widget>[
                CupertinoButton(
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  child: Text(
                    acceptText ?? 'Aceptar',
                    style: const TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop();
                    action = DialogAction.accept;
                    _dialogVisible = false;
                  },
                ),
                if (cancelText != null)
                  CupertinoButton(
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        color: CupertinoColors.destructiveRed,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      _dialogVisible = false;
                    },
                  ),
              ],
            );
          });

      return action;
    } else {
      var action = DialogAction.cancel;
      await showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(body),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  action = DialogAction.accept;
                  _dialogVisible = false;
                },
                child: Text(
                  acceptText ?? 'Aceptar',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (cancelText != null)
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    action = DialogAction.cancel;
                    _dialogVisible = false;
                  },
                  child: Text(
                    cancelText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          );
        },
      );

      return action;
    }
  }
}
