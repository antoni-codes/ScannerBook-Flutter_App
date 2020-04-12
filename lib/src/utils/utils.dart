import 'package:flutter/material.dart';
import 'package:qrscanner/src/providers/db_provider.dart';
import 'package:url_launcher/url_launcher.dart';

//Aquí se manda a llamar la navegación de los Scaners, a sus respectivas salidas
//Para poder utilizar las diferentes caracteristicas de cada tipo
//Mandar correo, llamada, maps, Navegador


abrirScan(BuildContext context, ScanModel scan ) async { 
  
    if ( scan.tipo == 'http' ) {

      if (await canLaunch( scan.valor )) {
         await launch(scan.valor);
      } else {
          throw 'Could not launch ${ scan.valor }';
      }

    //Se realizar la condición y se declara la función que realizara si se cumple el else if
    } else if ( scan.tipo == 'geo' ){ 

       Navigator.pushNamed(context, 'mapa', arguments: scan);

    } else if ( scan.tipo == 'tel' ){ 
        if (await canLaunch( scan.valor )) {
          await launch(scan.valor);
    }   else {
          throw 'Could not launch ${ scan.valor }';
    }
    
    } else  if ( scan.tipo == 'mailto' ){  
        if (await canLaunch( scan.valor )) {
          await launch(scan.valor);
    }   else {
           throw 'Could not launch ${ scan.valor }';
    }
    }   
 
  }
  
  
