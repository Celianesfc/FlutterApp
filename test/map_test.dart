
import 'package:flutter_test/flutter_test.dart';

void main() {
  // A função setUp garante que cada teste comece com um estado limpo.
  late Map<String, List<double>> alunos;

  setUp(() {
    alunos = {
      'Maria': [8.0, 9.0],
      'Bruna': [7.0, 7.0],
      'Carla': [10.0, 9.0],
    };
  });

  test('Adicionar elemento se ausente', () {
    // putIfAbsent só adiciona se a chave não existir
    alunos.putIfAbsent('Elena', () => [9.0, 8.0]);
    expect(alunos.containsKey('Elena'), isTrue);
    expect(alunos['Elena'], [9.0, 8.0]);
    expect(alunos.length, 4);

    // Não deve modificar se a chave já existe
    alunos.putIfAbsent('Maria', () => [5.0, 5.0]);
    expect(alunos['Maria'], [8.0, 9.0]);
  });

  test('Adicionar todos os elementos de outro mapa', () {
    alunos.addAll({
      'Luiza': [8.0, 9.0],
      'Ana': [9.5, 9.5],
    });
    expect(alunos.containsKey('Luiza'), isTrue);
    expect(alunos.containsKey('Ana'), isTrue);
    expect(alunos.length, 5);

    // Se a chave já existir, o valor é sobrescrito
    alunos.addAll({'Bruna': [8.0, 8.0]});
    expect(alunos['Bruna'], [8.0, 8.0]);
  });

  test('Remover elemento', () {
    final notasRemovidas = alunos.remove('Bruna');
    expect(alunos.containsKey('Bruna'), isFalse);
    expect(notasRemovidas, [7.0, 7.0]);
    expect(alunos.length, 2);
  });

  test('Atualizar elemento', () {
    // Atualiza o valor para a chave 'Carla'
    alunos.update('Carla', (value) => value.map((nota) => nota - 1).toList());
    expect(alunos['Carla'], [9.0, 8.0]);

    // Usando o operador [] é mais direto para sobrescrever
    alunos['Maria'] = [10.0, 10.0];
    expect(alunos['Maria'], [10.0, 10.0]);
  });

  test('Testar percorrer dicionário', () {
    // As chaves, valores e o mapa como um todo
    expect(alunos.keys, unorderedEquals(['Maria', 'Bruna', 'Carla']));
    expect(alunos.values, unorderedEquals([
      [8.0, 9.0],
      [7.0, 7.0],
      [10.0, 9.0],
    ]));

    // forEach para iterar
    double somaTotal = 0;
    alunos.forEach((key, value) {
      final somaNotas = value.reduce((a, b) => a + b);
      somaTotal += somaNotas;
    });
    // (8+9) + (7+7) + (10+9) = 17 + 14 + 19 = 50
    expect(somaTotal, 50.0);
  });
}
