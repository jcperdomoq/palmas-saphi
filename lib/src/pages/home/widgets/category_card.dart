import 'package:flutter/material.dart';
import 'package:las_palmas/models/home/category.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool selected = false;

  @override
  void initState() {
    selected = widget.category.selected;
    super.initState();
  }

  void onTap() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              selected ? Colors.grey[400]! : Colors.white,
              BlendMode.modulate,
            ),
            child: Container(
              width: 170,
              height: 110,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: styleCard(),
              child: Image.asset(
                widget.category.pathImage,
              ),
            ),
          ),
          Text(
            widget.category.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF242424),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration styleCard() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      boxShadow: [
        BoxShadow(
          color: Color(0x19000000),
          blurRadius: 5,
          spreadRadius: 2,
          offset: Offset(0, 4),
        )
      ],
    );
  }
}
