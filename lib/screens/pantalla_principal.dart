import 'package:flutter/material.dart';
import '../widgets/drawer_general.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaInicioSesion();
}

class _PantallaInicioSesion extends State<PantallaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Principal')),
      body: Center(child: Text('hola')),
      drawer: DrawerGeneral(),
    );
  }
}