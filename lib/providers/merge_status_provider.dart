// lib/providers/merge_status_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 병합 진행 상태를 나타내는 enum
enum MergeStatus { idle, merging, done, error }

/// 상태를 관리할 StateProvider
final mergeStatusProvider = StateProvider<MergeStatus>(
  (ref) => MergeStatus.idle,
);
