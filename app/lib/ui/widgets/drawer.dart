import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentScreen;
  final Function(String) onSelectScreen;

  AppDrawer({required this.currentScreen, required this.onSelectScreen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(30, 40, 0, 0),
            height: 40,
            child: Row(
              children: [
                Icon(Icons.devices,
                    color: Color.fromARGB(141, 0, 0, 0), size: 30), // Ícone IoT
                SizedBox(width: 10),
                Text(
                  'Smart Home',
                  style: TextStyle(
                    color: const Color.fromARGB(141, 0, 0, 0),
                    fontSize: 20, // Tamanho reduzido do texto
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            screen: 'Home',
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.access_alarm,
            title: 'Rotinas',
            screen: 'Rotinas',
            context: context,
          ),
          Divider(),
          _buildDrawerItem(
            icon: Icons.notifications,
            title: 'Notificações',
            screen: '',
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.account_circle,
            title: 'User',
            screen: '',
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String screen,
    required BuildContext context,
  }) {
    bool isSelected = currentScreen == screen;
    return ListTile(
      leading: Icon(icon,
          color: isSelected
              ? Color.fromARGB(255, 41, 194, 255)
              : const Color.fromARGB(141, 0, 0, 0)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? Color.fromARGB(255, 41, 194, 255)
              : const Color.fromARGB(141, 0, 0, 0),
        ),
      ),
      tileColor: isSelected ? Color(0xFFE0F5FE) : null,
      onTap: () {
        onSelectScreen(screen);
        Navigator.pop(context);
      },
    );
  }
}
