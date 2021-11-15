import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:las_palmas/models/api/plots.dart';
import 'package:las_palmas/models/plot/plot.dart';
import 'package:las_palmas/src/pages/plants/plant_page.dart';
import 'package:las_palmas/src/providers/plots_provider.dart';
import 'package:provider/provider.dart';

class PlotsPage extends StatelessWidget {
  final bool showFilter;
  final bool editable;
  final Map<String, List<Plot>> localPlots = {
    'Parcela BCARD': [
      Plot('Planta Linea 1, Planta 145', const Color(0xFFF92B77)),
      Plot('Planta Linea 2, Planta 146', const Color(0xFF00C347)),
      Plot('Planta Linea 2, Planta 147', const Color(0xFFF92B77)),
      Plot('Planta Linea 2, Planta 148', const Color(0xFFF92B77)),
    ],
    'Parcela EDRDSA': [
      Plot('Planta Linea 1, Planta 15', const Color(0xFF00C347)),
      Plot('Planta Linea 1, Planta 17', const Color(0xFFF92B77)),
    ],
    'Parcela EDRDSB': [
      Plot('Planta Linea 41, Planta 7', const Color(0xFFF92B77)),
    ]
  };

  PlotsPage({Key? key, this.showFilter = false, this.editable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plotsProvider = Provider.of<PlotsProvider>(context);

    final plots = editable ? plotsProvider.plots : plotsProvider.plantReports;
    // if (!editable) {
    //   plotsProvider.loadColorPlots(plots);
    // }
    return Scaffold(
      backgroundColor: showFilter ? Colors.white : const Color(0xFFF5F4F4),
      appBar: showFilter ? null : buildAppbar(context),
      body: SafeArea(
        bottom: false,
        top: showFilter,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: showFilter ? 30 : 0,
            bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 80 : 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (showFilter) const Search(hintText: 'Buscar'),
              if (!showFilter) const SizedBox(height: 30),
              if (!showFilter) titleLabel(),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      ...plots.map<Widget>(
                        (plot) {
                          final plants = plot.plants;
                          final hasGreen = !editable
                              ? const Color(0xFF00C347)
                              : plants.indexWhere((plot) =>
                                  plot.color == const Color(0xFF00C347));
                          // final hasGreen = !editable;
                          return Column(
                            children: [
                              labelCard(
                                label: plot.name ?? '',
                                verticalPadding: 16,
                                width: double.infinity,
                                color: hasGreen != -1
                                    ? const Color(0xFF00C347)
                                    : const Color(0xFFF92B77),
                              ),
                              const SizedBox(height: 10),
                              listPlots(plot, plants),
                            ],
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding titleLabel() {
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        'Parcelas',
        style: TextStyle(
          fontSize: 30,
          color: Color(0xFF242424),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ListView listPlots(Plots plot, List<Plant> plants) {
    return ListView.builder(
      itemCount: plants.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final plant = plants[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            labelCard(
              label: 'Linea ${plant.line}, Planta ${plant.plant}',
              verticalPadding: 5,
              color: !editable
                  ? const Color(0xFF00C347)
                  : plant.color ?? const Color(0xFFF92B77),
              width: MediaQuery.of(context).size.width * 0.8,
              onTap: () => openDetailPlant(context, plant, plot),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  openDetailPlant(BuildContext context, Plant plant, Plots plot) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => PlantPage(
          plant: plant,
          editable: editable,
          plot: plot,
        ),
      ),
    );
  }

  Widget labelCard({
    required String label,
    required double verticalPadding,
    required double width,
    Color? color,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: !showFilter ? Colors.white : const Color(0xFFF5F4F4),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(72),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () => onBack(context),
        child: const Text(
          'Tareas',
          style: TextStyle(
            color: Color(0xFF242424),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      centerTitle: false,
      elevation: 0,
      leadingWidth: 30,
      backgroundColor: showFilter ? Colors.white : const Color(0xFFF5F4F4),
      leading: leadingButton(context),
    );
  }

  onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget leadingButton(BuildContext context) {
    return GestureDetector(
      onTap: () => onBack(context),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: 4, left: 16),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF242424),
        ),
      ),
    );
  }
}
