import 'package:flutter/material.dart';

class ErrorInternetWidget extends StatelessWidget {
  const ErrorInternetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 80 : 60,
      ),
      child: Column(
        children: [
          const SizedBox(height: 100),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Text(
              'No tiene conexion a internet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF828282),
                fontSize: 25,
              ),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.signal_wifi_connected_no_internet_4_rounded,
            size: 120,
            color: Colors.grey[400]!,
          ),
          const SizedBox(height: 60),
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
    );
  }
}
