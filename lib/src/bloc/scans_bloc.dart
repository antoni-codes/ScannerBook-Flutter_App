//Importa para el StreamController
import 'dart:async';

//Import para que tipo de información fluye atraves de el StreamController
//Es el import del ScanModel y del DB provider, para su uso 
import 'package:qrscanner/src/providers/db_provider.dart';
//La clase llamada con sus propiedades de Streams para usar los mixis en esta página 
import 'package:qrscanner/src/bloc/validators.dart';
 
//DOCUMENTO DE STREAM
//Similar al Streaminfinity Scroll de la app Peliculas.
//Aquí se van a manejar todos los Scans

class ScansBloc with Validators {

   static final ScansBloc _singleton = new ScansBloc._internal();

    factory ScansBloc() {
      return _singleton;
    }

    ScansBloc._internal() {
      //Obtener Scans de la Base de Datos
      obtenerScans();
      
    }

                                          //broadcast: FUNCIÓN: Varios lugares van a estar recibiendo este.
                                          //<List<ScanModel>> para que tipo de información fluye atraves de el StreamController
  final _scansController = StreamController<List<ScanModel>>.broadcast();

    Stream<List<ScanModel>> get scansStreamGeo     => _scansController.stream.transform( validarGeo );
    Stream<List<ScanModel>> get scansStreamHttp    => _scansController.stream.transform( validarHttp);
    Stream<List<ScanModel>> get scansStreamTel     => _scansController.stream.transform( validarTels);
    Stream<List<ScanModel>> get scansStreamEmail   => _scansController.stream.transform( validarEmails);

  dispose() {
    //Para cerrar el Stream Builder, ya que es lo que es requerido por este
    // Se pone la validación (?) para que si es el _scansController, no tuviera un objeto, entonces ? fallaría (.close)
    _scansController?.close();
    
  }
  
  //Métodos para Insertar, borrar, y borrar todos, los Scans. 
  
  //Este se ejecuta cuando se ejecute el constructor la primera vez
  obtenerScans()  async {
    _scansController.sink.add( await DBProvider.db.getTodosScans() );
  }

  //Método de agregar Scan y que se actualice
  agregarScan( ScanModel scan ) async {
    await DBProvider.db.nuevoScan( scan );
    obtenerScans();
  }


  borrarScan( int id ) async {
    await DBProvider.db.deleteScan( id ); 
    obtenerScans();
  } 


  borrarScansTodos() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }



}


