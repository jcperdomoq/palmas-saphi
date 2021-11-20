import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabelField extends StatelessWidget {
  final String label;
  final String? value;
  final bool disabled;
  final TextEditingController? ctrl;
  final bool editable;
  final Function? onTap;
  final TextInputType? keyboardType;
  final int? maxLength;

  const LabelField({
    Key? key,
    required this.label,
    this.disabled = false,
    this.value,
    this.ctrl,
    this.editable = true,
    this.onTap,
    this.keyboardType,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ctrl != null && disabled) {
      ctrl!.text = value ?? '';
    }
    return GestureDetector(
      onTap: editable && !disabled
          ? () {
              if (onTap != null) {
                onTap!();
              }
            }
          : null,
      child: AbsorbPointer(
        absorbing: onTap != null,
        child: SizedBox(
          height: 58,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: 11,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              Positioned(
                left: 13,
                top: 1,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF969696),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                left: 34,
                right: 10,
                child: TextField(
                  controller: ctrl ?? TextEditingController(text: value),
                  enabled: editable && !disabled,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  style: const TextStyle(
                    color: Color(0xFF6E6E6E),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    counterText: '',
                    counter: null,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
