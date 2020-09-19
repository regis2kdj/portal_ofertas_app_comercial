import 'package:flutter/material.dart';
import 'widget/BezierContainer.dart';
import 'package:portal_ofertas_app_comercial/pantallas/MenuPrincipal.dart';
import 'package:google_fonts/google_fonts.dart';

class LeerQR extends StatefulWidget {
  LeerQR({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LeerQRState createState() => _LeerQRState();
}

class _LeerQRState extends State<LeerQR> {
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
          //ACCION DE LEER CODIGO QR
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
        'Verificar',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
    );
  }


  Widget _title() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Ofertas App - Leer QR',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xff01579b),
            )
        )
    );
  }

  Widget _buttonsMenu_ScanQR() {
    return InkWell(

      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              // needed
              color: Colors.transparent,
              child: InkWell(
                onTap: () => {
                  //ACCION DE LEER CODIGO QR
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => VerOferta()))
                },
                child: Image.asset(
                  "images/qr_code_scanner.png",
                  width: 340,
                  height: 340,
                  fit: BoxFit.cover,
                ),
              ),
            ),

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

                    _buttonsMenu_ScanQR(),

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