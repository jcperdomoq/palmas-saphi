import 'package:flutter/material.dart';
import 'package:las_palmas/src/widgets/custom_buttom.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  double value = 1500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Configuración Rango GPS',
                style: TextStyle(
                  color: Color(0xFF828282),
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewPadding.bottom > 0 ? 80 : 60,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: buildSlider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          buildRangeLabel('0m'),
                          const Spacer(),
                          buildRangeLabel('2000m'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: CustomButton(
                        label: 'Guardar', onTap: null, // TODO: Unimplemented
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Datos Sincronizados el 12 de Octubre del 2020 a las 15:20',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF828282),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text buildRangeLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF828282),
        fontSize: 16,
      ),
    );
  }

  SliderTheme buildSlider() {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 2,
        activeTickMarkColor: Colors.purple,
        overlayColor: Color(0x00fed530),
        valueIndicatorColor: Colors.transparent,
        valueIndicatorTextStyle: TextStyle(
          color: Color(0xFF828282),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: 0,
        max: 2000,
        divisions: 100,
        label: '${value.round()}m',
        thumbColor: const Color(0xFF838383),
        activeColor: const Color(0xFF838383),
        inactiveColor: const Color(0xFF838383),
      ),
    );
  }

  void onChanged(double newValue) {
    setState(() {
      value = newValue;
    });
  }
}
