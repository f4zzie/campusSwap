import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';
import '../providers.dart';
import '../widgets/app_widgets.dart';
import 'home_shell.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  String _query = '';
  ListingCategory? _category;
  ListingType? _type;
  ListingCondition? _condition;
  double? _minPrice;
  double? _maxPrice;
  String _sort = 'Newest';

  bool get _hasFilters =>
      _category != null ||
      _type != null ||
      _condition != null ||
      _minPrice != null ||
      _maxPrice != null;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 400) {
        ref.read(listingFeedProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  List<Listing> _filtered(List<Listing> listings) {
    final filtered = listings.where((listing) {
      final matchesQuery =
          _query.isEmpty ||
          [
            listing.title,
            listing.description,
            listing.campus,
            listing.author ?? '',
            listing.courseCode ?? '',
            listing.isbn ?? '',
            ...listing.searchKeywords,
          ].join(' ').toLowerCase().contains(_query.toLowerCase());
      return matchesQuery &&
          (_category == null || listing.category == _category) &&
          (_type == null || listing.type == _type) &&
          (_condition == null || listing.condition == _condition) &&
          (_minPrice == null || listing.price >= _minPrice!) &&
          (_maxPrice == null || listing.price <= _maxPrice!);
    }).toList();
    switch (_sort) {
      case 'Oldest':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case 'Price: low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case 'Price: high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
      default:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return filtered;
  }

  Future<void> _toggleFavorite(Listing listing) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return;
    final saved = await ref
        .read(favoriteProvider(listing.id).future)
        .catchError((_) => false);
    await ref
        .read(firestoreRepositoryProvider)
        .setFavorite(uid, listing.id, !saved);
  }

  void _openFilters() {
    var category = _category;
    var type = _type;
    var condition = _condition;
    var sort = _sort;
    final minController = TextEditingController(
      text: _minPrice == null ? '' : _minPrice!.toStringAsFixed(0),
    );
    final maxController = TextEditingController(
      text: _maxPrice == null ? '' : _maxPrice!.toStringAsFixed(0),
    );
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 30,
        ),
        child: StatefulBuilder(
          builder: (context, setSheetState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Refine your search',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<ListingCategory?>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All categories'),
                    ),
                    ...ListingCategory.values.map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(labelForEnum(value)),
                      ),
                    ),
                  ],
                  onChanged: (value) => setSheetState(() => category = value),
                ),
                const SizedBox(height: 13),
                DropdownButtonFormField<ListingType?>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Listing type'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Sale, swap, or free'),
                    ),
                    ...ListingType.values.map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(labelForEnum(value)),
                      ),
                    ),
                  ],
                  onChanged: (value) => setSheetState(() => type = value),
                ),
                const SizedBox(height: 13),
                DropdownButtonFormField<ListingCondition?>(
                  initialValue: condition,
                  decoration: const InputDecoration(labelText: 'Condition'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Any condition'),
                    ),
                    ...ListingCondition.values.map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(labelForEnum(value)),
                      ),
                    ),
                  ],
                  onChanged: (value) => setSheetState(() => condition = value),
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Min price',
                          prefixText: 'KSh ',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: maxController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max price',
                          prefixText: 'KSh ',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                DropdownButtonFormField<String>(
                  initialValue: sort,
                  decoration: const InputDecoration(labelText: 'Sort by'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Newest',
                      child: Text('Newest first'),
                    ),
                    DropdownMenuItem(
                      value: 'Oldest',
                      child: Text('Oldest first'),
                    ),
                    DropdownMenuItem(
                      value: 'Price: low',
                      child: Text('Price: lowest first'),
                    ),
                    DropdownMenuItem(
                      value: 'Price: high',
                      child: Text('Price: highest first'),
                    ),
                  ],
                  onChanged: (value) => setSheetState(() => sort = value!),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _category = null;
                            _type = null;
                            _condition = null;
                            _minPrice = null;
                            _maxPrice = null;
                            _sort = 'Newest';
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Clear all'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _category = category;
                            _type = type;
                            _condition = condition;
                            _minPrice = double.tryParse(minController.text);
                            _maxPrice = double.tryParse(maxController.text);
                            _sort = sort;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      minController.dispose();
      maxController.dispose();
    });
  }

  /// A time-of-day greeting for the dashboard header. Recomputed on every
  /// build, so it tracks the device clock rather than being fixed at launch.
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(listingFeedProvider);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.read(listingFeedProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(
                child: PageHeader(
                  title: _greeting,
                  subtitle: 'Find something useful for your semester.',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 2),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: _search,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Search textbooks, tech, dorm finds...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      onPressed: _openFilters,
                      icon: Icon(
                        _hasFilters ? Icons.tune_rounded : Icons.tune_outlined,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 5),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ListingCategory.values.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final category = index == 0
                          ? null
                          : ListingCategory.values[index - 1];
                      return ChoiceChip(
                        label: Text(
                          category == null
                              ? 'All items'
                              : labelForEnum(category),
                        ),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (feed.status.isLoading && feed.items.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (feed.status.hasError && feed.items.isEmpty)
              SliverFillRemaining(
                child: ErrorState(
                  error: feed.status.error!,
                  onRetry: () =>
                      ref.read(listingFeedProvider.notifier).refresh(),
                ),
              )
            else
              ..._buildResults(_filtered(feed.items), feed),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResults(List<Listing> visible, ListingFeedState feed) {
    if (visible.isEmpty) {
      return const [
        SliverFillRemaining(
          child: EmptyState(
            icon: Icons.search_off_rounded,
            title: 'No matches yet',
            message: 'Try a different search or clear your filters.',
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
        sliver: SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: .58,
          ),
          itemCount: visible.length,
          itemBuilder: (_, index) {
            final listing = visible[index];
            return ListingCard(
              listing: listing,
              onTap: () => context.push('/home/listing/${listing.id}'),
              onFavorite: () => _toggleFavorite(listing),
            );
          },
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          child: Center(
            child: feed.loadingMore
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    feed.hasMore
                        ? 'Scroll for more'
                        : "You've reached the end.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
          ),
        ),
      ),
    ];
  }
}
