import 'package:flutter/material.dart';
import 'widget/BezierContainer.dart';
import 'package:portal_ofertas_app_comercial/pantallas/MenuPrincipal.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../integraciones/IntegrationService.dart';

class NuevaOferta extends StatefulWidget {
  NuevaOferta({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NuevaOfertaState createState() => _NuevaOfertaState();
}

class _NuevaOfertaState extends State<NuevaOferta> {

  String _mensajeResultado="";
  MaterialColor _colorMensaje;

  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  titulo = new TextEditingController();
  TextEditingController  descripcion = new TextEditingController();
  TextEditingController  categoria = new TextEditingController();
  TextEditingController  precio = new TextEditingController();

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


  void _limpiarCampos(){

    if (keyForm.currentState.validate()) {
      titulo.text="";
      descripcion.text="";
      categoria.text="";
      precio.text="";

      print("Nombre de la Oferta: ${titulo.text}");
      print("Descripcion: ${descripcion.text}");
      print("Categoria: ${categoria.text}");
      print("Precio: ${precio.text}");
    }

  }

  crearOferta(String nombre, String precio, String descripcion) async {
      try {
        final http.Response response = await http.post(
          'http://3.83.230.246/crearProducto.php',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'nombre': nombre,
            'precio': precio,
            'descripcion': descripcion,
          }),
        );
        debugPrint(response.statusCode.toString());
        if (response.statusCode == 200) {
          _actualizadDatosForm("Oferta creada Satisfactoriamente",Colors.green);
          _limpiarCampos();
        } else {
          _actualizadDatosForm("Error al crear la oferta",Colors.red);
        }
      }
      on Exception catch (_) {
        _actualizadDatosForm("Excepción al integrar con ofertas",Colors.red);
      }
    }


  Widget _submitButton() {
    return InkWell(
      onTap: () {
        //ACCION DE CREAR NUEVA OFERTA QR
        if (keyForm.currentState.validate()) {
          print("Nombre de la Oferta: ${titulo.text}");
          print("Descripcion: ${descripcion.text}");
          print("Categoria: ${categoria.text}");
          print("Precio: ${precio.text}");
        }
        //crearOferta(titulo.text,precio.text,descripcion.text);
        crearOferta("Paga 2 almuerzos por el precio de 1","20.00","Ven al restaurante y come 2 deliciosos almuerzos por el precio de 1. Precio regular 40.00");
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
          'Crear nueva Oferta',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  Widget _title() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Ofertas App - Nueva Oferta',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xff01579b),
            )
        )
    );
  }

  Widget _entryField(String title, TextEditingController field, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: field,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }


  Widget _formularioWidget() {
    return Column(
      children: <Widget>[

        new Form(
          key: keyForm,
          child: Column(
              children: <Widget>[
                _entryField("Titulo",titulo),
                _entryField("Descripción de la oferta",descripcion),
                _entryField("Categoría",categoria),
                _entryField("Precio",precio),
            ],
          )
        ),

      ],
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),

                    _formularioWidget(),

                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(), //boton submit
                    SizedBox(height: 10),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Text(_mensajeResultado,
                          style: TextStyle(color: _colorMensaje,
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),

                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}



