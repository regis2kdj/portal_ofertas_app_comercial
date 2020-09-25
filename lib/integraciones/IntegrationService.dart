import 'package:portal_ofertas_app_comercial/pantallas/VerOferta.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

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


//clase para el servicio crearProducto desde woocommerce
class Oferta {
  final String nombre;
  final String precio;
  final String descripcion;

  Oferta({this.nombre, this.precio, this.descripcion});

  factory Oferta.fromJson(Map<String, dynamic> json) {
    return Oferta(
        nombre: json['nombre'],
        precio: json['precio'],
        descripcion : json['descripcion'],
    );
  }
}


class Ordenes {

  final String id;
  final String first_name;
  final String last_name;
  final String company;
  final String email;
  final String name;
  final String product_id;
  final String total;

  Ordenes({this.id, this.first_name,this.last_name,this.company,this.email,this.name,this.product_id,this.total});

  factory Ordenes.fromJson(Map<String, dynamic> json) =>
     Ordenes(
        id: json['id'].toString(),
        first_name: json['billing']['first_name'],
        last_name: json['billing']['last_name'],
        company: json['billing']['company'],
        email: json['billing']['email'],
        name: json['line_items'][0]['name'],
        product_id: json['line_items'][0]['product_id'].toString(),
        total: json['line_items'][0]['total'].toString()
    );

    Map<String, dynamic> toJson() => {
      "id": id,
      "first_name": first_name,
      "last_name": last_name,
      "company": company,
      "email": email,
      "name": name,
      "product_id": product_id,
      "total": total,

    };

  }


class OrdenesLista extends StatelessWidget {
  final List<Ordenes> ordenes;

  OrdenesLista({Key key, this.ordenes}) : super(key: key);


  Future<Producto> obtenerProducto(String producto) async {
    String url = 'http://3.83.230.246/productoIndv.php?id='+producto;

    final response = await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Producto no encontrado. Favor volver a intentar con un valor distinto');
    }
  }

  Widget _showProductImage(String numProd) {
    return  FutureBuilder<Producto>(
      future: obtenerProducto(numProd),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Column(

              children: <Widget>[

                Image.network(snapshot.data.imageURL,
                  width: 100,
                  height: 120,
                  //scale: 0.9,
                  fit:BoxFit.cover,
                ),

              ],
            ),
          );
        } else
        if (snapshot.hasError) { //checks if the response throws an error
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return new GridView.count(
      primary: true,
      crossAxisCount: ((orientation == Orientation.portrait) ? 2 : 3),
      childAspectRatio: 0.95,
      children: List.generate(ordenes.length, (index) {
        return new GestureDetector(

          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
/*
                new
                  //Image.network(ordenes[index].imageURL,
                  //Image.network("https://hipertextual.com/files/2019/04/hipertextual-samsung-galaxy-m20-2019238928.jpg",
                  width: 50,
                  height: 120,
                  fit: BoxFit.cover,),
                  */
                _showProductImage(ordenes[index].product_id),
                new Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(ordenes[index].name),
                      new Text("Orden # "+ordenes[index].id,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      //new Text(producto.date_modified),
                    ],
                  ),
                )
              ]
          ),

          onTap: () {
            debugPrint(ordenes[index].id);

            final datosApp = DatosApp(idOferta:ordenes[index].id);
            Navigator.push(context, MaterialPageRoute(builder: (context) => VerOferta(datosApp: datosApp)));


          },
        );
      }),
    );
  }

}



