import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';

import 'package:qrscanner/src/bloc/scans_bloc.dart';
import 'package:qrscanner/src/models/scan_model.dart';
import 'package:qrscanner/src/pages/emails_page.dart';
import 'package:qrscanner/src/pages/telefonos_page.dart';
//Utilidades
import 'package:qrscanner/src/utils/utils.dart' as utils;
//Routes para el Switch
import 'mapas_page.dart';
import 'webs_page.dart';
//Borde de El FloatingActionButton


//---------------------------------------------------------------------------------------------------------------------------------//

 // Se tiene que utilizar un Stateless Widget, para poder hacer dinamicos los cambios de nuestro Switch
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();
  //Propiedad 
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          )
        ),
        centerTitle: true,
        title: Text('QRSCANNER BOOK',),
        actions: <Widget>[
          IconButton(
            icon: Icon (Icons.delete_forever), 
                                  //Se quita parentecis, por que no se llama la instrucción si no la referencia
            // onPressed: scansBloc.borrarScansTodos, 
          
            onPressed: () => showDialog(
              context: context,
              builder: ( context ) {
                return AlertDialog(
                  title: const Text('Eliminar Todo'),
                  content: const Text('Al aceptar se borraran todos los Qr Scans de la App'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: scansBloc.borrarScansTodos ,
                      child: const Text('Aceptar'),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cerrar'),
                    ),
                  ],
                );
              }
            ),
            
          ),

        ],
      ),


      //Aquí se implementan el metodo _callPage(), que es para las llamadas o direciones hacia que páginas iran los taps del BottomNavigationBar
      //Se asigna la propiedad currentIndex para que esta haga el cambio de página o de el valor de la página 
      body: _callPage(currentIndex),
      
      //Se crea un método _crearBottomNavigationBar
      bottomNavigationBar:_crearBottomNavigationBar(),

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //Floating Button centrado
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //Se puede implementar por método, pero al ser poco cócidog se hace desde el Scaffold
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.filter_center_focus ),
        //Theme editado en main.dart
        shape: _DiamondBorder(),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 10,
        //Metodo propio _scannQR sin parentesis, por que se quiere llamar inmeditamente 
        onPressed: ()=>_scannQR(context),
        ),  
    );

  }


    //para utilizar el Await tiene que asignarsele el (async) a un método o función 
    _scannQR(BuildContext context) async {
      /* FUNCIÓN DE PAQUETE: Abre la camara, lee el codigo QR y regresa un String */
      //Método usando el import de QR
      //https://www.google.com.mx/ URL Prueba
      // geo:19.43405607323416,-99.1303004308594 Prueba
      String futureString;
      //Esta información o paquete puede dar un error por lo cual se maneja con (try) y un (catch)
      //Se maneja a travez de un future por que es requerido por el BarcodeScanner.sacn();

      //Inicializador del SCAN 
      try {
        futureString = await BarcodeScanner.scan();
      }
      //(E) = exception o error
      //Tambíen se declara para el problema de al alir del Qr Scann sin escanear no de n
      catch ( error ) {
        futureString = error.toString();
        futureString = null;
      }


      //Condición
      //Aquí se manda a llamar al proceso de inserción
      if( futureString != null ) {
          
          final scan = ScanModel( valor: futureString );
          scansBloc.agregarScan( scan );
          
          //Prueba para Scan 2 Geolocalization
          // final scan2 = ScanModel( valor: 'geo:19.358158, -99.094537' );
          // scansBloc.agregarScan( scan2 );

        if ( Platform.isIOS ) {
          Future.delayed( Duration(milliseconds: 750), ( )  {
            utils.abrirScan(context, scan);
          } );
        } else {
          utils.abrirScan( context, scan );
        }
        utils.abrirScan( context, scan );
      }


    }



  Widget _callPage( int paginaActual ) {
    //Por si tuvieramos más paginas en el bar, se utiliza Swtich y se hace una condición
    switch( paginaActual ) {

      case 0: return MapasPage();
      break;
      case 1: return DireccionesPage();
      break;
      //Se salta al 3 por que hay un Icono oculto en el case 2
      case 3: return TelefonosPage();
      break;
      case 4: return EmailsPage();
      break;
      default: 
        return MapasPage(); 
    }

  }


  Widget _crearBottomNavigationBar() {

    return 
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
          child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
              child: BottomNavigationBar(
           
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.black,
            elevation: 10.0,
            //El 0 corresponde a la posición del tap, si hay dos Botones, seria 0 izquierda y cero a la derecha.
            //El cero regresa en posición index
            currentIndex: currentIndex,
            onTap: (int index) {
              setState(() {
                currentIndex = index;
              });
            },

            //Obligatario, tiene que ser más de uno
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.map, ),
                title: Text('Mapas'),
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.web),
                title: Text('Páginas Web'),
                ),
                BottomNavigationBarItem(
                icon: Icon(Icons.filter_none , color: Colors.transparent, size: 10.0,),
                title: Text(''),
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call, size: 27.0),
                title: Text('Telefonos'),
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.markunread_mailbox, size: 25.0),
                title: Text('E-mails'),
                )
            ],
            
          ),
       ),
    );

  }

}

  //Clase para el diseño del FloatingActionButton
class _DiamondBorder extends ShapeBorder {
  const _DiamondBorder();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top )
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width  / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}


