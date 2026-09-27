import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_theme.dart';
import '../providers.dart';
import '../widgets/app_widgets.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _university = TextEditingController();
  final _bio = TextEditingController();
  final _picker = ImagePicker();
  XFile? _newPhoto;
  String? _photoUrl;
  bool _busy = false;
  bool _loaded = false;

  @override
  void dispose() {
    _name.dispose();
    _university.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _hydrate() {
    if (_loaded) return;
    final profile = ref.read(profileProvider).value;
    if (profile == null) return;
    _name.text = profile.displayName;
    _university.text = profile.university;
    _bio.text = profile.bio ?? '';
    _photoUrl = profile.photoUrl;
    _loaded = true;
  }

  Future<void> _pickPhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (picked != null) setState(() => _newPhoto = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return;
    setState(() => _busy = true);
    try {
      var photoUrl = _photoUrl;
      if (_newPhoto != null) {
        photoUrl = await ref
            .read(storageRepositoryProvider)
            .uploadProfileImage(uid: uid, file: File(_newPhoto!.path));
      }
      await ref
          .read(authRepositoryProvider)
          .updateProfile(
            uid,
            displayName: _name.text,
            university: _university.text,
            bio: _bio.text,
            photoUrl: photoUrl,
          );
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Profile updated.')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _hydrate();
    final preview = _newPhoto != null
        ? FileImage(File(_newPhoto!.path))
        : (_photoUrl != null ? NetworkImage(_photoUrl!) : null)
              as ImageProvider?;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.teal.withValues(alpha: .12),
                    backgroundImage: preview,
                    child: preview == null
                        ? const Icon(Icons.person_rounded, size: 44)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton.filled(
                      onPressed: _pickPhoto,
                      icon: const Icon(Icons.camera_alt_rounded, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) => value == null || value.trim().length < 2
                  ? 'Enter your name'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _university,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'University or college',
                prefixIcon: Icon(Icons.school_outlined),
              ),
              validator: (value) => value == null || value.trim().length < 2
                  ? 'Enter your campus'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _bio,
              maxLines: 3,
              maxLength: 160,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Bio (optional)',
                hintText: 'Tell other students a little about you.',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _busy ? null : _save,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
