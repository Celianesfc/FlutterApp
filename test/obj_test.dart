import 'package:flutter_test/flutter_test.dart';

abstract class Pessoa {
  int? _id;
  String nome;

  Pessoa(this.nome);

  int? get id => _id;

  set id(int? id) {
    if (id != null && id <= 0) {
      throw ArgumentError('Identificador deve ser um número positivo.');
    }
    _id = id;
  }
}

mixin Ano {
  int? _ano;

  int? get ano => _ano;

  set ano(int? ano) {
    if (ano != null && ano <= 0) {
      throw ArgumentError('Ano deve ser um número positivo.');
    }
    _ano = ano;
  }
}

class Aluno extends Pessoa with Ano {
  Aluno(super.nome, int ano) {
    this.ano = ano;
  }
}

class Disciplina {
  String nome;
  Disciplina(this.nome);
}

class Professor extends Pessoa {
  final List<Disciplina> disciplinas;
  Professor(super.nome, this.disciplinas);
}

class Turma with Ano {
  Disciplina disciplina;
  Professor professor;
  final List<Aluno> _alunos = [];

  Turma(this.disciplina, this.professor, int ano) {
    this.ano = ano;
    if (!professor.disciplinas.any((d) => d.nome == disciplina.nome)) {
      throw ArgumentError('Professor ${professor.nome} não leciona a disciplina ${disciplina.nome}.');
    }
  }

  void matricular(Aluno aluno) {
    if (aluno.ano == ano) {
      _alunos.add(aluno);
    } else {
      throw ArgumentError('O ano do aluno (${aluno.ano}) deve ser o mesmo da turma ($ano).');
    }
  }
  
  List<Aluno> get alunos => _alunos;
}

class Historico extends Turma {
  Map<Aluno, List<double>> notas = {};

  Historico(super.disciplina, super.professor, super.ano);

  @override
  void matricular(Aluno aluno) {
    super.matricular(aluno);
    notas[aluno] = [];
  }

  void adicionarNota(Aluno aluno, double nota) {
    if (!notas.containsKey(aluno)) {
      throw ArgumentError('O aluno ${aluno.nome} não está matriculado nesta turma.');
    }
    if (nota < 0.0 || nota > 10.0) {
      throw ArgumentError('A nota deve estar entre 0.0 e 10.0.');
    }
    notas[aluno]!.add(nota);
  }

  double media(Aluno aluno) {
    final notasAluno = notas[aluno];
    if (notasAluno == null || notasAluno.isEmpty) {
      return 0.0;
    }
    final soma = notasAluno.reduce((a, b) => a + b);
    return soma / notasAluno.length;
  }

  bool isAprovado(Aluno aluno) {
    return media(aluno) >= 7.0;
  }
}

// BOA PRÁTICA APLICADA: Usando setUp para garantir o isolamento dos testes.
void main() {
  group('Testes de Domínio', () {
    late Disciplina disciplinaFlutter;
    late Disciplina disciplinaDart;
    late Professor professor;
    late Aluno aluno1;
    late Aluno aluno2;
    late Aluno alunoAnoDiferente;

    setUp(() {
      disciplinaFlutter = Disciplina('Flutter');
      disciplinaDart = Disciplina('Dart');
      professor = Professor('Van Helsing', [disciplinaFlutter, disciplinaDart]);
      aluno1 = Aluno('Maria', 2023)..id = 1;
      aluno2 = Aluno('João', 2023)..id = 2;
      alunoAnoDiferente = Aluno('Paula', 2022)..id = 3;
    });

    test('Deve criar um professor e validar suas disciplinas', () {
      expect(professor.nome, 'Van Helsing');
      expect(professor.disciplinas.length, 2);
      expect(professor.disciplinas.first.nome, 'Flutter');
    });

    test('Não deve permitir criar turma com professor que não leciona a disciplina', () {
      final disciplinaPython = Disciplina('Python');
      expect(
        () => Turma(disciplinaPython, professor, 2023),
        throwsArgumentError,
      );
    });

    test('Deve matricular alunos na turma e no histórico', () {
      final historico = Historico(disciplinaFlutter, professor, 2023);
      historico.matricular(aluno1);
      
      expect(historico.alunos.contains(aluno1), isTrue);
      expect(historico.notas.containsKey(aluno1), isTrue);
    });

    test('Não deve matricular aluno com ano diferente da turma', () {
      final historico = Historico(disciplinaFlutter, professor, 2023);
      expect(
        () => historico.matricular(alunoAnoDiferente),
        throwsArgumentError,
      );
    });

    test('Deve adicionar notas e calcular a média corretamente', () {
      final historico = Historico(disciplinaFlutter, professor, 2023);
      historico.matricular(aluno1);
      
      expect(historico.media(aluno1), 0.0);
      
      historico.adicionarNota(aluno1, 8.5);
      historico.adicionarNota(aluno1, 9.5);
      
      expect(historico.media(aluno1), 9.0);
      
      historico.matricular(aluno2);
      historico.adicionarNota(aluno2, 7.0);
      expect(historico.media(aluno2), 7.0);
    });

    test('Deve verificar a aprovação do aluno', () {
      final historico = Historico(disciplinaFlutter, professor, 2023);
      historico.matricular(aluno1); // Média 0.0 -> Reprovado
      expect(historico.isAprovado(aluno1), isFalse);

      historico.adicionarNota(aluno1, 10.0);
      historico.adicionarNota(aluno1, 8.0); // Média 9.0 -> Aprovado
      expect(historico.isAprovado(aluno1), isTrue);

      historico.matricular(aluno2);
      historico.adicionarNota(aluno2, 6.0);
      historico.adicionarNota(aluno2, 7.0); // Média 6.5 -> Reprovado
      expect(historico.isAprovado(aluno2), isFalse);
    });

    test('Deve lançar erro ao tentar adicionar nota para aluno não matriculado', () {
      final historico = Historico(disciplinaFlutter, professor, 2023);
      expect(
        () => historico.adicionarNota(aluno1, 10.0),
        throwsArgumentError,
      );
    });

    test('Deve validar IDs e anos não negativos ou nulos', () {
      expect(() => aluno1.id = -1, throwsArgumentError);
      expect(() => aluno1.id = 0, throwsArgumentError);
      expect(() => aluno1.ano = -2023, throwsArgumentError);
      
      aluno1.id = null;
      expect(aluno1.id, isNull);
    });
  });
}
