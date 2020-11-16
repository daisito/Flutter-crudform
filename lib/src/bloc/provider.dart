import 'package:flutter/material.dart';
import 'package:crudform/src/bloc/login_bloc.dart';
export 'package:crudform/src/bloc/login_bloc.dart';
import 'package:crudform/src/bloc/productos_bloc.dart';
export 'package:crudform/src/bloc/productos_bloc.dart';

class Provider extends InheritedWidget {
  
  final loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia == null){
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  Provider._internal({Key key, Widget child})
            : super(key: key, child:  child);

  

  // Provider({Key key, Widget child})
  //           : super(key: key, child:  child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc );
  }

  static ProductosBloc productosBloc (BuildContext context){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc );
  }
}
