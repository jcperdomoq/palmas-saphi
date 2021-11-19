import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:las_palmas/models/api/plots.dart';
import 'package:las_palmas/src/pages/plants/plant_page.dart';
import 'package:las_palmas/src/pages/plot/widgets/category_label.dart';
import 'package:las_palmas/src/pages/plot/widgets/empty_message.dart';
import 'package:las_palmas/src/providers/plants_provider.dart';
import 'package:las_palmas/src/providers/plots_provider.dart';
import 'package:provider/provider.dart';

class PlantacionPage extends StatefulWidget {
  final bool showFilter;
  final bool editable;

  const PlantacionPage(
      {Key? key, this.showFilter = false, this.editable = true})
      : super(key: key);

  @override
  State<PlantacionPage> createState() => _PlantacionPageState();
}

class _PlantacionPageState extends State<PlantacionPage> {
  Timer? timer;

  @override
  void didChangeDependencies() {
    if (timer == null) {
      loadPeriodicData();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  loadPeriodicData() {
    final plotsProvider = Provider.of<PlotsProvider>(context);
    plotsProvider.loadPlantacionFromStorage();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      plotsProvider.loadPlantacionFromStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plotsProvider = Provider.of<PlotsProvider>(context);
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
    final areaCategory = plantsProvider.categoryAreaSelected?.name;
    final evaluationCategory = plantsProvider.categoriesEvaluationSelected
        .map((e) => e.name)
        .join('_');

    // final plots =
    //     widget.editable ? plotsProvider.plots : plotsProvider.plantReports;
    final features = plotsProvider.features;
    return Scaffold(
      backgroundColor:
          widget.showFilter ? Colors.white : const Color(0xFFF5F4F4),
      appBar: widget.showFilter ? null : buildAppbar(context),
      body: SafeArea(
        bottom: false,
        top: widget.showFilter,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: widget.showFilter ? 30 : 0,
            bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 80 : 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (showFilter) const Search(hintText: 'Buscar'),
              if (!widget.showFilter) const SizedBox(height: 30),
              if (!widget.showFilter) titleLabel(),
              const SizedBox(height: 10),
              if (widget.editable) const CategoryLabel(),
              Expanded(
                child: features.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            ...features.map<Widget>(
                              (feature) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        openDetailPlant(
                                            context,
                                            Plant(
                                              type:
                                                  '${areaCategory}_$evaluationCategory',
                                              plantacion: feature.plantacion,
                                              parcela:
                                                  feature.properties!.parcela,
                                              campania:
                                                  feature.properties!.campaa,
                                            ),
                                            Plots(
                                              id: feature.properties!.campaa,
                                              name: feature.properties!.campaa,
                                            ),
                                            const Color(0xFF00C347));
                                      },
                                      child: labelCard(
                                        label:
                                            '${feature.properties!.parcela} (Campaña ${feature.properties!.campaa})',
                                        verticalPadding: 16,
                                        width: double.infinity,
                                        color: const Color(0xFF00C347),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // listPlots(plot, plants),
                                  ],
                                );
                              },
                            ).toList(),
                          ],
                        ),
                      )
                    : EmptyMessage(editable: widget.editable),
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
        final statusColor = !widget.editable
            ? const Color(0xFF00C347)
            : plant.color ?? const Color(0xFFF92B77);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            labelCard(
              label: 'Linea ${plant.linea}, Planta ${plant.planta}',
              verticalPadding: 5,
              color: statusColor,
              width: MediaQuery.of(context).size.width * 0.8,
              onTap: () => openDetailPlant(context, plant, plot, statusColor),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  openDetailPlant(
      BuildContext context, Plant plant, Plots plot, Color statusColor) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => PlantPage(
          plant: plant,
          editable: widget.editable,
          plot: plot,
          statusColor: statusColor,
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
          color: !widget.showFilter ? Colors.white : const Color(0xFFF5F4F4),
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
      backgroundColor:
          widget.showFilter ? Colors.white : const Color(0xFFF5F4F4),
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
