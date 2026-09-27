import 'package:campus_swap/src/models/models.dart';
import 'package:campus_swap/src/providers.dart';
import 'package:campus_swap/src/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Listing _listing({
  String id = 'listing-1',
  String title = 'Calculus Textbook',
  double price = 45,
  ListingType type = ListingType.sale,
  List<String> imageUrls = const <String>[],
}) {
  return Listing(
    id: id,
    sellerId: 'seller-1',
    sellerName: 'Ada Lovelace',
    title: title,
    description: 'Gently used, no highlighting.',
    price: price,
    category: ListingCategory.textbooks,
    condition: ListingCondition.good,
    type: type,
    campus: 'Main Campus',
    imageUrls: imageUrls,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

// ListingCard is a ConsumerWidget (it watches whether the listing is
// favorited). Overriding currentUserProvider to null keeps favoriteProvider on
// its signed-out branch (an empty stream) so these render tests never touch
// Firebase.
Widget _wrap(Widget child) => ProviderScope(
  overrides: [currentUserProvider.overrideWithValue(null)],
  child: MaterialApp(home: Scaffold(body: child)),
);

void main() {
  testWidgets('BrandMark renders the wordmark', (tester) async {
    await tester.pumpWidget(_wrap(const BrandMark()));

    expect(find.text('CampusSwap'), findsOneWidget);
    expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
  });

  testWidgets('BrandMark compact hides the wordmark', (tester) async {
    await tester.pumpWidget(_wrap(const BrandMark(compact: true)));

    expect(find.text('CampusSwap'), findsNothing);
    expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
  });

  testWidgets('EmptyState shows its title and message', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const EmptyState(
          icon: Icons.inbox_outlined,
          title: 'Nothing here yet',
          message: 'Come back later',
        ),
      ),
    );

    expect(find.text('Nothing here yet'), findsOneWidget);
    expect(find.text('Come back later'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });

  testWidgets('ErrorState renders the retry action', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      _wrap(
        ErrorState(error: 'permission-denied', onRetry: () => retried = true),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retried, isTrue);
  });

  testWidgets('ListingCard shows title, price, condition and seller', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(ListingCard(listing: _listing())));

    expect(find.text('Calculus Textbook'), findsOneWidget);
    expect(find.text('KSh 45'), findsOneWidget);
    expect(find.text('Good'), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Free'), findsNothing);
  });

  testWidgets('ListingCard renders a free listing without a price', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(ListingCard(listing: _listing(price: 0, type: ListingType.free))),
    );

    expect(find.text('Free'), findsOneWidget);
  });

  testWidgets('ListingCard fires onTap when pressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(ListingCard(listing: _listing(), onTap: () => tapped = true)),
    );

    await tester.tap(find.byType(ListingCard));
    expect(tapped, isTrue);
  });
}
