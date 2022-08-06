import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'search_state.dart';

class SearchCepBloc {
  final _streamController = StreamController<String>.broadcast();
  Sink<String> get searchCep => _streamController.sink;
  Stream<SearchCepState> get cepResult =>
      _streamController.stream.switchMap(_searchCep);

  Stream<SearchCepState> _searchCep(String cep) async* {
    yield const SearchCepLoading();

    try {
      final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');

      yield SearchCepSuccess(response.data!);
    } catch (e) {
      yield const SearchCepError("Erro na pesquisa");
    }
  }

  void dispose() {
    _streamController.close();
  }
}
