import 'package:bloc_busca_por_cep/bloc/search_cep_bloc.dart';
import 'package:flutter/material.dart';

import 'bloc/search_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();

  final SearchCepBloc _searchCepBloc = SearchCepBloc();

  @override
  void dispose() {
    super.dispose();

    _searchCepBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'cep',
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () {
                _searchCepBloc.searchCep.add(textController.text);
              },
              child: const Text('Pesquisar'),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<SearchCepState>(
                stream: _searchCepBloc.cepResult,
                builder: (context, snapshot) {
                  // snapshot.data retorna o estado do BLoC.

                  var state = snapshot.data!;

                  if (!snapshot.hasData) {
                    return Container();
                  }

                  if (state is SearchCepError) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  }

                  if (state is SearchCepLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  state = state as SearchCepSuccess;

                  return Text("Cidade: ${state.data['localidade']}");
                }),
          ],
        ),
      ),
    );
  }
}
