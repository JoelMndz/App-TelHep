import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tel_help/constants/estados.dart';
import 'package:tel_help/model/consulta.dart';
import 'package:tel_help/screens/detalle.dart';
import 'package:tel_help/utils/error.dart';
import 'package:tel_help/widgets/form_consulta.dart';

class ConsultaProvider with ChangeNotifier{
  final _coleccion = FirebaseFirestore.instance.collection('consultas');

  List<Consulta> consultas = [];
  bool _cargando = false;
  bool get cargando => _cargando;
  set cargando(bool v){_cargando = v; notifyListeners();}
  Consulta? consultaActual;

  //Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  String? _imagenURL; 
  String? get imagenURL => _imagenURL;
  set imagenURL(String? v){_imagenURL=v; notifyListeners();}

  obtenerConsultas(BuildContext context) async{
    try {
      final data = await _coleccion.get();
      for (var i = 0; i < data.docs.length; i++) {
        final json = data.docs[i].data();
        consultas.add(Consulta(
          id: data.docs[i].id,
          titulo: json['titulo'], 
          descripcion: json['descripcion'], 
          estado: json['estado'],
          imagenURL: json['imagenURL']
        ));
      }
      notifyListeners();
    } catch (e) {
      manejarError(context, e);
    }
  }

  abrirModalAgregar(BuildContext context){
    showModalBottomSheet(
      context: context, 
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => FormConsulta(),
    );
  }

  cerrarModal(BuildContext context){
    Navigator.pop(context);
    tituloController.text = '';
    descripcionController.text = '';
    imagenURL = null;
  }

  actualizarEstado(BuildContext context, String estado) async{
    try {
      cargando = true;
      consultas = consultas.map((x){
        if(x.id == consultaActual!.id){
          x.estado = estado;
        }
        return x;
      }).toList();
      Navigator.pop(context);
      await _coleccion.doc(consultaActual!.id).update({
        estado: estado
      });
    } catch (e) {
      manejarError(context, e);
    }finally{
      cargando = false;
    }
  }

  agregar(BuildContext context) async{
    try {
      if(!formKey.currentState!.validate()) return;
      cargando = true;
      final respuesta = await _coleccion.add({
        "titulo": tituloController.text,
        "descripcion": descripcionController.text,
        "estado": Estados.pendiente.name,
        "imagenURL": imagenURL
      });
      consultas.add(Consulta(
        id: respuesta.id, 
        titulo: tituloController.text, 
        descripcion: descripcionController.text, 
        estado: Estados.pendiente.name,
        imagenURL: imagenURL
      ));
      notifyListeners();
      cerrarModal(context);
    } catch (e) {
      manejarError(context, e);
    }finally{
      cargando = false;
    }
  }

  eliminar(BuildContext context, Consulta consulta){
    try {
      return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe responder al diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Esta seguro de eliminar la consulta "${consulta.titulo}"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                consultas = consultas.where((x) => x.id != consulta.id).toList();
                notifyListeners();
                Navigator.of(context).pop();
                await _coleccion.doc(consulta.id).delete();
              },
              child: Text(
                'Eliminar',
              ),
            ),
          ],
        );
      },
    );
    } catch (e) {
      manejarError(context, e);
    }
  }

  navegarHaciaDetalle(BuildContext context, Consulta consulta){
    consultaActual = consulta;
    notifyListeners();
    Navigator.pushNamed(context, DetalleScreen.name);
  }
}