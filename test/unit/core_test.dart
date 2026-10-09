import 'package:flutter_test/flutter_test.dart';
import 'package:riverstore/src/core/formatters.dart';
import 'package:riverstore/src/core/text_utils.dart';
import 'package:riverstore/src/core/validators.dart';
import 'package:riverstore/src/ui/widgets/product_image.dart';

void main() {
  group('normalizeForSearch', () {
    test('lowercases, trims and strips French diacritics', () {
      expect(normalizeForSearch('  Écran Incurvé '), 'ecran incurve');
      expect(normalizeForSearch('Œuvre à Noël'), 'oeuvre a noel');
    });
  });

  group('formatPrice', () {
    test('uses French conventions (comma, non-breaking spaces, € suffix)', () {
      expect(formatPrice(123456, 'fr'), '1 234,56 €');
      expect(formatPrice(5990, 'fr'), '59,90 €');
    });

    test('uses English conventions (€ prefix, dot decimal)', () {
      expect(formatPrice(123456, 'en'), '€1,234.56');
      expect(formatPrice(0, 'en'), '€0.00');
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

    test('email accepts valid addresses and rejects malformed ones', () {
      expect(Validators.email('camille@example.com'), isNull);
      expect(Validators.email(' camille@example.fr '), isNull);
      expect(Validators.email('camille@example'), ValidationError.invalidEmail);
      expect(
        Validators.email('camille example.com'),
        ValidationError.invalidEmail,
      );
      expect(Validators.email(''), ValidationError.required);
    });

    test('postalCode requires exactly five digits', () {
      expect(Validators.postalCode('75011'), isNull);
      expect(Validators.postalCode('7501'), ValidationError.invalidPostalCode);
      expect(Validators.postalCode('75O11'), ValidationError.invalidPostalCode);
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
