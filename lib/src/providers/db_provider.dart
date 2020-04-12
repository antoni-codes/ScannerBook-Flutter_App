import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrscanner/src/models/scan_model.dart';
export 'package:qrscanner/src/models/scan_model.dart';



class DBProvider {

  static Database _database; 
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }


  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'ScansDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    );

  }

  // CREAR Registros
  nuevoScanRaw( ScanModel nuevoScan ) async {

    final db  = await database;

    final res = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valor) "
      "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' )"
    );
    return res;

  }

  nuevoScan( ScanModel nuevoScan ) async {

    final db  = await database;
    final res = await db.insert('Scans',  nuevoScan.toJson() );
    return res;
  }


  // SELECT - Obtener información
  Future<ScanModel> getScanId( int id ) async {

    final db  = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]  );
    return res.isNotEmpty ? ScanModel.fromJson( res.first ) : null;

  }

  Future<List<ScanModel>> getTodosScans() async {

    final db  = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                              ? res.map( (c) => ScanModel.fromJson(c) ).toList()
                              : [];
    return list;
  }

  Future<List<ScanModel>> getScansPorTipo( String tipo ) async {

    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    List<ScanModel> list = res.isNotEmpty 
                              ? res.map( (c) => ScanModel.fromJson(c) ).toList()
                              : [];
    return list;
  }

  // Actualizar Registros
  Future<int> updateScan( ScanModel nuevoScan ) async {

    final db  = await database;
    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id] );
    return res;

  }

  // Eliminar registros
  Future<int> deleteScan( int id ) async {

    final db  = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {

    final db  = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }

}






/*

 //Import de DBProvider
import 'package:sqflite/sqflite.dart';
//Import de Directory
import 'dart:io';
//Import de provider (getApplicationDocumentsDirectory())
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';

//Instancia de la clase ScanModel (scan_model.dart)
import '../models/scan_model.dart';
export '../models/scan_model.dart';

class DBProvider {

  //Método Para Database
  static Database _database;
  //Método Para 
  //Se pone en final para que no se cambie Accidentalmente
  //(DBProvider) instancia de mi clase
  //°Constructor° privado (_private) o (_())
  static final DBProvider db = DBProvider._();


  DBProvider._();

  //Adicionalmente se puede especificar el tipo de dato Future que retorna un objeto de tipo <Database>
  Future<Database>  get database async {
    /*If necesito verificar si database es Diferente que null, si es diferente quiere decir que existe información adentro
    por consecuente yo retorno esa información _database */
    if ( _database != null ) return _database;
    /* Caso contrario, que no existe información dentro del _database o es nulla _database, por lo cual
    se crea una nueva instancia*/
    //°método° initDB();
    _database = await initDB();
    return _database;
  }

  initDB() async {
    //°Propiedad o variable°
    Directory documentsDirectory = await getApplicationSupportDirectory(); 

    //FUNCIÓN: path completo donde se encuentra la DB, incluyendo el nombre del archivo
    // Permite Unir el documentsDirectory.path que es la dirección donde se encuentre mi aplicación
    /* documentDirectory.path - se va a unir con el nombre del archivo de la DB ( Scans.db ) NOTA: .db es una extención 
    que utiliza el SQFlite*/
    final path = join( documentsDirectory.path, 'ScansDB.db' );


    //Inicialización de la Base Datos
    //Se regresa un objeto de tipo <DataBase> 
    //( openDatabASE ) es ya instrucciones del SQFlite 
    return await openDatabase(
      path,
      version: 1,
      //(db) instancia de la Base de Datos
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute( 
          //Declaracion en BASE DE DATOS SQ de la TABLE
          'CREATE TABLE Scans ('
           ' id INTEGER PRIMARY KEY,'
           ' tipo TEXT,'
           ' Valor TEXT'
          ')'
       );
      }
    );
  
  }


//CREATE Table y DataBase - inserciones
  //Opción 1, Método CREAR REGISTROS de DB
  //FUNCIÓN: Crear registros en la tabla llamada (Scans) 
  //Existen dos maneras de hacer inserciones
  nuevoScanRaw( ScanModel nuevoScan ) async {

  //Función: Verifica que la db este lista para escribir en ella
  //Función con el await: no se hace nada hasta que la DB este lista para ser usada
  final db  = await database;
  //Proceso de inserción, res( resultado ), se va a hacer uno o la cantidad de inserciones
  final res = await db.rawInsert(
    // SQL a definir 
                      //Que campos quiero grabar de información 
    "INSERT Into Scans (id, tipo, valor) "
    // En los VALUES se define cada una de las columnas o de los valores que van a ir en los campos id, tipo, valor
            //Se hace interpolación del String
    /*NOTA: Se tiene que llevar comillas dobles en el SQL, en Values, lleva comillas simples, ya que tenemos ue llamarlos como
    si fueran Strings, exceptuando el ( id ) ya que es númerico, kis demás como tipo y valor si llevan apóstrofes,*/
    "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' )"
  );
  return res;

  }



//Opción 2, Método CREAR REGISTROS de db - Esta es la que utilizaremos.
  nuevoScan( ScanModel nuevoScan ) async {

    final db  = await database;
    final res = await db.insert('Scans', nuevoScan.toJson() );
    return res;   

  }



  //SELECCIONES O GETTER: SELECT - Obtener Registros
  Future<ScanModel> getScanId( int id ) async {

    final db  = await database;
                                        // Where: de tipo Strong. ( ? ) Este signo significa que tiene que ser un argumento
                         //Query creado               
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]  );
    return res.isNotEmpty ? ScanModel.fromJson( res.first ) : null;
  
  }


  //GET para obtener todos los SCANS
  Future<List<ScanModel>> getTodosScans() async {

    final db  = await  database;
    final res = await db.query('Scans');

    //Variable Creada ScanModel de tipo Lista
    List<ScanModel> list = res.isNotEmpty 
                              ? res.map( (c) => ScanModel.fromJson(c) ).toList()
                              //caso contrario
                              : [];
    return list;

  }


  //GET de todos los Scans que cumplan la condición del tipo de archivo o dato que son, HTTP, Geolocation, etc.
                                      //Tenemos que recibir String tipo
  Future<List<ScanModel>> getScansPorTipo( String tipo ) async {

    final db  = await  database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");
    //Variable Creada ScanModel de tipo Lista
    List<ScanModel> list = res.isNotEmpty 
                              ? res.map( (c) => ScanModel.fromJson(c) ).toList()
                              //caso contrario
                              : [];
    return list;

  }


  //Actualizar Registros
   Future<int> updateScan( ScanModel nuevoScan ) async {

    final db  = await database;
    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id] );
    return res;

  }


  //Eliminaciones de Registros
   Future<int> deleteScan( int id ) async {

    final db  = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }
  

  //Eliminar TODOS los registros
   Future<int> deleteAll() async {

    final db  = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }

}

*/