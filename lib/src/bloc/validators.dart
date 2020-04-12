import 'dart:async';

import 'package:qrscanner/src/models/scan_model.dart';


//Clase que tiene las propiedades de la class Validator con sus propiedades usando Streams para filtra la información
//Se utiiza para ser llamada en el scans_bloc
class Validators {

  final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ) {
                        //Todo esto es un iterable por eso se pasa a un .toList
      final geoScans = scans.where((s) => s.tipo == 'geo').toList();
      sink.add(geoScans);
    }
  );


  final validarHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
     handleData: ( scans, sink ) {
                          //Todo esto es un iterable por eso se pasa a un .toList
      final httpScans = scans.where((s) => s.tipo == 'http').toList();
      sink.add(httpScans);
    }
  );

  final validarTels = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
     handleData: ( scans, sink ) {
                          //Todo esto es un iterable por eso se pasa a un .toList
      final telScans = scans.where((s) => s.tipo == 'tel').toList();
      sink.add(telScans);
    }
  );

   final validarEmails = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
     handleData: ( scans, sink ) {
                          //Todo esto es un iterable por eso se pasa a un .toList
      final mailtoScans = scans.where((s) => s.tipo == 'mailto').toList();
      sink.add(mailtoScans);
    }
  );
  
  

  






}