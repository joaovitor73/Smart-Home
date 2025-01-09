import 'package:app/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 10, 178, 255),
      title: Text(
        'Smart Home',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          iconSize: 28,
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Abre o Drawer
          },
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'sair') {
              SystemNavigator.pop(); // Fecha o app
            }
          },
          icon: Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'sair',
                child: Text('Sair'),
              ),
            ];
          },
        ),
      ],
    );
  }
}
