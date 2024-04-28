import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

manejarError(BuildContext context, Object error){
  String? mensajeError = null;
  if(error is FirebaseException){
    switch(error.code){
      case "unavailable":
        mensajeError = 'Revise su conexión a internet!';
        break;
    }
  }

  //Contemplar el uso de microtareas
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensajeError ?? error.toString().replaceFirst('Exception: ', '')),
      backgroundColor: Colors.red[800],
      
    )
  );
}