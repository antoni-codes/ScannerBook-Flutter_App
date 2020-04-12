import 'package:flutter/material.dart';

import 'package:qrscanner/src/bloc/scans_bloc.dart';
import 'package:qrscanner/src/models/scan_model.dart';

import 'package:qrscanner/src/utils/utils.dart' as utils;

//DB Provider




class TelefonosPage extends StatelessWidget {

  final scansBloc = new ScansBloc();


  @override
  Widget build(BuildContext context) {

    //para retornar información de otras pages o del icono direcciones  mapa
    //
    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamTel,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {

        if ( !snapshot.hasData ){
          return Center( child: CircularProgressIndicator() );
        }

        final scans = snapshot.data;

        if ( scans.length == 0 ) {
          return Center (
            child: Text('Registra Códigos QR'),
          );
        } 

        return ListView.builder(
          //ItemCount: Cantidad de registros que se tengan 
        itemCount: scans.length,
        //Dismissible, para agregar el efecto de deslizar
        itemBuilder: ( context, i ) => Dismissible(
          crossAxisEndOffset: 1.0,
          key: UniqueKey(),
          //Se controla la opció
          confirmDismiss: ( DismissDirection direction ) async {
            final bool res = await showDialog(
              context: context,
              builder: ( BuildContext context ) {
                return AlertDialog( 
                  title: const Text('Confirmar'),
                  content: const Text('¿Estás seguro de borrar este Scan?'),
                  actions: <Widget>[ 
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(true), 
                      child: const Text('Borrar')
                      ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false), 
                      child: const Text('Cancelar')
                      ),
                  ],
                );
              },
            );
           return res; 
          },
          //Contenedor de barra para dezplazar y borrar 
          secondaryBackground:  Container ( 
            child: Icon( Icons.delete_sweep, size: 35.0),
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal:35.0),
            alignment: Alignment.centerRight,
            ),
          background: Container(
            child: Icon( Icons.delete_sweep, size: 35.0), 
            color: Colors.red, 
            padding: EdgeInsets.symmetric( horizontal: 35.0 ),
            alignment: Alignment.centerLeft,
            ),
          onDismissed: (direction) => scansBloc.borrarScan(scans[i].id),
          child: ListTile(
            leading: Icon (Icons.call_end, color: Theme.of(context).primaryColor),
            title: Text( scans[i].valor ),
            // subtitle: Text('ID: ${ scans[i].id }') ,
            trailing: Icon( Icons.keyboard_arrow_right, color: Colors.grey),
                  //Hay que ejecutar instrucción por que se mandan argumentos 
                                          //se hace referencia al scans en us posición [i]
            onTap: () => utils.abrirScan( context, scans[i] ) ,
          )
        )      
        );
    
      },
    );
  }
}