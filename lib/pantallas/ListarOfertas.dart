import 'package:flutter/material.dart';
import 'widget/BezierContainer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart';
import 'dart:convert' show utf8;
import '../integraciones/IntegrationService.dart';

class ListarOfertas extends StatefulWidget {
  ListarOfertas({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListarOfertasState createState() => _ListarOfertasState();
}

class _ListarOfertasState extends State<ListarOfertas> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Atras',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }



  Widget _title() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Ofertas App - Listar Ofertas',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xff01579b),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),


              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Lista de todas las Ofertas',
                      style: GoogleFonts.portLligatSans(
                        textStyle: Theme.of(context).textTheme.display1,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff01579b),
                      )
                  )
              ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              //padding: EdgeInsets.only(top: 20,left:20, right: 20),
              margin: EdgeInsets.all(10),
             /*
                child: FutureBuilder<List<Producto>>(
                          future: obtenerProductos(),
                          //sets the getQuote method as the expected Future
                          builder: (context, snapshot) {

                            if (snapshot.hasError) {
                              print(snapshot.error);
                            }

                            return snapshot.hasData
                                ? ProductosLista(productos: snapshot.data)
                                : Center(child: CircularProgressIndicator());
                          }
                      ),
              */
              child: FutureBuilder<List<Ordenes>>(
                  future: obtenerOrdenes(),
                  //sets the getQuote method as the expected Future
                  builder: (context, snapshot) {

                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }

                    return snapshot.hasData
                        ? OrdenesLista(ordenes: snapshot.data)
                        : Center(child: CircularProgressIndicator());
                  }
              ),

            ),



            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}

//Obtener todos los productos
Future<List<Producto>> obtenerProductos() async {
  String url = 'http://3.89.251.29/productos.php';
  final response = await http.get(url, headers: {"Accept": "application/json"});

  return compute(parseProductos,response.bodyBytes);
}

//Obtener todos los productos - estructurar formato json
List<Producto> parseProductos(List<int> responseBody) {
  String decodeData = utf8.decode(responseBody);

  final parsed = jsonDecode(decodeData).cast<Map<String, dynamic>>();

  return parsed.map<Producto>((json) => Producto.fromJson(json)).toList();
}

//Obtener todos las ordenes
Future<List<Ordenes>> obtenerOrdenes() async {
  String url = 'http://3.89.251.29/ordenes.php';
  final response = await http.get(url, headers: {"Accept": "application/json"});

  return compute(parseOrdenes,response.bodyBytes);
}

//Obtener todos las ordenes - estructurar formato json
List<Ordenes> parseOrdenes(List<int> responseBody) {
  String decodeData = utf8.decode(responseBody);

  final parsed = jsonDecode(decodeData).cast<Map<String, dynamic>>();

  return parsed.map<Ordenes>((json) => Ordenes.fromJson(json)).toList();
}




