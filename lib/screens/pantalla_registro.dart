import 'package:flutter/material.dart';
import '../widgets/drawer_general.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistro();
}

class _PantallaRegistro extends State<PantallaRegistro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Principal')),
      body: Center(child: Text('hola')),
      drawer: DrawerGeneral(),
    );
  }
}