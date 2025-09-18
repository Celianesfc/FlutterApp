import 'package:flutter_test/flutter_test.dart';

Future<int> process() async {
  await Future.delayed(const Duration(seconds: 5));
  return 0;
}

Map<String, List<double>> alunos = {
  'Maria': [8.0, 9.0],
  'Bruna': [7.0, 7.0],
  'Carla': [10.0, 9.0],
};

Future<List<double>?> search(String key) async {
  return Future.delayed(const Duration(seconds: 2), () {
    if (alunos.containsKey(key)) {
      return alunos[key]!;
    }
    throw ArgumentError('Aluno não encontrado.');
  });
}

Stream<int> count() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
}

Stream<double> media(List<String> nomes) async* {
  for (String nome in nomes) {
    // Adicionando um try-catch para lidar com erros de forma mais robusta
    try {
      List<double>? notas = await search(nome);
      if (notas != null) {
        double media = notas.reduce((a, b) => a + b) / notas.length;
        yield media;
      }
    } catch (e) {
      // Em vez de deixar o erro terminar o stream, vamos relançá-lo
      // para que o teste possa capturá-lo.
      rethrow;
    }
  }
}

void main() {
  group('Testes de programação assíncrona', () {
    late Future<int> result;
    setUp(() => result = process());
    test('Aguardando...', () => expect(result, isNotNull));
    test('Testando o resultado', () async {
      int num = await result;
      expect(num, 0);
    });
    test('Testando busca sem erros em Future', () {
      search('Maria').then((notas) => expect(notas, [8.0, 9.0]));
    });
    test('Testando busca com erros em Future', () {
      search('Paula').then((notas) {}).catchError((error) {
        expect(error, isA<ArgumentError>());
      });
    });
    test('Testando contagem em Stream', () {
      expect(
        count(),
        emitsInOrder([1, 2, 3, emitsDone]),
      );
    });

    test('Testando média em Stream sem erros', () {
      expect(
        media(['Maria', 'Bruna', 'Carla']),
        emitsInOrder([8.5, 7.0, 9.5, emitsDone]),
      );
    });

    test('Testando média em Stream com erro', () {
      expect(
        media(['Maria', 'Paula', 'Bruna']),
        emitsInOrder([
          8.5,
          emitsError(isA<ArgumentError>()),
        ]),
      );
    });
  });
}
