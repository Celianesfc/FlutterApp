import 'package:flutter_test/flutter_test.dart';

void main() {
  // A função setUp é chamada antes de cada teste, garantindo a independência.
  late List<int> numeros;

  setUp(() {
    numeros = [1, 2, 3];
  });

  test('Adicionar elemento', () {
    numeros.add(4);
    expect(numeros, [1, 2, 3, 4]);
  });

  test('Adicionar outra lista', () {
    numeros.addAll([5, 6]);
    expect(numeros, [1, 2, 3, 5, 6]);
  });

  test('Adicionar na posição', () {
    numeros.insert(0, 0);
    expect(numeros, [0, 1, 2, 3]);
  });

  test('Remover elemento', () {
    numeros.remove(2);
    expect(numeros.contains(2), isFalse);
    expect(numeros, [1, 3]);
  });

  test('Remover na posição', () {
    numeros.removeAt(0);
    expect(numeros, [2, 3]);
  });

  test('Testar tamanho', () {
    expect(numeros.length, 3);
    numeros.add(4);
    expect(numeros.length, 4);
  });

  test('Testar vazio e não vazio', () {
    expect(numeros.isEmpty, isFalse);
    expect(numeros.isNotEmpty, isTrue);
    
    final listaVazia = [];
    expect(listaVazia.isEmpty, isTrue);
    expect(listaVazia.isNotEmpty, isFalse);
  });

  test('Testar ordenação', () {
    final listaDesordenada = [3, 1, 2];
    // reversed retorna um Iterable, então convertemos para List
    expect(listaDesordenada.reversed.toList(), [2, 1, 3]); 
    
    listaDesordenada.sort(); // sort modifica a lista original
    expect(listaDesordenada, [1, 2, 3]);
  });

  test('Testar percorrer e transformar lista', () {
    // for-in
    int soma = 0;
    for (int numero in numeros) {
      soma += numero;
    }
    expect(soma, 6); // 1 + 2 + 3 = 6

    // map
    final duplicados = numeros.map((numero) => numero * 2).toList();
    expect(duplicados, [2, 4, 6]);

    // where
    final pares = numeros.where((numero) => numero % 2 == 0).toList();
    expect(pares, [2]);
  });
}
