import 'dart:convert';
import 'dart:io';

import 'package:crudform/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:crudform/src/models/producto_model.dart';
import 'package:mime_type/mime_type.dart';

class ProductoProvider {
  final String _url = 'https://flutter-varios-ea1b6.firebaseio.com';
  final prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${prefs.token}';

    final resp = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${prefs.token}';

    final resp = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${prefs.token}';
    final resp = await http.get(url);

    final productos = new List<ProductoModel>();

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    // print(decodedData);

    if (decodedData == null) return [];
    
    //Verifacamos si expiro Token
    if(decodedData['error'] != null) return[];

    decodedData.forEach((id, producto) {
      final prodTemp = ProductoModel.fromJson(producto);
      prodTemp.id = id;
      productos.add(prodTemp);
    });
    print(productos);
    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${prefs.token}';
    final resp = await http.delete(url);
    print(resp.body);

    return 1;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dtckxcdzw/image/upload?upload_preset=xsfkia36');
    final mimeType = mime(imagen.path).split('/'); //image/jpg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], 
        mimeType[1])
        );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo Salio Mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    print(respData);
    return respData['secure_url'];

  }
}
