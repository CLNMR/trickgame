import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tb_core/tb_core.dart';
import 'package:yust/yust.dart';

part 'providers.g.dart';

@riverpod

/// The current [AuthState].
Stream<AuthState> authState(AuthStateRef ref) =>
    Yust.authService.getAuthStateStream();

@riverpod

/// The current [YustUser].
Stream<YustUser?> user(UserRef ref) {
  ref.watch(authStateProvider);
  final authId = Yust.authService.getCurrentUserId();
  return YustUserService.getFirstStream(
    filters: [
      YustFilter(
        comparator: YustFilterComparator.equal,
        field: 'authId',
        value: authId,
      ),
    ],
  );
}
