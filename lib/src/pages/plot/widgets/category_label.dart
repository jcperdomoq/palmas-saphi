import 'package:flutter/material.dart';
import 'package:las_palmas/src/providers/plants_provider.dart';
import 'package:provider/provider.dart';

class CategoryLabel extends StatelessWidget {
  const CategoryLabel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final evaluationCategory = plantsProvider.categoriesEvaluationSelected
        .map((e) => e.name)
        .join(', ');
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'ÁREA: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666666),
                ),
              ),
              Text(
                plantsProvider.categoryAreaSelected != null
                    ? plantsProvider.categoryAreaSelected!.name
                    : 'Suelo',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'EVALUACIÓN: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666666),
                ),
              ),
              Expanded(
                child: Text(
                  evaluationCategory.isNotEmpty
                      ? evaluationCategory
                      : 'Ningúna',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
