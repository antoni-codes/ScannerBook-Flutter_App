import 'package:flutter/material.dart';


//Routes Pages
import 'src/pages/home_page.dart';
//Ruta MapaPage
import 'package:qrscanner/src/pages/mapa_despliegue_page.dart';
import 'package:qrscanner/src/pages/emails_page.dart';
import 'package:qrscanner/src/pages/telefonos_page.dart';

import 'package:flutter/services.dart';



void main() {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
  statusBarBrightness: Brightness.light
));

runApp(MyApp());
 

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QrScanner App',
      initialRoute: 'home',
      routes: {
        'home'       :     (BuildContext context)  =>     HomePage(),
        'mapa'       :     (BuildContext context)  =>     MapaPage(),
        'tels'       :     (BuildContext context)  =>     TelefonosPage(),
        'email'      :     (BuildContext context)  =>     EmailsPage(),


      },
      
      //Theme de diseños en la app - home_page.dart
      theme: ThemeData(
        primaryColor:  Colors.orangeAccent,
      ),

    );
  }
}

