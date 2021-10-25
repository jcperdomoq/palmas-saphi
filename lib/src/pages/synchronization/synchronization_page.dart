import 'dart:async';

import 'package:flutter/material.dart';
import 'package:las_palmas/src/widgets/error_internet_widget.dart';

class SynchronizationPage extends StatefulWidget {
  const SynchronizationPage({Key? key}) : super(key: key);

  @override
  State<SynchronizationPage> createState() => _SynchronizationPageState();
}

class _SynchronizationPageState extends State<SynchronizationPage> {
  // Solo para fines ilustrativos
  bool showErrorConnextionWidget = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !showErrorConnextionWidget
            ? synchronizationForm(context)
            : const ErrorInternetWidget(),
      ),
    );
  }

  showErrorConnectionNetwork() {
    setState(() {
      showErrorConnextionWidget = true;
    });
    Timer(
      const Duration(seconds: 3),
      () {
        setState(() {
          showErrorConnextionWidget = false;
        });
      },
    );
  }

  Column synchronizationForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        GestureDetector(
          onTap: showErrorConnectionNetwork,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Datos sincronizandose .............',
              style: TextStyle(
                color: Color(0xFF828282),
                fontSize: 25,
              ),
            ),
          ),
        ),
        const SizedBox(height: 60),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 80 : 60,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      label(
                        'Descarga de reportes......',
                        const Color(0xFF828282),
                      ),
                      const Spacer(),
                      label(
                        '(EN PROCESO)',
                        const Color(0xFFFFC629),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      label(
                        'Actualización de BD aplicación .....',
                        const Color(0xFF828282),
                      ),
                      const Spacer(),
                      label(
                        '(OK)',
                        const Color(0xFF13D640),
                      ),
                    ],
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
        ),
      ],
    );
  }

  Text label(String label, Color color) {
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 15,
      ),
    );
  }
}
