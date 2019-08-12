import 'dart:async';

class Validators {
  final validateQuery = StreamTransformer<String, String>.fromHandlers(
    handleData: (query, sink) {
      if (query == null || query == '') {
        sink.addError('Query is required!');
      } else {
        sink.add(query);
      }
    }
  );
}