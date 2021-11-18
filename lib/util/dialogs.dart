import 'package:flutter/material.dart';
import 'package:las_palmas/src/pages/plants/widgets/multi_select_dialog.dart';

class Dialogs {
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
}
