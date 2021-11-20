import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:las_palmas/src/providers/plots_provider.dart';
import 'package:las_palmas/src/widgets/error_internet_widget.dart';
import 'package:las_palmas/util/months.dart';
import 'package:provider/provider.dart';

class SynchronizationPage extends StatefulWidget {
  const SynchronizationPage({Key? key}) : super(key: key);

  @override
  State<SynchronizationPage> createState() => _SynchronizationPageState();
}

class _SynchronizationPageState extends State<SynchronizationPage> {
  // Solo para fines ilustrativos
  bool showErrorConnextionWidget = false;
  String stateDownload = "(OK)";
  String stateSeendForm = "(OK)";

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
    final syncDate = plotsProvider.syncDateTime;
    final downloadDate = plotsProvider.downloadDateTime;
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
                        'Subida de formularios',
                        const Color(0xFF828282),
                      ),
                      const Spacer(),
                      label(
                        stateSeendForm,
                        stateSeendForm == '(OK)'
                            ? const Color(0xFF13D640)
                            : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('Subir formularios'),
                      onPressed: synchronization,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF00C347),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Datos Sincronizados el ${syncDate.day} de ${months[syncDate.month - 1]} del ${syncDate.year} a las ${syncDate.hour < 10 ? '0' : ''}${syncDate.hour}:${syncDate.minute < 10 ? '0' : ''}${syncDate.minute}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Row(
                    children: [
                      label(
                        'Actualización de BD aplicación',
                        const Color(0xFF828282),
                      ),
                      const Spacer(),
                      label(
                        stateDownload,
                        stateDownload == '(OK)'
                            ? const Color(0xFF13D640)
                            : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('Actualizar BD Aplicación'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF00C347),
                        ),
                      ),
                      onPressed: () {
                        getPlots(plotsProvider);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Datos Sincronizados el ${downloadDate.day} de ${months[downloadDate.month - 1]} del ${downloadDate.year} a las ${downloadDate.hour < 10 ? '0' : ''}${downloadDate.hour}:${downloadDate.minute < 10 ? '0' : ''}${downloadDate.minute}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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

  synchronization() async {
    setState(() {
      stateSeendForm = '(EN PROCESO)';
    });
    final plotsProvider = Provider.of<PlotsProvider>(context, listen: false);

    final status = await plotsProvider.saveReports(plotsProvider.plantReports);
    if (status == HttpStatus.ok) {
      plotsProvider.clearReports();
      plotsProvider.loadColorPlots([]);
    }
    setState(() {
      stateSeendForm = status == HttpStatus.ok ? '(OK)' : '(Error)';
      showErrorConnextionWidget = status == HttpStatus.serviceUnavailable;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() => showErrorConnextionWidget = false);
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

  getPlots(PlotsProvider plotsProvider) async {
    setState(() {
      stateDownload = "(EN PROCESO)";
    });

    final status = await plotsProvider.loadPlantacionFromServer();
    // final status = await plotsProvider.loadPlotsFromServer();
    if (status == HttpStatus.ok) {
      setState(() {
        stateDownload = "(OK)";
      });
    } else {
      mensajeError(status);
    }

    // plotsProvider.loadPlotsFromServer().then((value) {
    //   if (value == HttpStatus.ok) {
    //     setState(() {
    //       stateDownload = "(OK)";
    //     });
    //     plotsProvider.loadColorPlots(plotsProvider.plantReports);
    //   } else {
    //     mensajeError();
    //   }
    // });
  }

  mensajeError(int status) async {
    setState(() {
      showErrorConnextionWidget = status == HttpStatus.serviceUnavailable;
      stateDownload = "(Error)";
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() => showErrorConnextionWidget = false);
  }
}
