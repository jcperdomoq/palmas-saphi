import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:las_palmas/models/api/plots.dart';
import 'package:las_palmas/models/cache/cache_key.dart';
import 'package:las_palmas/models/form/bloque.dart';
import 'package:las_palmas/models/form/deficiencia_nutricional.dart';
import 'package:las_palmas/models/form/ensayo.dart';
import 'package:las_palmas/models/form/tratamiento.dart';
import 'package:las_palmas/src/pages/plants/widgets/label_field.dart';
import 'package:las_palmas/src/providers/plants_provider.dart';
import 'package:las_palmas/src/providers/plots_provider.dart';
import 'package:las_palmas/src/widgets/custom_buttom.dart';
import 'package:las_palmas/util/dialogs.dart';
import 'package:provider/provider.dart';

class PlantPage extends StatelessWidget {
  final bool editable;
  final Plant plant;
  final Plots plot;
  final Color statusColor;
  const PlantPage({
    Key? key,
    required this.plot,
    required this.plant,
    required this.statusColor,
    this.editable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final plotsProvider = Provider.of<PlotsProvider>(context, listen: false);

    final isID = plantsProvider.containsForName('I+D');
    final isBiometrica = plantsProvider.containsForName('Biometría');
    plotsProvider.campaniaController.text = plant.campania!;
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
                  const SizedBox(height: 10),
                  headerLabel(),
                  const SizedBox(height: 18),
                  const Divider(
                    color: Color(0xFFD4D4D4),
                    height: 0,
                  ),
                  const SizedBox(height: 2),
                  LabelField(
                    label: 'DNI Evaluador',
                    value: editable
                        ? plotsProvider.dniController.text
                        : plant.dniEvaluador,
                    ctrl: plotsProvider.dniController,
                    disabled: !editable,
                  ),
                  LabelField(
                    label: 'Parcela',
                    value: plant.parcela,
                    disabled: true,
                  ),
                  LabelField(
                    label: 'Plantación',
                    value: plant.plantacion,
                    disabled: true,
                    // ctrl: plotsProvider.dniController,
                  ),
                  LabelField(
                    label: 'Campaña',
                    value: editable
                        ? plotsProvider.campaniaController.text
                        : plant.campania,
                    ctrl: plotsProvider.campaniaController,
                    disabled: true,
                  ),
                  if (isID ||
                      (!editable &&
                          plant.ensayo != null &&
                          plant.ensayo!.isNotEmpty))
                    LabelField(
                      label: 'Ensayo',
                      value: plant.ensayo,
                      disabled: !editable,
                      onTap: () async {
                        String plantacion = plant.plantacion ?? '';
                        final items = await Dialogs.showMultiSelect(
                          context,
                          multiSelect: false,
                          title: 'Ensayo',
                          items: plantacion == 'Shanusi'
                              ? Ensayo.shanusiItems
                              : Ensayo.plantawasiItems,
                          initialSelectedValues: [plotsProvider.ensayo],
                        );
                        plotsProvider.ensayo =
                            items == null ? '' : items.join('');
                        plant.ensayo = plotsProvider.ensayo;
                      },
                    ),
                  if (isID ||
                      (!editable &&
                          plant.bloque != null &&
                          plant.bloque!.isNotEmpty))
                    LabelField(
                      label: 'Bloque',
                      value: plant.bloque,
                      disabled: !editable,
                      onTap: () async {
                        if (plant.ensayo == null || plant.ensayo!.isEmpty) {
                          Dialogs.nativeDialog(
                            context: context,
                            body: 'Debe seleccionar un ensayo',
                          );
                          return;
                        }
                        String ensayo = plotsProvider.ensayo;
                        final dataDialog = ensayo == 'ASD' ||
                                ensayo == 'Tres densidades y cuatro materiales'
                            ? Bloque.case1
                            : ensayo == 'Densidades' ||
                                    ensayo == 'El dorado' ||
                                    ensayo == 'Híbrido E04a'
                                ? Bloque.case2
                                : ensayo == 'Dosis dolomita' ||
                                        ensayo == 'Elite vs Millenium'
                                    ? Bloque.case3
                                    : Bloque.case4;
                        final items = await Dialogs.showMultiSelect(
                          context,
                          multiSelect: false,
                          title: 'Bloque',
                          items: dataDialog,
                        );
                        plotsProvider.bloque =
                            items == null ? '' : items.join('');
                        plant.bloque = plotsProvider.bloque;
                      },
                    ),
                  if (isID ||
                      (!editable &&
                          plant.tratamiento != null &&
                          plant.tratamiento!.isNotEmpty))
                    LabelField(
                      label: 'Tratamiento',
                      value: plant.tratamiento,
                      disabled: !editable,
                      onTap: () async {
                        if (plant.ensayo == null || plant.ensayo!.isEmpty) {
                          Dialogs.nativeDialog(
                            context: context,
                            body: 'Debe seleccionar un ensayo',
                          );
                          return;
                        }
                        if (plant.bloque == null || plant.bloque!.isEmpty) {
                          Dialogs.nativeDialog(
                            context: context,
                            body: 'Debe seleccionar un bloque',
                          );
                          return;
                        }
                        String ensayo = plotsProvider.ensayo;
                        final items = await Dialogs.showMultiSelect(context,
                            multiSelect: false,
                            title: 'Símbolo tratamiento',
                            items: ensayo == 'ASD'
                                ? Tratamiento.case1
                                : ensayo == 'Densidades'
                                    ? Tratamiento.case2
                                    : ensayo == 'El dorado'
                                        ? Tratamiento.case3
                                        : ensayo == 'Híbrido E04a'
                                            ? Tratamiento.case4
                                            : ensayo == 'Dosis dolomita'
                                                ? Tratamiento.case5
                                                : ensayo == 'Elite vs Millenium'
                                                    ? Tratamiento.case6
                                                    : ensayo == 'Híbrido OxG'
                                                        ? Tratamiento.case7
                                                        : Tratamiento.case8);
                        plotsProvider.tratamiento =
                            items == null ? '' : items.join('');
                        plant.tratamiento = plotsProvider.tratamiento;
                      },
                    ),
                  LabelField(
                    label: 'Linea',
                    value: editable
                        ? plotsProvider.lineaController.text
                        : plant.linea,
                    ctrl: plotsProvider.lineaController,
                    disabled: !editable,
                  ),
                  LabelField(
                    label: 'Planta',
                    value: editable
                        ? plotsProvider.plantaController.text
                        : plant.planta,
                    ctrl: plotsProvider.plantaController,
                    disabled: !editable,
                  ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.hojasVerdes != null &&
                          plant.hojasVerdes!.isNotEmpty))
                    LabelField(
                      label: 'Nª Verdes (und)',
                      value: editable
                          ? plotsProvider.hojasVerdesController.text
                          : plant.hojasVerdes,
                      ctrl: plotsProvider.hojasVerdesController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      disabled: !editable,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.stpAncho != null &&
                          plant.stpAncho!.isNotEmpty))
                    LabelField(
                      label: 'STP Ancho (cm)',
                      value: editable
                          ? plotsProvider.stpAnchoController.text
                          : plant.stpAncho,
                      ctrl: plotsProvider.stpAnchoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      disabled: !editable,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.stpEspesor != null &&
                          plant.stpEspesor!.isNotEmpty))
                    LabelField(
                      label: 'STP Espesor (cm)',
                      value: editable
                          ? plotsProvider.stpEspesorController.text
                          : plant.stpEspesor,
                      ctrl: plotsProvider.stpEspesorController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      disabled: !editable,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.numeroFoliolos != null &&
                          plant.numeroFoliolos!.isNotEmpty))
                    LabelField(
                      label: 'Nª Foliolos (und)',
                      value: editable
                          ? plotsProvider.numeroFoliolosController.text
                          : plant.numeroFoliolos,
                      ctrl: plotsProvider.numeroFoliolosController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      disabled: !editable,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.largoFoliolos != null &&
                          plant.largoFoliolos!.isNotEmpty))
                    LabelField(
                      label: 'Largo Foliolos (cm)',
                      value: editable
                          ? plotsProvider.largoFoliolosController.text
                          : plant.largoFoliolos,
                      ctrl: plotsProvider.largoFoliolosController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      disabled: !editable,
                    ),
                  if (isBiometrica ||
                      (!editable &&
                          plant.anchoFoliolos != null &&
                          plant.anchoFoliolos!.isNotEmpty))
                    LabelField(
                      label: 'Ancho Foliolos (cm)',
                      value: editable
                          ? plotsProvider.anchoFoliolosController.text
                          : plant.anchoFoliolos,
                      ctrl: plotsProvider.anchoFoliolosController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      disabled: !editable,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.longPeciolo != null &&
                          plant.longPeciolo!.isNotEmpty))
                    LabelField(
                      label: 'Long Peciolo (m)',
                      value: editable
                          ? plotsProvider.longPecioloController.text
                          : plant.longPeciolo,
                      ctrl: plotsProvider.longPecioloController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      disabled: !editable,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.longRaquiz != null &&
                          plant.longRaquiz!.isNotEmpty))
                    LabelField(
                      label: 'Long Raquiz (m)',
                      value: editable
                          ? plotsProvider.longRaquizController.text
                          : plant.longRaquiz,
                      ctrl: plotsProvider.longRaquizController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      disabled: !editable,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.alturaPlanta != null &&
                          plant.alturaPlanta!.isNotEmpty))
                    LabelField(
                      label: 'Altura Planta (cm)',
                      value: editable
                          ? plotsProvider.alturaPlantaController.text
                          : plant.alturaPlanta,
                      ctrl: plotsProvider.alturaPlantaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      disabled: !editable,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.longArqueo != null &&
                          plant.longArqueo!.isNotEmpty))
                    LabelField(
                      label: 'Long Arqueo (cm)',
                      value: editable
                          ? plotsProvider.longArqueoController.text
                          : plant.longArqueo,
                      ctrl: plotsProvider.longArqueoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      disabled: !editable,
                    ),
                  if (isBiometrica && isID ||
                      (!editable &&
                          plant.circunferencia != null &&
                          plant.circunferencia!.isNotEmpty))
                    LabelField(
                      label: 'Circunferencia (cm)',
                      value: editable
                          ? plotsProvider.circunferenciaController.text
                          : plant.circunferencia,
                      ctrl: plotsProvider.circunferenciaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      disabled: !editable,
                    ),
                  if ((editable) ||
                      (!editable &&
                          plant.deficienciaNutricional != null &&
                          plant.deficienciaNutricional!.isNotEmpty))
                    LabelField(
                      label: 'Deficiencia Nutricional',
                      value: plant.deficienciaNutricional != null
                          ? plant.deficienciaNutricional!.join(', ')
                          : '',
                      disabled: !editable,
                      onTap: () async {
                        final items = await Dialogs.showMultiSelect(
                          context,
                          multiSelect: true,
                          title: 'Deficiencia Nutricional',
                          items: DeficienciaNutricional.values,
                          initialSelectedValues:
                              plotsProvider.deficienciaNutricional,
                        );
                        plotsProvider.deficienciaNutricional = items ?? [];
                        plant.deficienciaNutricional =
                            plotsProvider.deficienciaNutricional;
                      },
                    ),
                  LabelField(
                    label: 'Observación',
                    value: editable
                        ? plotsProvider.observacionController.text
                        : plant.observacion,
                    ctrl: plotsProvider.observacionController,
                    disabled: !editable,
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
      ensayo: plotsProvider.ensayo,
      bloque: plotsProvider.bloque,
      tratamiento: plotsProvider.tratamiento,
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
      deficienciaNutricional: plotsProvider.deficienciaNutricional,
      observacion: plotsProvider.observacionController.text,
      planta: plotsProvider.plantaController.text,
      linea: plotsProvider.lineaController.text,
    );
    await plotsProvider.loadPlotReports();
    final reports = plotsProvider.plantReports;
    bool reportSaved = false;
    for (final plotReport in reports) {
      if ('${plantToSave.parcela} (Campaña ${plantToSave.campania})' ==
          '${plotReport.plants[0].parcela} (Campaña ${plotReport.plants[0].campania})') {
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
    plotsProvider.resetFields();
    Navigator.of(context).pop();
  }

  Row headerLabel() {
    return Row(
      children: [
        Text(
          'Estado:',
          style: TextStyle(
            color: statusColor,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        Text(
          statusColor == const Color(0xFF00C347)
              ? 'Inspeccionado'
              : 'No inspeccionado',
          style: TextStyle(
            color: statusColor,
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
