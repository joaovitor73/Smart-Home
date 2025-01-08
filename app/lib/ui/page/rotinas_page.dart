import 'dart:convert';

import 'package:app/domain/Sensor.dart';
import 'package:app/ui/widgets/custom_app_bar.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RotinaPage extends StatefulWidget {
  const RotinaPage({super.key});

  @override
  _RotinaPageState createState() => _RotinaPageState();
}

class _RotinaPageState extends State<RotinaPage> {
  // ignore: unused_field
  String _currentScreen = 'Casa';

  List<Sensor> casaRotinas = [];
  List<Sensor> foraRotinas = [];
  final List<String> comodosDisponiveis = [
    'sala',
    'cozinha',
    'quarto',
    'banheiro'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> casaData = prefs.getStringList('Casa') ?? [];
    List<String> foraData = prefs.getStringList('Fora de Casa') ?? [];

    setState(() {
      casaRotinas = casaData.map((sensorJson) {
        Map<String, dynamic> sensorMap = jsonDecode(sensorJson);
        if (sensorMap['dados'] != null &&
            sensorMap['dados']['valor'] is String) {
          sensorMap['dados']['valor'] =
              double.tryParse(sensorMap['dados']['valor']);
        }
        return Sensor.fromJson(sensorMap);
      }).toList();

      foraRotinas = foraData.map((sensorJson) {
        Map<String, dynamic> sensorMap = jsonDecode(sensorJson);
        if (sensorMap['dados'] != null &&
            sensorMap['dados']['valor'] is String) {
          sensorMap['dados']['valor'] =
              double.tryParse(sensorMap['dados']['valor']);
        }
        return Sensor.fromJson(sensorMap);
      }).toList();
    });
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList(
      'Casa',
      casaRotinas.map((sensor) {
        sensor.dados['valor'] = sensor.dados['valor'] is double
            ? sensor.dados['valor']
            : double.tryParse(sensor.dados['valor'].toString()) ?? 0.0;
        return jsonEncode(sensor.toJson());
      }).toList(),
    );

    prefs.setStringList(
      'Fora de Casa',
      foraRotinas.map((sensor) {
        sensor.dados['valor'] = sensor.dados['valor'] is double
            ? sensor.dados['valor']
            : double.tryParse(sensor.dados['valor'].toString()) ?? 0.0;
        return jsonEncode(sensor.toJson());
      }).toList(),
    );
  }

  void onSelectScreen(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _addRotina(
      String category, String comodo, String nome, Map<String, dynamic> dados) {
    bool exists = (category == 'Casa' ? casaRotinas : foraRotinas)
        .any((sensor) => sensor.comodo == comodo && sensor.nome == nome);

    if (exists) {
      _showErrorDialog('Já existe um sensor com o mesmo nome neste cômodo.');
    } else {
      setState(() {
        if (category == 'Casa') {
          casaRotinas.add(Sensor(comodo: comodo, nome: nome, dados: {
            'valor': double.tryParse(dados['valor'].toString()) ?? 0.0,
          }));
        } else if (category == 'Fora de Casa') {
          foraRotinas.add(Sensor(comodo: comodo, nome: nome, dados: {
            'valor': double.tryParse(dados['valor'].toString()) ?? 0.0,
          }));
        }
      });

      _saveData();
    }
  }

  void _editRotina(String category, int index, String newComodo,
      String newSensor, Map<String, dynamic> newDados) {
    bool exists = (category == 'Casa' ? casaRotinas : foraRotinas).any(
        (sensor) =>
            sensor.comodo == newComodo &&
            sensor.nome == newSensor &&
            (category == 'Casa'
                ? casaRotinas.indexOf(sensor) != index
                : foraRotinas.indexOf(sensor) != index));

    if (exists) {
      _showErrorDialog('Já existe um sensor com o mesmo nome neste cômodo.');
    } else {
      setState(() {
        if (category == 'Casa') {
          casaRotinas[index] =
              Sensor(comodo: newComodo, nome: newSensor, dados: {
            'valor': double.tryParse(newDados['valor'].toString()) ?? 0.0,
          });
        } else if (category == 'Fora de Casa') {
          foraRotinas[index] =
              Sensor(comodo: newComodo, nome: newSensor, dados: {
            'valor': double.tryParse(newDados['valor'].toString()) ?? 0.0,
          });
        }
      });
      _saveData();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRotina(String category, int index) {
    setState(() {
      if (category == 'Casa') {
        casaRotinas.removeAt(index);
      } else if (category == 'Fora de Casa') {
        foraRotinas.removeAt(index);
      }
    });

    _saveData();
  }

  void _openEditModal(String category, int index) {
    String? selectedComodo = category == 'Casa'
        ? casaRotinas[index].comodo
        : foraRotinas[index].comodo;

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
              DropdownButtonFormField<String>(
                value: selectedComodo,
                items: comodosDisponiveis
                    .map((comodo) => DropdownMenuItem(
                          value: comodo,
                          child: Text(comodo),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedComodo = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Cômodo'),
              ),
              TextField(
                controller: sensorController,
                decoration: const InputDecoration(labelText: 'Sensor'),
              ),
              TextField(
                controller: dadosController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> newDados = {
                  'valor': double.tryParse(dadosController.text) ?? 0.0,
                };
                _editRotina(category, index, selectedComodo ?? '',
                    sensorController.text, newDados);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            )
          ],
        );
      },
    );
  }

  void _openAddModal(String category) {
    String? selectedComodo;
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
              DropdownButtonFormField<String>(
                value: selectedComodo,
                items: comodosDisponiveis
                    .map((comodo) => DropdownMenuItem(
                          value: comodo,
                          child: Text(comodo),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedComodo = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Cômodo'),
              ),
              TextField(
                controller: sensorController,
                decoration: const InputDecoration(labelText: 'Sensor'),
              ),
              TextField(
                controller: dadosController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> dados = {
                  'valor': double.tryParse(dadosController.text) ?? 0.0,
                };
                _addRotina(category, selectedComodo ?? '',
                    sensorController.text, dados);
                Navigator.of(context).pop();
              },
              child: Text('Adicionar'),
            )
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildRotinaSection(
            "Casa",
            casaRotinas,
            Colors.blue[50]!,
            Colors.blue[600]!,
          ),
          const SizedBox(height: 20),
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
        padding: const EdgeInsets.all(16),
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
            Divider(color: accentColor),
            rotinas.isEmpty
                ? Text(
                    'Nenhuma rotina adicionada.',
                    style: TextStyle(color: Colors.grey),
                  )
                : Column(
                    children: rotinas.asMap().entries.map((entry) {
                      int index = entry.key;
                      Sensor rotina = entry.value;
                      return ListTile(
                        title: Text(rotina.nome),
                        subtitle: Text('Cômodo: ${rotina.comodo}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: accentColor),
                              onPressed: () => _openEditModal(category, index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRotina(category, index),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
