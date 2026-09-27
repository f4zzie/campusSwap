import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../widgets/app_widgets.dart';

/// Collects the one detail a Google sign-up can't provide.
///
/// Google returns a name, email and photo but never a university, so a student
/// who signs up with Google lands here with an empty `university`. The router
/// (see `app.dart`) sends any verified account whose profile still has a blank
/// campus to this screen, and routes it back out to `/home` the instant the
/// campus is filled in — so there is no manual navigation to do on save.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _university = TextEditingController();
  bool _busy = false;
  bool _loaded = false;

  @override
  void dispose() {
    _name.dispose();
    _university.dispose();
    super.dispose();
  }

  void _hydrate() {
    if (_loaded) return;
    final profile = ref.read(profileProvider).value;
    if (profile == null) return;
    // Google usually gives us a real name; only blank it when it fell back to
    // the 'Student' placeholder so the student isn't asked to retype it.
    _name.text = profile.displayName == 'Student' ? '' : profile.displayName;
    _university.text = profile.university;
    _loaded = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .updateProfile(
            uid,
            displayName: _name.text,
            university: _university.text,
          );
      // No context.pop / go here: once the profile stream reports a non-empty
      // university the router redirect carries us to /home automatically.
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 42, 24, 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BrandMark(),
                    const SizedBox(height: 42),
                    Text(
                      'One more thing.',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Tell us your campus so we can connect you with the right '
                      'marketplace.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _name,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Your name',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: (value) =>
                                  value == null || value.trim().length < 2
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
                              validator: (value) =>
                                  value == null || value.trim().length < 2
                                  ? 'Enter your campus'
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton(
                                onPressed: _busy ? null : _save,
                                child: _busy
                                    ? const SizedBox(
                                        width: 21,
                                        height: 21,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Enter CampusSwap'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: _busy
                            ? null
                            : () => ref.read(authRepositoryProvider).signOut(),
                        child: const Text('Not you? Sign out'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
