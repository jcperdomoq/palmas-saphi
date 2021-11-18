import 'dart:async';

import 'package:flutter/material.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  final List<MultiSelectDialogItem<V>> items;
  final List<V>? initialSelectedValues;
  final bool multiSelect;
  final String title;

  const MultiSelectDialog({
    Key? key,
    required this.items,
    this.initialSelectedValues,
    this.multiSelect = true,
    this.title = "",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = <V>[];

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues!);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (widget.multiSelect) {
        if (checked) {
          _selectedValues.add(itemValue);
        } else {
          _selectedValues.remove(itemValue);
        }
      } else {
        _selectedValues.clear();
        _selectedValues.add(itemValue);
        Timer(const Duration(milliseconds: 300), () {
          _onSubmitTap();
        });
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: const EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: widget.multiSelect
          ? <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: _onCancelTap,
              ),
              TextButton(
                child: const Text('Aceptar'),
                onPressed: _onSubmitTap,
              )
            ]
          : [],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.label);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) =>
          _onItemCheckedChange(item.value, checked ?? false),
    );
  }
}
