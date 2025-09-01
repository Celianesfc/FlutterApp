import 'package:flutter_test/flutter_test.dart';

bool isPerfect(int num) {
  if (num < 1) return false;
  int sum = 0;
  for (int i = 1; i <= num ~/ 2; i++) {
    if (num % i == 0) {
      sum += i;
    }
  }
  return sum == num;
}

int factorial(int n) {
  if (n < 0) throw ArgumentError('Número deve ser não negativo.');
  int result = 1;
  int i = n;
  while (i > 1) {
    result *= i;
    i--;
  }
  return result;
}

// math_utils.dart

bool isPrime(int number) {
  if (number <= 1) {
    return false;
  }
  for (int i = 2; i * i <= number; i++) {
    if (number % i == 0) {
      return false;
    }
  }
  return true;
}

int sumOfDigits(int number) {
  if (number < 0) {
    throw ArgumentError('Error: The number must be non-negative.');
  }
  
  int sum = 0;
  String numberAsString = number.toString();
  for (int i = 0; i < numberAsString.length; i++) {
    sum += int.parse(numberAsString[i]);
  }
  return sum;
}

void main() {
  group('Testes de Número perfeito', () {
    test('Número perfeito 6', () {
      expect(isPerfect(6), isTrue);
    });

    test('Número negativo não deve ser perfeito', () {
      expect(isPerfect(-6), isFalse);
    });
  });
  group('Testes de Fatorial', () {
    test('Fatorial de 5', () {
      expect(factorial(5), 120);
    });

    test('Fatorial de número negativo deve lançar erro', () {
      expect(() => factorial(-3), throwsArgumentError);
    });
  });

  group('Testes de Número Primo', () {
    test('Número primo 7', () {
      expect(isPrime(7), isTrue);
    });

    test('Número não primo 10', () {
      expect(isPrime(10), isFalse);
    });
    
    test('Número primo 2', () {
      expect(isPrime(2), isTrue);
    });
    
    test('Número negativo', () {
      expect(isPrime(-5), isFalse);
    });
  });

  group('Testes de Soma dos Dígitos', () {
    test('Soma dos dígitos de 123', () {
      expect(sumOfDigits(123), equals(6));
    });

    test('Soma dos dígitos de 4567', () {
      expect(sumOfDigits(4567), equals(22));
    });

    test('Soma dos dígitos de 0', () {
      expect(sumOfDigits(0), equals(0));
    });
    
    test('Soma dos dígitos de -1', () {
      expect(() => sumOfDigits(-1), throwsA(isA<ArgumentError>()));
    });
     });
}
