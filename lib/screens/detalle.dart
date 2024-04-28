import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tel_help/constants/estados.dart';
import 'package:tel_help/providers/consulta.dart';
import 'package:tel_help/theme/responsive.dart';

class DetalleScreen extends StatefulWidget {
  static String name = "/detalle";
  
  const DetalleScreen({ Key? key }) : super(key: key);

  @override
  _DetalleScreenState createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  @override
  Widget build(BuildContext context) {
    final _consultaProvider = context.watch<ConsultaProvider>();
    final textTheme = Theme.of(context).textTheme;


    return Scaffold(
      appBar: AppBar(
        title: Text('Tel Help'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: ListView(
            children: [
              Text(_consultaProvider.consultaActual!.titulo,
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5,),
              Text(
                "Descripción: ${_consultaProvider.consultaActual!.descripcion}",
                style: textTheme.bodyLarge,),
              SizedBox(height: 5,),
              Text(
                "Estado: ${_consultaProvider.consultaActual!.estado}",
                style: textTheme.bodyLarge,),
              SizedBox(height: 12,),
              if(_consultaProvider.consultaActual!.imagenURL != null) 
                Image.network(_consultaProvider.consultaActual!.imagenURL!, height: Responsive(context).heightPercentage(50),),
              SizedBox(height: 5,),  
              if(_consultaProvider.consultaActual!.estado == Estados.pendiente.name)
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: ()=> _consultaProvider.actualizarEstado(context, Estados.rechazada.name), 
                        child: Text('Actualizar el estado a Rechazada', textAlign: TextAlign.center,)
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () => _consultaProvider.actualizarEstado(context, Estados.completada.name), 
                        child: Text('Actualizar el estado a  Completada', textAlign: TextAlign.center,)
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}