import 'package:campus_swap/src/models/models.dart';
import 'package:campus_swap/src/widgets/app_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Listing _listing({double price = 45, ListingType type = ListingType.sale}) {
  return Listing(
    id: 'listing-1',
    sellerId: 'seller-1',
    sellerName: 'Ada Lovelace',
    title: 'Calculus Textbook',
    description: 'Gently used, no highlighting.',
    price: price,
    category: ListingCategory.textbooks,
    condition: ListingCondition.good,
    type: type,
    campus: 'Main Campus',
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('formatListingPrice', () {
    test('renders free listings as Free regardless of price', () {
      expect(
        formatListingPrice(_listing(price: 12, type: ListingType.free)),
        'Free',
      );
    });

    test('renders a whole-shilling currency amount', () {
      expect(formatListingPrice(_listing(price: 45)), 'KSh 45');
    });

    test('renders swap listings with their price', () {
      expect(
        formatListingPrice(_listing(price: 120, type: ListingType.swap)),
        'KSh 120',
      );
    });
  });

  group('formatRelativeDate', () {
    test('labels sub-minute times as just now', () {
      expect(
        formatRelativeDate(
          DateTime.now().subtract(const Duration(seconds: 20)),
        ),
        'just now',
      );
    });

    test('labels recent times in minutes and hours', () {
      expect(
        formatRelativeDate(DateTime.now().subtract(const Duration(minutes: 5))),
        '5m ago',
      );
      expect(
        formatRelativeDate(DateTime.now().subtract(const Duration(hours: 3))),
        '3h ago',
      );
    });

    test('labels times within a week in days', () {
      expect(
        formatRelativeDate(DateTime.now().subtract(const Duration(days: 3))),
        '3d ago',
      );
    });

    test('falls back to an absolute date for older items', () {
      final label = formatRelativeDate(
        DateTime.now().subtract(const Duration(days: 40)),
      );

      expect(label, isNot(contains('ago')));
    });
  });

  group('labelForEnum', () {
    test('humanizes camel-cased enum values', () {
      expect(labelForEnum(ListingCondition.likeNew), 'Like New');
      expect(labelForEnum(ListingCategory.textbooks), 'Textbooks');
      expect(labelForEnum(SwapStatus.pending), 'Pending');
    });

    test('maps newItem to New', () {
      expect(labelForEnum(ListingCondition.newItem), 'New');
    });
  });

  group('friendlyError', () {
    test('explains common auth failures', () {
      expect(
        friendlyError('FirebaseAuthException: email-already-in-use'),
        'That email is already registered.',
      );
      expect(
        friendlyError('FirebaseAuthException: invalid-credential'),
        'The email or password is incorrect.',
      );
      expect(
        friendlyError('FirebaseAuthException: weak-password'),
        'Choose a stronger password.',
      );
    });

    test('surfaces common Firestore failure codes', () {
      expect(
        friendlyError('[cloud_firestore/permission-denied] ...'),
        'Permission denied by the server. Your account may not be allowed to do this yet.',
      );
      expect(
        friendlyError('[cloud_firestore/failed-precondition] requires an index'),
        'The server is missing a database index for this request. Please try again shortly.',
      );
    });

    test('falls back to a generic message', () {
      expect(
        friendlyError('some unrecognized failure'),
        'We could not complete that action. Please try again.',
      );
    });
  });
}
