import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:test/test.dart';

void main() {
  group('PhoneNumberParser', () {
    test('should find phone number in text', () {
      final f = PhoneNumberParser.findPotentialPhoneNumbers;
      expect(f('+49024443343').isEmpty, equals(false));
      expect(f('0049024443').isEmpty, equals(false));
      expect(f('(+49 02.44/433-43)').isEmpty, equals(false));
      expect(f('＋۹۹۹۹۹9۹').isEmpty, equals(false));
      expect(f('＋9nothing here').isEmpty, equals(true));
      expect(
        f(
          'Hello, my phone number is: +49024443343.',
        ).first.group(0),
        equals('+49024443343'),
      );
      expect(
        f('Try +49024443343 or +83443829').toList().length,
        equals(2),
      );
    });

    test('should normalize', () {
      expect(PhoneNumberParser.normalize('(+49 02.44/433-43)'),
          equals('+49024443343'));
      expect(PhoneNumberParser.normalize('＋۹۹۹۹'), equals('+9999'));
    });

    test('should parse raw phone number', () {
      final french = PhoneNumberParser.parse('+33 0466 46 46 46');
      final us = PhoneNumberParser.parse('+1-202-555-0183');
      final us2 = PhoneNumberParser.parse('011 1-202-555-0183');
      // not the main country for dial code
      final canada =
          PhoneNumberParser.parse('+1-613-555-0180', Country.fromIsoCode('CA'));
      expect(french.country.isoCode, equals('FR'));
      expect(french.nationalNumber, equals('466464646'));
      expect(french.dialCode, equals('33'));

      expect(us.country.isoCode, equals('US'));
      expect(us.nationalNumber, equals('2025550183'));
      expect(us.dialCode, equals('1'));

      expect(us2.country.isoCode, equals('US'));
      expect(us2.nationalNumber, equals('2025550183'));
      expect(us2.dialCode, equals('1'));

      expect(canada.country.isoCode, equals('CA'));
      expect(canada.nationalNumber, equals('6135550180'));
      expect(canada.dialCode, equals('1'));
    });

    test('should parse national number', () {
      final france = Country.fromIsoCode('fr');
      // with a transform rule
      final anguilla = Country.fromIsoCode('AI');
      expect(PhoneNumberParser.parseNationalNumber('0423322223', france),
          equals('423322223'));
      // with a transform rule it adds 264 in the front
      expect(PhoneNumberParser.parseNationalNumber('433 3555', anguilla),
          equals('2644333555'));
    });
  });
}