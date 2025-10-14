import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/drawer_general.dart';
import '../widgets/login_form.dart';

class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({super.key});

  @override
  State<PantallaInicioSesion> createState() => _PantallaInicioSesion();
}

class _PantallaInicioSesion extends State<PantallaInicioSesion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Principal')),
      body: Center(
        child: Column(children: [
          SvgPicture.asset(
            'images/youtube.svg',
            semanticsLabel: 'YouTube logo',
            height: 100,
            width: 100,
          ),
          LoginForm(),
        ],),
      ),
      drawer: DrawerGeneral(),
    );
  }
}