import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String label;
  final EdgeInsets? margin;
  const CustomButton({Key? key, required this.label, this.onTap, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF00C347),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          splashColor: const Color(0xFF0E7D50),
          // highlightColor: Colors.blue,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 38,
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SegoeUI'),
            ),
          ),
        ),
      ),
    );
  }
}
