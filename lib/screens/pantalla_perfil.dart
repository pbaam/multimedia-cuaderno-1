import 'package:flutter/material.dart';
import '../widgets/drawer_general.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil ({super.key});

  @override
  State<PantallaPerfil> createState() => _PantallaPerfil();
}

class _PantallaPerfil extends State<PantallaPerfil> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Principal')),
      body: Center(child: Text('hola')),
      drawer: DrawerGeneral(),
    );
  }
}