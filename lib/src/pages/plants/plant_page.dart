import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:las_palmas/models/plot/plot.dart';
import 'package:las_palmas/src/providers/plants_provider.dart';
import 'package:las_palmas/src/widgets/custom_buttom.dart';
import 'package:provider/provider.dart';

class PlantPage extends StatelessWidget {
  final bool editable;
  final Plot plant;
  const PlantPage({
    Key? key,
    required this.plant,
    this.editable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final firstValidation = plantsProvider.containsForName('I+D') ||
        plantsProvider.containsForName('Suelo') ||
        plantsProvider.containsForName('Biometría');
    final secondValidation = plantsProvider.containsForName('I+D') ||
        plantsProvider.containsForName('Biometría');
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
                    plant.label.replaceFirst('Planta', '').trim(),
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
                  labelField(label: 'DNI Evaluador', value: '73177293'),
                  labelField(label: 'Parcela', value: 'BCARD'),
                  labelField(label: 'Campaña', value: '20'),
                  labelField(label: 'Linea', value: '1'),
                  labelField(label: 'Planta', value: '145'),
                  if (firstValidation)
                    labelField(label: 'Nª Verdes', value: 'Nª Verdes'),
                  if (firstValidation)
                    labelField(label: 'STP Ancho', value: 'STP Ancho'),
                  if (firstValidation)
                    labelField(label: 'STP Espesor', value: 'STP Espesor'),
                  if (firstValidation)
                    labelField(label: 'Nª Foliolos', value: 'Nª Fololios'),
                  if (firstValidation)
                    labelField(
                        label: 'Largo Foliolos', value: 'Largo Foliolos'),
                  if (firstValidation)
                    labelField(
                        label: 'Ancho Foliolos', value: 'Ancho Foliolos'),
                  if (secondValidation)
                    labelField(label: 'Long Peciolo', value: 'Long Peciolo'),
                  if (secondValidation)
                    labelField(label: 'Long Raquiz', value: 'Long Raquiz'),
                  if (secondValidation)
                    labelField(label: 'Altura Planta', value: 'Altura Planta'),
                  if (secondValidation)
                    labelField(label: 'Long Arqueo', value: 'Long Arqueo'),
                  if (secondValidation)
                    labelField(
                        label: 'Circunferencia', value: 'Circunferencia'),
                  if (firstValidation)
                    labelField(
                        label: 'Deficiencia Nutricional',
                        value: 'Deficiencia Nutricional'),
                  labelField(label: 'Observación', value: 'Observación'),
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

  void save(BuildContext context) {
    Navigator.of(context).pop();
  }

  SizedBox labelField({required String label, required String value}) {
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
              controller: TextEditingController(text: value),
              enabled: editable,
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
