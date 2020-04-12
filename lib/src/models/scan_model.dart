import 'package:latlong/latlong.dart';


class ScanModel {
    
    int id;
    String tipo;
    String valor;
    

    //°Constructor°
    ScanModel({
        this.id,
        this.tipo,
        this.valor,
    }){
      //Determinación automática
      //Donde la condición if es para determinar si http es 'web', else 'geo, cuando tenga que abrir un mapa o una página websa
         if ( this.valor.contains('http') ) {
        this.tipo = 'http';
      } else if ( this.valor.contains('geo') ){
        this.tipo = 'geo';
      } else if ( this.valor.contains('tel') ) {
        this.tipo = 'tel';
      } else  {
        this.tipo = 'mailto';
      }
    }

    

    //°Objeto°
    //Factory = Crea una instancia de nuestro ScanModel o cualquier objeto
    factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
        id    : json["id"],
        tipo  : json["tipo"],
        valor : json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id"    : id,
        "tipo"  : tipo,
        "valor" : valor,
    };

  //MÉTODO de Mapa_Despliegue para retornar la latitud y Longitud exactamente igual como la necesita mi mapa.
  LatLng getLatLng() {
                      //Ignore los 4 caracteres iniciales, y que inicie después de eso
                                    //.split(',') Transforma o corta el String en una lista, donde encuentre la (',')
    final lalo = valor.substring(4).split(',');

    final lat = double.parse( lalo[0] );
    final lng = double.parse( lalo[1] );

    return LatLng( lat, lng );


  }

}
