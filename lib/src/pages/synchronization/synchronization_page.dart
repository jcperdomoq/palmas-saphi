import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:las_palmas/src/providers/plots_provider.dart';
import 'package:las_palmas/src/widgets/error_internet_widget.dart';
import 'package:provider/provider.dart';

class SynchronizationPage extends StatefulWidget {
  const SynchronizationPage({Key? key}) : super(key: key);

  @override
  State<SynchronizationPage> createState() => _SynchronizationPageState();
}

class _SynchronizationPageState extends State<SynchronizationPage> {
  // Solo para fines ilustrativos
  bool showErrorConnextionWidget = false;
  String stateDownload = "OK";
  String stateSeendForm = "OK";

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
    final plotsProvider = Provider.of<PlotsProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        GestureDetector(
          onTap: showErrorConnectionNetwork,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Datos sincronizandose',
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
                        'Descarga de reportes',
                        const Color(0xFF828282),
                      ),
                      const Spacer(),
                      label(
                        stateDownload,
                        const Color(0xFF13D640),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      label(
                        'Actualización de BD aplicación',
                        const Color(0xFF828282),
                      ),
                      const Spacer(),
                      label(
                        stateSeendForm,
                        const Color(0xFF13D640),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    child: const Text('Sincronizar'),
                    onPressed: synchronization,
                  ),
                  ElevatedButton(
                    child: const Text('Descargar informacion'),
                    onPressed: () {
                      getPlots(plotsProvider);
                    },
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

  synchronization() {
    final plotsProvider = Provider.of<PlotsProvider>(context, listen: false);
    plotsProvider.clearReports();
    plotsProvider.loadColorPlots([]);
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

  getPlots(PlotsProvider plotsProvider) {
    setState(() {
      stateDownload = "EN PROCESO";
    });

    plotsProvider.loadPlotsFromServer().then((value) {
      if (value == HttpStatus.ok) {
        setState(() {
          stateDownload = "OK";
        });
        plotsProvider.loadColorPlots(plotsProvider.plantReports);
      } else {
        mensajeError();
      }
    });
    // plotsProvider.plotService.getPlots().then((value) {
    //   print(value);
    //   setState(() {
    //     stateDownload = "OK";
    //   });
    // }).catchError((onError) {
    //   mensajeError();
    // });
  }

  mensajeError() async {
    setState(() {
      showErrorConnextionWidget = true;
      stateDownload = "Error";
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() => showErrorConnextionWidget = false);
  }
}
