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


  class VerOferta extends StatefulWidget {
    final DatosApp datosApp;

    VerOferta({Key key, this.title, @required this.datosApp}) : super(key: key);

  final String title;

   @override
  _VerOfertaState createState() => _VerOfertaState(datosApp);

}
class _VerOfertaState extends State<VerOferta> {

  final DatosApp datosApp;
  String _mensajeResultado="";
  MaterialColor _colorMensaje;
  String _idOferta="";

  _VerOfertaState(this.datosApp);

  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  numOferta = new TextEditingController();

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


  //Obtener 1 solo producto
  Future<Producto> obtenerProducto(String producto) async {
    String url = 'http://3.83.230.246/productoIndv.php?id='+producto;

    final response = await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Producto no encontrado. Favor volver a intentar con un valor distinto');
    }
  }


  //Eliminar etiquetas HTML en campo descripcion (asi viene de WooCommerce)
  String clearDesc(String desc) {
    String newDesc = desc;
    newDesc=newDesc.replaceAll('<p>', '');
    newDesc=newDesc.replaceAll('</p>', '');
    newDesc=newDesc.replaceAll('<strong>', '');
    newDesc=newDesc.replaceAll('</strong>', '');
    newDesc=newDesc.replaceAll('<br>', '');
    newDesc=newDesc.replaceAll('<br />', '');

    return newDesc;

  }


  Widget _title() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Ofertas App - Ver Oferta',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xff01579b),
            )
        )
    );
  }

  @override
  Widget buildOld(BuildContext context) {
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<Producto>(
                        future: obtenerProducto(datosApp.idOferta),

                        //sets the getQuote method as the expected Future
                        builder: (context, snapshot) {
                          if (snapshot
                              .hasData) { //checks if the response returns valid data
                            return Center(
                              child: Column(
                                children: <Widget>[

                                  SizedBox(
                                    height: 120,
                                  ),

                                  RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: 'Oferta # : ${datosApp.idOferta}',
                                          style: GoogleFonts.portLligatSans(
                                            textStyle: Theme.of(context).textTheme.display1,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff01579b),
                                          )
                                      )
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Oferta: ${snapshot.data.name}"),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Descripción de la oferta: ${clearDesc(snapshot.data.description)}"),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Precio Regular: ${snapshot.data.regular_price}"),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Precio de venta: ${snapshot.data.sale_price}"),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Categoría: ${snapshot.data.categories}"),

                                  SizedBox(
                                    height: 5,
                                  ),

                                  Expanded(
                                    child: Image.network(snapshot.data.imageURL,
                                      width: 350,
                                      height: 70,
                                      fit: BoxFit.cover,),
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),

                                  Text("Fecha creación: ${DateFormat("MM/dd/yyyy").format(DateTime.parse(snapshot.data.date_created)).toString()}"),
                                  Text("Fecha creación: ${DateFormat("MM/dd/yyyy").format(DateTime.parse(snapshot.data.date_modified)).toString()}"),
                                  Text("Estado: ${snapshot.data.status}"),

                                ],
                              ),
                            );
                          } else
                          if (snapshot.hasError) { //checks if the response throws an error
                            return Text("${snapshot.error}");
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ),

                  SizedBox(height: height * .14),

            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<Ordenes>(
                future: obtenerOrden(datosApp.idOferta),

                //sets the getQuote method as the expected Future
                builder: (context, snapshot) {
                  if (snapshot
                      .hasData) { //checks if the response returns valid data
                    return Center(
                      child: Column(
                        children: <Widget>[

                          SizedBox(
                            height: 120,
                          ),

                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: 'Oferta # : ${datosApp.idOferta}',
                                  style: GoogleFonts.portLligatSans(
                                    textStyle: Theme.of(context).textTheme.display1,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff01579b),
                                  )
                              )
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Text("Descripción de la oferta: ${snapshot.data.name}"),

                          SizedBox(
                            height: 5,
                          ),
                          Text("Comercio: ${snapshot.data.company}"),

                          SizedBox(
                            height: 5,
                          ),
                          Text("Precio de venta: ${snapshot.data.total}"),

                          SizedBox(
                            height: 5,
                          ),
                          Text("Comprado por: ${snapshot.data.first_name} ${snapshot.data.last_name}"),

                          SizedBox(
                            height: 5,
                          ),

                          _showProductImage(snapshot.data.product_id),

                          SizedBox(
                            height: 5,
                          ),

                          Text("E-mail del cliente: ${snapshot.data.email}"),

                          SizedBox(
                            height: 15,
                          ),

                          _buttonsMenu_Redimir(),

                          SizedBox(
                            height: 5,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: Text(_mensajeResultado,
                                style: TextStyle(color: _colorMensaje,
                                    fontSize: 18, fontWeight: FontWeight.bold)),
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
              ),
            ),

            SizedBox(height: height * .14),

            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }


  Widget _buttonsMenu_Redimir() {
    return InkWell(
      onTap: () {
        //ACCION DE REDIMIR OFERTA

        redimirOferta(datosApp.idOferta);

      },

      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffbdbdbd), Color(0xff01579b)])),
        child: Text(
          'Redimir Oferta',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  redimirOferta(String orden) async {
    try {
      final http.Response response = await http.get(
        'http://3.83.230.246/updateorden.php?idOrden='+orden,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        _actualizadDatosForm("Oferta redimida Satisfactoriamente",Colors.green);
      } else {
        _actualizadDatosForm("Error al redimir la oferta",Colors.red);
      }
    }
    on Exception catch (_) {
      _actualizadDatosForm("Excepción al integrar con ofertas",Colors.red);
    }
  }

  void _actualizadDatosForm(String nuevoMensaje, MaterialColor newColor) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _mensajeResultado=nuevoMensaje;
      _colorMensaje=newColor;

    });
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
                  width: 300,
                  height: 200,
                  scale: 0.9,
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




  Future<Ordenes> obtenerOrden(String orden) async {
    String url = 'http://3.83.230.246/ordenIndv.php?idOrden='+orden;

    final response = await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {

      return Ordenes.fromJson(json.decode(utf8.decode(response.bodyBytes)));

    } else {
      throw Exception('Orden no encontrada. Favor volver a intentar con un valor distinto');
    }
  }



}