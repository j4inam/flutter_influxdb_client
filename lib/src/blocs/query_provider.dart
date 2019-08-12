import 'package:flutter/material.dart';
import 'query_bloc.dart';
export 'query_bloc.dart';

class QueryProvider extends InheritedWidget {
  final QueryBloc bloc;

  QueryProvider({Key key, Widget child})
    : bloc = QueryBloc(),
      super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static QueryBloc of(BuildContext context) {
    return (context.ancestorWidgetOfExactType(QueryProvider)
            as QueryProvider)
        .bloc;
  }
}