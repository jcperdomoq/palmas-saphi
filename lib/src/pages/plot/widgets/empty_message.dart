import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    Key? key,
    required this.editable,
  }) : super(key: key);

  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.topCenter,
      child: Text(
        editable
            ? 'No se visualizan parcelas cerca de su posición'
            : 'No tiene reportes pendientes',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF666666),
        ),
      ),
    );
  }
}
