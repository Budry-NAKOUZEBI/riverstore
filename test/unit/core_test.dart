import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/core/formatters.dart';
import 'package:riverstore/src/core/text_utils.dart';
import 'package:riverstore/src/core/validators.dart';
import 'package:riverstore/src/ui/widgets/product_image.dart';

void main() {
  group('normalizeForSearch', () {
    test('lowercases, trims and strips French diacritics', () {
      expect(normalizeForSearch("  Kit d'Éclairage "), "kit d'eclairage");
      expect(normalizeForSearch('Œuvre à Noël'), 'oeuvre a noel');
    });
  });

  group('formatPrice (francs CFA)', () {
    test('French: space-grouped thousands, no decimals, FCFA suffix', () {
      expect(formatPrice(1234500, 'fr'), '1 234 500 FCFA');
      expect(formatPrice(18000, 'fr'), '18 000 FCFA');
    });

    test('English: comma-grouped thousands', () {
      expect(formatPrice(1234500, 'en'), '1,234,500 FCFA');
      expect(formatPrice(0, 'en'), '0 FCFA');
    });

    test('never uses the narrow no-break space missing from app fonts', () {
      expect(formatPrice(250000, 'fr').contains(' '), isFalse);
    });
  });

  group('Validators', () {
    test('required rejects null, empty and blank values', () {
      expect(Validators.required(null), ValidationError.required);
      expect(Validators.required('   '), ValidationError.required);
      expect(Validators.required('ok'), isNull);
    });

    test('fullName needs at least two characters', () {
      expect(Validators.fullName('A'), ValidationError.tooShort);
      expect(Validators.fullName('Al'), isNull);
    });

    test('phone accepts Congolese mobile numbers (MTN 06, Airtel 04/05)', () {
      expect(Validators.phone('06 612 34 56'), isNull);
      expect(Validators.phone('055123456'), isNull);
      expect(Validators.phone('04-412-34-56'), isNull);
      expect(Validators.phone('+242 06 612 34 56'), isNull);
      expect(Validators.phone('00242 05 512 34 56'), isNull);
    });

    test('phone rejects other formats', () {
      expect(Validators.phone('07 612 34 56'), ValidationError.invalidPhone);
      expect(Validators.phone('06 612 34'), ValidationError.invalidPhone);
      expect(
        Validators.phone('+243 81 234 5678'),
        ValidationError.invalidPhone,
      );
      expect(Validators.phone(''), ValidationError.required);
    });
  });

  group('ProductImage.decodeWidthFor', () {
    test('decodes at the displayed size, rounded up to 100 px buckets', () {
      expect(ProductImage.decodeWidthFor(160, 2.75), 500); // 440 -> 500
      expect(ProductImage.decodeWidthFor(200, 2), 400);
    });

    test('returns null for unbounded or empty constraints', () {
      expect(ProductImage.decodeWidthFor(double.infinity, 2), isNull);
      expect(ProductImage.decodeWidthFor(0, 2), isNull);
    });
  });
}
