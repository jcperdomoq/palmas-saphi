import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:las_palmas/models/home/category.dart';
import 'package:las_palmas/src/pages/home/widgets/category_card.dart';
import 'package:las_palmas/src/pages/plot/plots_page.dart';
import 'package:las_palmas/src/widgets/custom_buttom.dart';

class HomePage extends StatelessWidget {
  final Map<String, List<Category>> categories = {
    'Area': [
      Category(name: 'Suelo', pathImage: 'assets/images/team.png'),
      Category(name: 'I+D', pathImage: 'assets/images/investigation.png'),
    ],
    'Evaluación': [
      Category(
          name: 'Deficiencia Nutricional',
          pathImage: 'assets/images/palm_tree.png'),
      Category(name: 'Biometría', pathImage: 'assets/images/leaf.png'),
    ],
  };

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 80 : 60,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 40),
              buildCategories(),
              const SizedBox(height: 10),
              CustomButton(
                label: 'INICIAR',
                onTap: () => goToPlotPage(context),
                margin: const EdgeInsets.symmetric(horizontal: 42),
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToPlotPage(context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => PlotsPage()),
    );
  }

  Widget buildCategories() {
    return Column(
      children: categories.keys.map<Widget>((key) {
        return buildCategory(key);
      }).toList(),
    );
  }

  Widget buildCategory(String key) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: const TextStyle(
              color: Color(0xFF242424),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories[key]?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.90,
            ),
            itemBuilder: (context, index) {
              final category = categories[key]![index];
              return CategoryCard(
                category: category,
              );
            },
          ),
        ],
      ),
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      centerTitle: false,
      title: const Text(
        'Mis tareas',
        style: TextStyle(
          color: Color(0xFF242424),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      titleSpacing: 30,
      toolbarHeight: Platform.isIOS ? null : 90,
      elevation: 0,
    );
  }
}
