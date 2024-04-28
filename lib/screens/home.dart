import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tel_help/providers/consulta.dart';

class HomeScreen extends StatefulWidget {
  static String name = '/';
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  late ConsultaProvider _consultaProvider;

  @override
  void initState() {
    super.initState();
    Provider.of<ConsultaProvider>(context, listen: false).obtenerConsultas(context);
  }

  @override
  Widget build(BuildContext context) {
    _consultaProvider = context.watch();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Tel Help - Consultas'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: buildItems(context)
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>_consultaProvider.abrirModalAgregar(context)
      ),
    );
  }

  buildItems(BuildContext context){
    return _consultaProvider
      .consultas
      .map((x)=> Card(
        elevation: 4,
        child: ListTile(
          title: Text(x.titulo),
          subtitle: Text(x.descripcion),
          leading: x.imagenURL != null ? Image.network(x.imagenURL!, width: 50, height: 50,) : Container(width: 50, height: 50,color: Colors.grey,),
          trailing:  IconButton(
            icon: Icon(Icons.delete),
            onPressed: ()=> _consultaProvider.eliminar(context, x),
          ),
          onTap: ()=> _consultaProvider.navegarHaciaDetalle(context, x),
        ),
      ))
      .toList();
  }
}