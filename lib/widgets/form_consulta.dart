import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tel_help/providers/consulta.dart';
import 'package:tel_help/theme/responsive.dart';

class FormConsulta extends StatefulWidget {
  const FormConsulta({ Key? key }) : super(key: key);

  @override
  _FormConsultaState createState() => _FormConsultaState();
}

class _FormConsultaState extends State<FormConsulta> {
  @override
  Widget build(BuildContext context) {
    final _consultaProvider = context.watch<ConsultaProvider>();
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
          child: Form(
            key: _consultaProvider.formKey,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [        
                      IconButton(
                        onPressed: () => _consultaProvider.cerrarModal(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _consultaProvider.tituloController,
                    decoration: InputDecoration(
                      label: Text('Título'),
                    ),
                    validator: (value) => _validacionInput(value)
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: _consultaProvider.descripcionController,
                    decoration: InputDecoration(
                      label: Text('Descripción'),
                    ),
                    validator: (value) => _validacionInput(value)
                  ),
                  SizedBox(height: 8,),
                  _ImageUpload(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: _consultaProvider.cargando ? null : ()=> _consultaProvider.agregar(context), 
                      child: _consultaProvider.cargando ? 
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ) : 
                        Text('Enviar consulta',style: TextStyle(fontSize: 20),)
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _validacionInput(String? value){
    if(value == null || value.isEmpty){
      return "campo obligatorio";
    }
    return null;
  }
}


class _ImageUpload extends StatelessWidget {
  const _ImageUpload();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    final provider = context.watch<ConsultaProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.heightPercentage(2)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                )
              ),
              child: SizedBox(
                height: responsive.heightPercentage(20),
                child: Center(
                  child: provider.imagenURL == null ? 
                    Text('Subir imagen', style: texts.bodyLarge) :
                    Image.network(provider.imagenURL!)
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.widthPercentage(5)),
          ElevatedButton(
            onPressed: ()=> uploadImage(context),
            child: const Icon(Icons.upload)
          ),
        ],
      ),
    );
  }

  Future<void> uploadImage(BuildContext context) async {
    try {
      final provider = context.read<ConsultaProvider>();
      // Seleccionar imagen desde la galería
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      // Obtener referencia al bucket de Firebase Storage
      final firebaseStorageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

      // Subir la imagen al bucket
      await firebaseStorageRef.putFile(File(pickedFile.path));

      // Obtener la URL de descarga
      provider.imagenURL = await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      
    }

  }
}