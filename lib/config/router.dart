import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/phone_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/onboarding/register_screen.dart';
import '../screens/onboarding/upload_documents_screen.dart';
import '../screens/onboarding/pending_approval_screen.dart';
import '../screens/tabs/main_shell.dart';
import '../screens/job/incoming_request_screen.dart';
import '../screens/job/active_job_screen.dart';
import '../screens/job/set_quote_screen.dart';
import '../providers/auth_provider.dart';

GoRouter createRouter(AuthProvider auth) => GoRouter(
  refreshListenable: auth,
  redirect: (context, state) {
    final isLoggedIn = auth.isAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    if (!isLoggedIn && !isAuthRoute) return '/auth/phone';
    if (isLoggedIn && isAuthRoute) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/auth/phone', builder: (_, __) => const PhoneScreen()),
    GoRoute(path: '/auth/otp', builder: (_, state) => OtpScreen(phone: state.uri.queryParameters['phone'] ?? '')),
    GoRoute(path: '/onboarding/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/onboarding/documents', builder: (_, __) => const UploadDocumentsScreen()),
    GoRoute(path: '/onboarding/pending', builder: (_, __) => const PendingApprovalScreen()),
    GoRoute(path: '/', builder: (_, __) => const MainShell()),
    GoRoute(path: '/incoming-request', builder: (_, __) => const IncomingRequestScreen()),
    GoRoute(path: '/active-job', builder: (_, __) => const ActiveJobScreen()),
    GoRoute(path: '/set-quote', builder: (_, state) => SetQuoteScreen(bookingId: state.uri.queryParameters['bookingId'] ?? '')),
  ],
);
