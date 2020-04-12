
import 'package:flutter/material.dart';

import 'package:qrscanner/src/models/scan_model.dart';
//MAPAS
import 'package:flutter_map/flutter_map.dart';


class MapaPage extends StatefulWidget {


  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {


  final map = new MapController();
  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {


  final ScanModel scan = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon (Icons.my_location), 
            onPressed: () {
              map.move( scan.getLatLng(), 
              16.0);
            },
          )
        ], 
      ),
      body: _crearFlutterMap( scan ),
      floatingActionButton: _crearBotonFlotante( context ),
    );

}

  Widget _crearBotonFlotante( BuildContext context ) {

    return FloatingActionButton(
    child: Icon ( Icons.repeat ),
    backgroundColor: Theme.of(context).primaryColor,
    elevation: 6,
    autofocus: false,
    onPressed: () {
      //Ciclo entre cada ciclo de los temas para el diseño del mapa
      // streets, dark, light, , outdoors, satellite
      if ( tipoMapa == 'streets') {
        tipoMapa = 'dark';
      } else if ( tipoMapa == 'dark' ) {
        tipoMapa = 'light'; 
      } else if ( tipoMapa == 'light' ) {
        tipoMapa = 'outdoors';
      } else if ( tipoMapa == 'outdoors' ) {
        tipoMapa = 'satellite';
      } else {
        tipoMapa = 'streets';
      }

      //Para que el estatefull Widget conozca que se realizo un cambio y lo muestre
      setState(() {});

    },
    );
  }

    Widget _crearFlutterMap( ScanModel scan ) {

      return  FlutterMap(
        mapController: map,
        options: MapOptions(
          center: scan.getLatLng(),
          zoom: 13.0,

        ),
        //Capas de información que quiero poner
        //Primer layer Mapa
        layers: [
          _crearMapa(),  
          _crearMarcadores( scan ),
        ], 
      );

    }

  _crearMapa() {

     return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiYmhkZmdlbmVyYWwiLCJhIjoiY2s3MHM2NDN1MDBjMjNmcDVoY3dtazJ5YSJ9.ba972iqjRzCO_4Rt-TvFGg',
        'id': 'mapbox.$tipoMapa', //Tipos de diseños, streets, dark, light, outdoors, satellite
      }
    );

  }

  _crearMarcadores( ScanModel scan ) {

    return MarkerLayerOptions(
                //Para especificar de que tipo es la lista
      markers: <Marker> [
        Marker( 
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
                              // => Retornar el elemento como quiero que se muestre en pantalla fisicamente
          builder: ( context ) => Container(
            child: Icon( Icons.location_on,
            size: 60.0,
            color: Theme.of(context).primaryColor,
             ),
            )
        )
      ]
    );


  }
}
