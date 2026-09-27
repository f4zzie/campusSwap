import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/app_theme.dart';
import 'providers.dart';
import 'screens/auth_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/create_listing_screen.dart';
import 'screens/home_shell.dart';
import 'screens/listing_detail_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/swap_screen.dart';
import 'screens/verification_screen.dart';

class CampusSwapApp extends ConsumerStatefulWidget {
  const CampusSwapApp({super.key});

  @override
  ConsumerState<CampusSwapApp> createState() => _CampusSwapAppState();
}

class _CampusSwapAppState extends ConsumerState<CampusSwapApp> {
  late final GoRouter _router;
  late final AuthRefreshNotifier _refresh;

  @override
  void initState() {
    super.initState();
    _refresh = AuthRefreshNotifier(FirebaseAuth.instance.authStateChanges());
    _router = _buildRouter();
  }

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/home',
      refreshListenable: _refresh,
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        final location = state.matchedLocation;
        final isAuthRoute = location == '/auth';
        final isVerifyRoute = location == '/verify';
        final isOnboardingRoute = location == '/onboarding';
        if (user == null) return isAuthRoute ? null : '/auth';
        if (!user.emailVerified) return isVerifyRoute ? null : '/verify';
        // Signed in and verified. A Google sign-up reaches this point with no
        // campus (Google never supplies one), so hold it at onboarding until
        // the student fills it in. Only act once the profile has loaded, so a
        // user we simply haven't read back yet isn't bounced by mistake.
        final profile = ref.read(profileProvider);
        final needsCampus =
            profile.hasValue &&
            profile.value != null &&
            profile.value!.university.trim().isEmpty;
        if (needsCampus) return isOnboardingRoute ? null : '/onboarding';
        if (isAuthRoute || isVerifyRoute || isOnboardingRoute) return '/home';
        return null;
      },
      routes: [
        GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
        GoRoute(path: '/verify', builder: (_, _) => const VerificationScreen()),
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (_, _) => const HomeShell(),
          routes: [
            GoRoute(
              path: 'listing/:id',
              builder: (_, state) =>
                  ListingDetailScreen(listingId: state.pathParameters['id']!),
            ),
            GoRoute(
              path: 'create',
              builder: (_, state) => CreateListingScreen(
                listingId: state.uri.queryParameters['edit'],
              ),
            ),
            GoRoute(
              path: 'chat/:id',
              builder: (_, state) =>
                  ChatScreen(conversationId: state.pathParameters['id']!),
            ),
            GoRoute(path: 'swaps', builder: (_, _) => const SwapScreen()),
            GoRoute(
              path: 'notifications',
              builder: (_, _) => const NotificationsScreen(),
            ),
            GoRoute(
              path: 'profile',
              builder: (_, _) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (_, _) => const ProfileEditScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _refresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Re-run the router's redirect whenever the signed-in user's profile
    // changes, so a freshly created Google profile — or a just-filled campus —
    // is noticed and routed on.
    ref.listen(profileProvider, (_, _) => _refresh.notify());
    final darkMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'CampusSwap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router,
    );
  }
}

class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(Stream<User?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<User?> _subscription;

  /// Manually re-notifies the router — used when the user's profile changes
  /// (not just their auth state), so redirect can re-evaluate onboarding.
  void notify() => notifyListeners();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
