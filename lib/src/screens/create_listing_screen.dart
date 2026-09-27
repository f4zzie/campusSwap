import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../providers.dart';
import '../widgets/app_widgets.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key, this.listingId});

  final String? listingId;

  @override
  ConsumerState<CreateListingScreen> createState() =>
      _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _campus = TextEditingController();
  final _author = TextEditingController();
  final _course = TextEditingController();
  final _isbn = TextEditingController();
  final _picker = ImagePicker();
  final _uuid = const Uuid();
  final _images = <XFile>[];
  static const _maxImages = 5;
  ListingCategory _category = ListingCategory.textbooks;
  ListingCondition _condition = ListingCondition.good;
  ListingType _type = ListingType.sale;
  bool _busy = false;
  bool _loadingEdit = false;
  Listing? _editing;

  @override
  void initState() {
    super.initState();
    if (widget.listingId != null) _loadListing();
  }

  Future<void> _loadListing() async {
    setState(() => _loadingEdit = true);
    final listing = await ref
        .read(firestoreRepositoryProvider)
        .getListing(widget.listingId!);
    if (!mounted || listing == null) return;
    _editing = listing;
    _title.text = listing.title;
    _description.text = listing.description;
    _price.text = listing.price == 0 ? '' : listing.price.toStringAsFixed(0);
    _campus.text = listing.campus;
    _author.text = listing.author ?? '';
    _course.text = listing.courseCode ?? '';
    _isbn.text = listing.isbn ?? '';
    setState(() {
      _category = listing.category;
      _condition = listing.condition;
      _type = listing.type;
      _loadingEdit = false;
    });
  }

  @override
  void dispose() {
    for (final controller in [
      _title,
      _description,
      _price,
      _campus,
      _author,
      _course,
      _isbn,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(
      imageQuality: 80,
      maxWidth: 1600,
    );
    if (picked.isNotEmpty) {
      setState(() => _images.addAll(picked.take(_maxImages - _images.length)));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_editing == null && _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Add at least one photo so buyers know what to expect.',
          ),
        ),
      );
      return;
    }
    final user = ref.read(firebaseAuthProvider).currentUser;
    final profile = ref.read(profileProvider).value;
    if (user == null || profile == null) return;
    setState(() => _busy = true);
    try {
      final now = DateTime.now();
      final id = _editing?.id ?? _uuid.v4();
      final uploaded = _images.isEmpty
          ? <String>[]
          : await ref
                .read(storageRepositoryProvider)
                .uploadListingImages(
                  uid: user.uid,
                  listingId: id,
                  files: _images.map((image) => File(image.path)).toList(),
                );
      final listing = Listing(
        id: id,
        sellerId: user.uid,
        sellerName: profile.displayName,
        sellerPhoto: profile.photoUrl,
        title: _title.text.trim(),
        description: _description.text.trim(),
        price: _type == ListingType.free ? 0 : double.parse(_price.text),
        category: _category,
        condition: _condition,
        type: _type,
        campus: _campus.text.trim(),
        author: _author.text.trim().isEmpty ? null : _author.text.trim(),
        courseCode: _course.text.trim().isEmpty ? null : _course.text.trim(),
        isbn: _isbn.text.trim().isEmpty ? null : _isbn.text.trim(),
        favoriteCount: _editing?.favoriteCount ?? 0,
        imageUrls: [...?_editing?.imageUrls, ...uploaded],
        status: _editing?.status ?? ListingStatus.active,
        createdAt: _editing?.createdAt ?? now,
        updatedAt: now,
        searchKeywords: _keywords(),
        viewCount: _editing?.viewCount ?? 0,
      );
      if (_editing == null) {
        await ref.read(firestoreRepositoryProvider).createListing(listing);
      } else {
        await ref.read(firestoreRepositoryProvider).updateListing(listing);
      }
      if (mounted) {
        ref.invalidate(myListingsProvider);
        ref.invalidate(listingFeedProvider);
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editing == null ? 'Your listing is live.' : 'Listing updated.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  List<String> _keywords() {
    return '${_title.text} ${_description.text} ${_author.text} ${_course.text} ${_isbn.text} ${_campus.text}'
        .toLowerCase()
        .split(RegExp(r'[^a-z0-9]+'))
        .where((word) => word.length > 1)
        .toSet()
        .toList();
  }

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label is required' : null;

  @override
  Widget build(BuildContext context) {
    if (_loadingEdit)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final editing = _editing != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit listing' : 'Sell an item')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
          children: [
            Text(
              'Show it off',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 5),
            Text(
              'Clear photos and details help your item find the right student.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount:
                    _images.length + (_images.length < _maxImages ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, index) {
                  if (index == _images.length)
                    return _AddPhotoButton(onTap: _pickImages);
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_images[index].path),
                          width: 112,
                          height: 112,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton.filled(
                          onPressed: () =>
                              setState(() => _images.removeAt(index)),
                          icon: const Icon(Icons.close_rounded, size: 17),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(30, 30),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (editing && _images.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Existing photos will be kept. Add more above if needed.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 22),
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 70,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g. Calculus textbook, barely used',
              ),
              validator: (value) => value == null || value.trim().length < 3
                  ? 'Title must be at least 3 characters'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _author,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Author (optional)',
                hintText: 'For textbooks — e.g. Cormen, Stroustrup',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Share condition, pickup details, and anything buyers should know.',
              ),
              validator: (value) => value == null || value.trim().length < 15
                  ? 'Add a little more detail'
                  : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ListingCategory>(
                    initialValue: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: ListingCategory.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(labelForEnum(value)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _category = value!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<ListingCondition>(
                    initialValue: _condition,
                    decoration: const InputDecoration(labelText: 'Condition'),
                    items: ListingCondition.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(labelForEnum(value)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _condition = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ListingType>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'How do you want to trade?',
              ),
              items: ListingType.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(labelForEnum(value)),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _type = value!),
            ),
            if (_type != ListingType.free) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: 'KSh ',
                ),
                validator: (value) {
                  if (_type == ListingType.free) return null;
                  final price = double.tryParse(value ?? '');
                  return price == null || price < 0
                      ? 'Enter a valid price'
                      : null;
                },
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _campus,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Campus / pickup area',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (value) => _required(value, 'Campus'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _course,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Course code (optional)',
                hintText: 'e.g. BIO 101',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _isbn,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ISBN (optional)',
                prefixIcon: Icon(Icons.qr_code_2_rounded),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 53,
              child: FilledButton.icon(
                onPressed: _busy ? null : _submit,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.publish_rounded),
                label: Text(
                  _busy
                      ? 'Publishing...'
                      : editing
                      ? 'Save changes'
                      : 'Publish listing',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  const _AddPhotoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined),
            SizedBox(height: 5),
            Text('Add photos'),
          ],
        ),
      ),
    );
  }
}
