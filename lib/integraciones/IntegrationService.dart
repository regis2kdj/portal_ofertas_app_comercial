import 'package:portal_ofertas_app_comercial/pantallas/VerOferta.dart';
import 'package:flutter/material.dart';

class Producto {
  final String id;
  final String name;
  final String description;
  final String regular_price;
  final String sale_price;
  final String stock_quantity;
  final String categories;
  final String imageURL;
  final String date_created;
  final String date_modified;
  final String status;


  Producto({this.id, this.name, this.description,this.regular_price,this.sale_price,this.stock_quantity,this.categories,this.imageURL,this.date_created,this.date_modified,this.status});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
        id: json['id'].toString(),
        name: json['name'],
        description: json['description'],
        regular_price: json['regular_price'].toString(),
        sale_price: json['sale_price'].toString(),
        stock_quantity: json['stock_quantity'].toString(),
        categories: json['categories'][0]['name'],
        imageURL: json['images'][0]['src'],
        date_created: json['date_created'],
        date_modified: json['date_modified'],
        status: json['status']
    );
  }
}


class ProductosLista extends StatelessWidget {
  final List<Producto> productos;

  ProductosLista({Key key, this.productos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return new GridView.count(
      primary: true,
      crossAxisCount: ((orientation == Orientation.portrait) ? 2 : 3),
      childAspectRatio: 0.95,
      children: List.generate(productos.length, (index) {
        return new GestureDetector(

          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[

                new Image.network(productos[index].imageURL,
                  width: 50,
                  height: 120,
                  fit: BoxFit.cover,),
                new Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(productos[index].name),
                      //new Text(producto.description),
                      //new Text(producto.date_modified),
                    ],
                  ),
                )
              ]
          ),

          onTap: () {
            debugPrint(productos[index].id);

            final datosApp = DatosApp(idOferta:productos[index].id);
            Navigator.push(context, MaterialPageRoute(builder: (context) => VerOferta(datosApp: datosApp)));


          },
        );
      }),
    );
  }

}

class DatosApp {
  String idOferta;
  DatosApp({this.idOferta});
}

class SesionApp {
  String username;
  SesionApp({this.username});
}

//clase para el servicio validate desde woocommerce
class ValidarUsuario {
  final String ID;
  final String user_login;
  final String user_pass;
  final String user_email;
  final String user_nicename;
  final String user_url;

  ValidarUsuario({this.ID, this.user_login, this.user_pass, this.user_email,this.user_nicename,this.user_url});

  factory ValidarUsuario.fromJson(Map<String, dynamic> json) {
    return ValidarUsuario(
        ID: json['ID'].toString(),
        user_login: json['user_login'],
        user_pass : json['user_pass'],
        user_email: json['user_email'],
        user_nicename: json['user_nicename'].toString(),
        user_url: json['user_url']

    );
  }
}


