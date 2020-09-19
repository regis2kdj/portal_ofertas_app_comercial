import 'package:flutter/material.dart';
import 'widget/BezierContainer.dart';
import 'package:portal_ofertas_app_comercial/pantallas/MenuPrincipal.dart';
import 'package:google_fonts/google_fonts.dart';

class NuevaOferta extends StatefulWidget {
  NuevaOferta({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NuevaOfertaState createState() => _NuevaOfertaState();
}

class _NuevaOfertaState extends State<NuevaOferta> {

  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  titulo = new TextEditingController();
  TextEditingController  descripcion = new TextEditingController();
  TextEditingController  categoria = new TextEditingController();
  TextEditingController  url = new TextEditingController();

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


  Widget _submitButton() {
    return InkWell(
      onTap: () {
        //ACCION DE CREAR NUEVA OFERTA QR
        if (keyForm.currentState.validate()) {
          print("Nombre de la Oferta: ${titulo.text}");
          print("Descripcion: ${descripcion.text}");
          print("Categoria: ${categoria.text}");
          print("URL: ${url.text}");
        }
        //Navigator.push(context, MaterialPageRoute(builder: (context) => VerOferta()))
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
                _entryField("URL de imagen",url),
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
                    SizedBox(height: height * .14),
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