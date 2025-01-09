import 'package:flutter/material.dart';

class ColorAdjustmentScreen extends StatefulWidget {
  @override
  _ColorAdjustmentScreenState createState() => _ColorAdjustmentScreenState();
}

class _ColorAdjustmentScreenState extends State<ColorAdjustmentScreen> {
  double _redValue = 0.0;
  double _greenValue = 0.0;
  double _blueValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajustar LED RGB")),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Red slider
            _buildColorSlider("Red", _redValue, (value) {
              setState(() {
                _redValue = value;
              });
            }),

            SizedBox(width: 20),

            // Green slider
            _buildColorSlider("Green", _greenValue, (value) {
              setState(() {
                _greenValue = value;
              });
            }),

            SizedBox(width: 20),

            // Blue slider
            _buildColorSlider("Blue", _blueValue, (value) {
              setState(() {
                _blueValue = value;
              });
            }),
          ],
        ),
      ),
    );
  }

  // Método para criar cada slider com o estilo desejado
  Widget _buildColorSlider(
      String colorName, double value, Function(double) onChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(colorName),
        Container(
          height: 200, // Define the height of the slider container
          width: 50, // Define the width of the slider container
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                15), // Border radius for the slider container
            color: Colors.grey.shade200, // Background color
          ),
          child: RotatedBox(
            quarterTurns: 1, // Gira o slider em 90 graus
            child: Slider(
              value: value,
              min: 0,
              max: 255,
              onChanged: onChanged,
              activeColor: colorName == "Red"
                  ? Colors.red
                  : colorName == "Green"
                      ? Colors.green
                      : Colors.blue,
              inactiveColor: Colors.grey.shade300,
              thumbColor: colorName == "Red"
                  ? Colors.red
                  : colorName == "Green"
                      ? Colors.green
                      : Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
