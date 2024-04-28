
class Consulta{
  String id;
  String titulo;
  String descripcion;
  String estado;
  String? imagenURL;

  Consulta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    this.imagenURL
  });
}