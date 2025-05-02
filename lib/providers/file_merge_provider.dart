// lib/providers/file_merge_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trimmed_file.dart';

/// 1) TrimmedFile 리스트를 관리하는 StateNotifier
class TrimmedFileList extends StateNotifier<List<TrimmedFile>> {
  TrimmedFileList(): super([]);

  void init(int count) {
    state = List.generate(count, (_) => TrimmedFile.empty());
  }

  void update(int idx, TrimmedFile file) {
    final list = [...state];
    list[idx] = file;
    state = list;
  }

  bool get allSelected => state.every((f) => f.isValid);
}

/// 2) 전역 Provider
final trimmedFileListProvider =
    StateNotifierProvider<TrimmedFileList, List<TrimmedFile>>(
  (ref) => TrimmedFileList(),
);
