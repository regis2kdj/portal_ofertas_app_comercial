import 'package:flutter/material.dart';

//estilos para pantallas con google fonts
import 'package:google_fonts/google_fonts.dart';
import 'pantallas/Bienvenida.dart';

//fecha
import 'package:intl/intl.dart';

//para servicios
import 'dart:convert' show utf8;

void main() {
  runApp(OfertasAppComercial());
}

class OfertasAppComercial extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Portal de Ofertas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Bienvenida(),
    );
  }
}