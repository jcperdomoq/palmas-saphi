import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:las_palmas/models/api/plots.dart';
import 'package:las_palmas/models/cache/cache_key.dart';
import 'package:las_palmas/src/providers/plants_provider.dart';
import 'package:las_palmas/src/providers/plots_provider.dart';
import 'package:las_palmas/src/widgets/custom_buttom.dart';
import 'package:provider/provider.dart';

class PlantPage extends StatelessWidget {
  final bool editable;
  final Plant plant;
  final Plots plot;
  const PlantPage({
    Key? key,
    required this.plot,
    required this.plant,
    this.editable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final plotsProvider = Provider.of<PlotsProvider>(context, listen: false);

    final isID = plantsProvider.containsForName('I+D');
    final isBiometrica = plantsProvider.containsForName('Biometría');
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F4),
      appBar: buildAppbar(context),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 80 : 60,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(26),
              decoration: formStyle(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Linea ${plant.line}, Planta ${plant.plant}',
                    style: const TextStyle(
                      color: Color(0xFF676767),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  headerLabel(),
                  const SizedBox(height: 18),
                  const Divider(
                    color: Color(0xFFD4D4D4),
                    height: 0,
                  ),
                  const SizedBox(height: 2),
                  labelField(
                    context,
                    label: 'DNI Evaluador',
                    value: editable ? '' : plant.dniEvaluador,
                    ctrl: plotsProvider.dniController,
                  ),
                  labelField(
                    context,
                    label: 'Parcela',
                    value: plot.name,
                    disabled: true,
                  ),
                  labelField(
                    context,
                    label: 'Campaña',
                    value: editable ? '' : plant.campania,
                    ctrl: plotsProvider.campaniaController,
                  ),
                  if (isID ||
                      (!editable &&
                          plant.ensayo != null &&
                          plant.ensayo!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Ensayo',
                      value: editable ? '' : plant.ensayo,
                      ctrl: plotsProvider.ensayoController,
                    ),
                  if (isID ||
                      (!editable &&
                          plant.bloque != null &&
                          plant.bloque!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Bloque',
                      value: editable ? '' : plant.bloque,
                      ctrl: plotsProvider.bloqueController,
                    ),
                  if (isID ||
                      (!editable &&
                          plant.tratamiento != null &&
                          plant.tratamiento!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Tratamiento',
                      value: editable ? '' : plant.tratamiento,
                      ctrl: plotsProvider.tratamientoController,
                    ),
                  labelField(
                    context,
                    label: 'Linea',
                    value: '${plant.line}',
                    disabled: true,
                  ),
                  labelField(
                    context,
                    label: 'Planta',
                    value: '${plant.plant}',
                    disabled: true,
                  ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.hojasVerdes != null &&
                          plant.hojasVerdes!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Nª Verdes',
                      value: editable ? '' : plant.hojasVerdes,
                      ctrl: plotsProvider.hojasVerdesController,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.stpAncho != null &&
                          plant.stpAncho!.isNotEmpty))
                    labelField(
                      context,
                      label: 'STP Ancho',
                      value: editable ? '' : plant.stpAncho,
                      ctrl: plotsProvider.stpAnchoController,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.stpEspesor != null &&
                          plant.stpEspesor!.isNotEmpty))
                    labelField(
                      context,
                      label: 'STP Espesor',
                      value: editable ? '' : plant.stpEspesor,
                      ctrl: plotsProvider.stpEspesorController,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.numeroFoliolos != null &&
                          plant.numeroFoliolos!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Nª Foliolos',
                      value: editable ? '' : plant.numeroFoliolos,
                      ctrl: plotsProvider.numeroFoliolosController,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.largoFoliolos != null &&
                          plant.largoFoliolos!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Largo Foliolos',
                      value: editable ? '' : plant.largoFoliolos,
                      ctrl: plotsProvider.largoFoliolosController,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.anchoFoliolos != null &&
                          plant.anchoFoliolos!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Ancho Foliolos',
                      value: editable ? '' : plant.anchoFoliolos,
                      ctrl: plotsProvider.anchoFoliolosController,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.longPeciolo != null &&
                          plant.longPeciolo!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Long Peciolo',
                      value: editable ? '' : plant.longPeciolo,
                      ctrl: plotsProvider.longPecioloController,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.longRaquiz != null &&
                          plant.longRaquiz!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Long Raquiz',
                      value: editable ? '' : plant.longRaquiz,
                      ctrl: plotsProvider.longRaquizController,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.alturaPlanta != null &&
                          plant.alturaPlanta!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Altura Planta',
                      value: editable ? '' : plant.alturaPlanta,
                      ctrl: plotsProvider.alturaPlantaController,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.longArqueo != null &&
                          plant.longArqueo!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Long Arqueo',
                      value: editable ? '' : plant.longArqueo,
                      ctrl: plotsProvider.longArqueoController,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.circunferencia != null &&
                          plant.circunferencia!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Circunferencia',
                      value: editable ? '' : plant.circunferencia,
                      ctrl: plotsProvider.circunferenciaController,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.deficiencaNatural != null &&
                          plant.deficiencaNatural!.isNotEmpty))
                    labelField(
                      context,
                      label: 'Deficiencia Nutricional',
                      value: editable ? '' : plant.deficiencaNatural,
                      ctrl: plotsProvider.deficienciaNaturalController,
                    ),
                  labelField(
                    context,
                    label: 'Observación',
                    value: editable ? '' : plant.observacion,
                    ctrl: plotsProvider.observacionController,
                  ),
                  const SizedBox(height: 15),
                  if (editable)
                    CustomButton(
                      label: 'GUARDAR',
                      onTap: () => save(context),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void save(BuildContext context) async {
    final plotsProvider = Provider.of<PlotsProvider>(context, listen: false);

    final plantToSave = plant.copyWith(
      dniEvaluador: plotsProvider.dniController.text,
      campania: plotsProvider.campaniaController.text,
      ensayo: plotsProvider.ensayoController.text,
      bloque: plotsProvider.bloqueController.text,
      tratamiento: plotsProvider.tratamientoController.text,
      hojasVerdes: plotsProvider.hojasVerdesController.text,
      stpAncho: plotsProvider.stpAnchoController.text,
      stpEspesor: plotsProvider.stpEspesorController.text,
      numeroFoliolos: plotsProvider.numeroFoliolosController.text,
      largoFoliolos: plotsProvider.largoFoliolosController.text,
      anchoFoliolos: plotsProvider.anchoFoliolosController.text,
      longPeciolo: plotsProvider.longPecioloController.text,
      longRaquiz: plotsProvider.longRaquizController.text,
      alturaPlanta: plotsProvider.alturaPlantaController.text,
      longArqueo: plotsProvider.longArqueoController.text,
      circunferencia: plotsProvider.circunferenciaController.text,
      deficiencaNatural: plotsProvider.deficienciaNaturalController.text,
      observacion: plotsProvider.observacionController.text,
      plotId: plot.id,
      plantId: plant.id,
    );

    await plotsProvider.loadPlotReports();
    final reports = plotsProvider.plantReports;
    bool reportSaved = false;
    for (final plotReport in reports) {
      if (plantToSave.id == plotReport.id) {
        plotReport.plants.add(plantToSave);
        reportSaved = true;
      }
    }
    if (!reportSaved) {
      reports.add(Plots(
        id: plot.id,
        name: plot.name,
        plants: [plantToSave],
      ));
    }

    plotsProvider.saveData(
      key: CacheKey.reports.toString(),
      data: jsonEncode(List<dynamic>.from(reports.map((x) => x.toJson()))),
    );
    plotsProvider.loadColorPlots(reports);
    Navigator.of(context).pop();
  }

  SizedBox labelField(
    BuildContext context, {
    required String label,
    String? value,
    bool disabled = false,
    TextEditingController? ctrl,
  }) {
    if (ctrl != null) {
      ctrl.text = value ?? '';
    }
    return SizedBox(
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
              style: const TextStyle(
                color: Color(0xFF6E6E6E),
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row headerLabel() {
    return Row(
      children: const [
        Text(
          'Estado:',
          style: TextStyle(
            color: Color(0xFF2BF9BB),
            fontSize: 15,
          ),
        ),
        Spacer(),
        Text(
          'Inspeccionado:',
          style: TextStyle(
            color: Color(0xFF2BF9BB),
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  BoxDecoration formStyle() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
        topLeft: Radius.circular(12),
        topRight: Radius.circular(72),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () => onBack(context),
        child: const Text(
          'Parcelas',
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
      backgroundColor: const Color(0xFFF5F4F4),
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
