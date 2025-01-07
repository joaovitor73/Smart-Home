import 'dart:convert';

import 'package:app/domain/Sensor.dart';
import 'package:app/ui/widgets/custom_app_bar.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RotinaPage extends StatefulWidget {
  @override
  _RotinaPageState createState() => _RotinaPageState();
}

class _RotinaPageState extends State<RotinaPage> {
  String _currentScreen = 'Casa';

  List<Sensor> casaRotinas = [];
  List<Sensor> foraRotinas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Carregar dados de SharedPreferences
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> casaData = prefs.getStringList('casa') ?? [];
    List<String> foraData = prefs.getStringList('fora') ?? [];

    setState(() {
      casaRotinas = casaData.map((sensorJson) {
        Map<String, dynamic> sensorMap = jsonDecode(sensorJson);
        if (sensorMap['dados'] != null &&
            sensorMap['dados']['valor'] is String) {
          // Converte o valor para double se necessário
          sensorMap['dados']['valor'] =
              double.tryParse(sensorMap['dados']['valor']);
        }
        return Sensor.fromJson(sensorMap);
      }).toList();

      foraRotinas = foraData.map((sensorJson) {
        Map<String, dynamic> sensorMap = jsonDecode(sensorJson);
        if (sensorMap['dados'] != null &&
            sensorMap['dados']['valor'] is String) {
          // Converte o valor para double se necessário
          sensorMap['dados']['valor'] =
              double.tryParse(sensorMap['dados']['valor']);
        }
        return Sensor.fromJson(sensorMap);
      }).toList();
    });
  }

  // Função para salvar dados em SharedPreferences
  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Salvando casaRotinas
    prefs.setStringList(
      'casa',
      casaRotinas.map((sensor) {
        // Convertendo 'valor' para String antes de salvar
        sensor.dados['valor'] = sensor.dados['valor'].toString();
        return jsonEncode(sensor.toJson());
      }).toList(),
    );

    // Salvando foraRotinas
    prefs.setStringList(
      'fora',
      foraRotinas.map((sensor) {
        // Convertendo 'valor' para String antes de salvar
        sensor.dados['valor'] = sensor.dados['valor'].toString();
        return jsonEncode(sensor.toJson());
      }).toList(),
    );
  }

  void onSelectScreen(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  // Função para adicionar sensores
  void _addRotina(
      String category, String comodo, String nome, Map<String, dynamic> dados) {
    setState(() {
      if (category == 'Casa') {
        casaRotinas.add(Sensor(comodo: comodo, nome: nome, dados: dados));
      } else if (category == 'Fora de Casa') {
        foraRotinas.add(Sensor(comodo: comodo, nome: nome, dados: dados));
      }
    });

    _saveData(); // Salva os dados ao adicionar
  }

  // Função para editar sensores
  void _editRotina(String category, int index, String newComodo,
      String newSensor, Map<String, dynamic> newDados) {
    setState(() {
      if (category == 'Casa') {
        casaRotinas[index] =
            Sensor(comodo: newComodo, nome: newSensor, dados: newDados);
      } else if (category == 'Fora de Casa') {
        foraRotinas[index] =
            Sensor(comodo: newComodo, nome: newSensor, dados: newDados);
      }
    });

    _saveData(); // Salva os dados após editar
  }

  // Função para excluir sensores
  void _deleteRotina(String category, int index) {
    setState(() {
      if (category == 'Casa') {
        casaRotinas.removeAt(index);
      } else if (category == 'Fora de Casa') {
        foraRotinas.removeAt(index);
      }
    });

    _saveData(); // Salva os dados após excluir
  }

  // Função para abrir modal de edição
  void _openEditModal(String category, int index) {
    final comodoController = TextEditingController(
        text: category == 'Casa'
            ? casaRotinas[index].comodo
            : foraRotinas[index].comodo);
    final sensorController = TextEditingController(
        text: category == 'Casa'
            ? casaRotinas[index].nome
            : foraRotinas[index].nome);
    final dadosController = TextEditingController(
        text: category == 'Casa'
            ? casaRotinas[index].dados['valor'].toString()
            : foraRotinas[index].dados['valor'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Rotina - $category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: comodoController,
                decoration: InputDecoration(labelText: 'Cômodo'),
              ),
              TextField(
                controller: sensorController,
                decoration: InputDecoration(labelText: 'Sensor'),
              ),
              TextField(
                controller: dadosController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> newDados = {
                  'valor': double.tryParse(dadosController.text) ?? 0.0,
                };
                _editRotina(category, index, comodoController.text,
                    sensorController.text, newDados);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Função para abrir modal de adicionar rotina
  void _openAddModal(String category) {
    final comodoController = TextEditingController();
    final sensorController = TextEditingController();
    final dadosController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Rotina - $category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: comodoController,
                decoration: InputDecoration(labelText: 'Cômodo'),
              ),
              TextField(
                controller: sensorController,
                decoration: InputDecoration(labelText: 'Sensor'),
              ),
              TextField(
                controller: dadosController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> dados = {
                  'valor': double.tryParse(dadosController.text) ?? 0.0,
                };
                _addRotina(category, comodoController.text,
                    sensorController.text, dados);
                Navigator.of(context).pop();
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: AppDrawer(
        currentScreen: "Rotinas",
        onSelectScreen: onSelectScreen,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildRotinaSection(
            "Casa",
            casaRotinas,
            Colors.blue[50]!,
            Colors.blue[600]!,
          ),
          SizedBox(height: 20),
          _buildRotinaSection(
            "Fora de Casa",
            foraRotinas,
            Colors.orange[50]!,
            Colors.orange[600]!,
          ),
        ],
      ),
    );
  }

  Widget _buildRotinaSection(
      String category, List<Sensor> rotinas, Color bgColor, Color accentColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rotinas $category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: accentColor),
                  onPressed: () => _openAddModal(category),
                ),
              ],
            ),
            SizedBox(height: 8),
            rotinas.isEmpty
                ? Center(child: Text('Nenhuma rotina adicionada'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: rotinas.length,
                    itemBuilder: (context, index) {
                      final sensor = rotinas[index];
                      return ListTile(
                        title: Text(sensor.nome),
                        subtitle: Text(sensor.comodo),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _openEditModal(category, index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteRotina(category, index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
