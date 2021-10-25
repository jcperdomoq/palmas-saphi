import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Search extends StatelessWidget {
  final String hintText;
  final Function(String)? onChange;
  final Widget? suffixIcon;
  final bool autoFocus;

  const Search({
    Key? key,
    this.hintText = '',
    this.onChange,
    this.suffixIcon,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 44,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            textCapitalization: TextCapitalization.words,
            autofocus: autoFocus,
            onChanged: (value) {},
            decoration: inputDecoration(context),
          ),
        ),
        const SizedBox(width: 10),
        SvgPicture.asset('assets/images/search.svg')
      ],
    );
  }

  InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF878D90)),
      // filled: true,
      border: InputBorder.none,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 0,
      ),
      prefixIconConstraints: const BoxConstraints.expand(
        width: 24,
        height: 14,
      ),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints.expand(
        width: 30,
        height: 24,
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }
}
