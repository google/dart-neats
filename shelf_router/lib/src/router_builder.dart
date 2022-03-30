import 'dart:mirrors';

import 'route.dart';
import 'router.dart';

class RouterBuilder {
  static Router getRoutersByClass(List<Type> routeClasses) {
    var functions = _getRouteData(routeClasses);

    final _router = Router();
    _setupRoutes(functions, _router);
    return _router;
  }

  static void _setupRoutes(List<_FunctionData> functions, Router router) {
    for (var function in functions) {
      router.add(
        function.requestType,
        function.functionPath,
        function.function,
      );
    }
  }

  static List<_FunctionData> _getRouteData(List<Type> types) {
    assert(types.isNotEmpty, 'The list cannot be empty.');

    List<_FunctionData> routeData = [];
    for (var i = 0; i < types.length; i++) {
      List<_FunctionData>? functions = _getClassFunctions(types[i]);
      if (functions != null && functions.isNotEmpty) {
        routeData.addAll(functions);
      }
    }
    return routeData;
  }

  static List<_FunctionData>? _getClassFunctions(Type type) {
    var classMirror = reflectClass(type);

    List<_FunctionData> functions = [];
    for (var member in classMirror.instanceMembers.values) {
      functions.addAll(_getFunctionAnnotationPath(member, classMirror));
    }

    if (functions.isNotEmpty) {
      return functions;
    }

    return null;
  }

  static List<_FunctionData> _getFunctionAnnotationPath(
    DeclarationMirror declaration,
    ClassMirror classMirror,
  ) {
    List<_FunctionData> functions = [];

    for (var instance in declaration.metadata) {
      if (instance.hasReflectee) {
        var reflectee = instance.reflectee;
        if (reflectee.runtimeType == Route && reflectee is Route) {
          final newInst = classMirror.newInstance(Symbol(''), []);
          final field = newInst.getField(declaration.simpleName);
          final routeFunction = field.reflectee;

          functions.add(_FunctionData(
            reflectee.route,
            reflectee.verb,
            routeFunction,
          ));
        }
      }
    }

    return functions;
  }
}

class _FunctionData {
  _FunctionData(this.functionPath, this.requestType, this.function);
  final String functionPath;
  final String requestType;
  final Function function;
}
