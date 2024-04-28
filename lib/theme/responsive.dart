import 'dart:math';
import 'package:flutter/material.dart';

class Responsive{
  double _width = 0;  
  double _height = 0;
  double _diagonal = 0;

  Responsive(BuildContext context) {

    // Obtiene el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    // Almacena ancho y alto
    _width = size.width;  
    _height = size.height;

    // Calcula la diagonal usando Pitágoras 
    _diagonal = sqrt(pow(_width, 2) + pow(_height, 2));

  }

  double widthPercentage(double percent) {
    return _width * percent / 100;
  }

  double heightPercentage(double percent) {
    return _height * percent / 100;
  }

  double diagonalPercentage(double percent) {
    return _diagonal * percent / 100;
  }
}