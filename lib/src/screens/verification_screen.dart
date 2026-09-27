import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers.dart';
import '../widgets/app_widgets.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  bool _sending = false;
  bool _checking = false;

  Future<void> _send() async {
    setState(() => _sending = true);
    try {
      await ref.read(authRepositoryProvider).resendVerification();
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent.')),
        );
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _check() async {
    setState(() => _checking = true);
    try {
      await ref.read(firebaseAuthProvider).currentUser?.reload();
      final verified =
          ref.read(firebaseAuthProvider).currentUser?.emailVerified ?? false;
      if (!mounted) return;
      if (verified) {
        // reload() does not fire authStateChanges, so the router's refresh
        // listener never wakes on its own. Nudging the router re-runs its
        // redirect, which now sees emailVerified == true and moves the user
        // on — to /onboarding if the campus is still blank, else /home.
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Not verified yet. Tap the link in your email, then try again.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(friendlyError(error))));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BrandMark(),
                const SizedBox(height: 46),
                const Icon(Icons.mark_email_read_outlined, size: 78),
                const SizedBox(height: 24),
                Text(
                  'Check your inbox',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  'We sent a verification link to ${ref.read(firebaseAuthProvider).currentUser?.email ?? 'your email'}. Verify it to start trading safely.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _checking ? null : _check,
                    child: _checking
                        ? const SizedBox(
                            width: 21,
                            height: 21,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('I verified my email'),
                  ),
                ),
                TextButton(
                  onPressed: _sending ? null : _send,
                  child: Text(_sending ? 'Sending...' : 'Resend email'),
                ),
                TextButton(
                  onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  child: const Text('Use a different account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
