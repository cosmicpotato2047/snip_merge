import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snip_merge/providers/file_merge_provider.dart';
import '../models/trimmed_file.dart';
import '../widgets/mp3_file_card.dart';
import '../widgets/confirm_merge_dialog.dart';
import '../providers/merge_status_provider.dart'; // trimmedFileListProvider

class FileSelectScreen extends ConsumerStatefulWidget {
  const FileSelectScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FileSelectScreen> createState() => _FileSelectScreenState();
}

class _FileSelectScreenState extends ConsumerState<FileSelectScreen> {
  late final int fileCount;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments;
      fileCount = (args is int) ? args : 2;
      // Riverpod 프로바이더 초기화
      ref.read(trimmedFileListProvider.notifier).init(fileCount);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod에서 관리되는 파일 리스트 & 유효 여부
    final files = ref.watch(trimmedFileListProvider);
    final allSelected = files.every((f) => f.isValid);

    return Scaffold(
      appBar: AppBar(title: const Text("Select and Trim Files")),
      backgroundColor: const Color(0xFFF8FAFB), // off-white pastel background
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fileCount,
        itemBuilder: (ctx, idx) {
          return MP3FileCard(
            index: idx,
            onTrimChanged: (name, start, end) {
              // 상태 업데이트
              ref
                  .read(trimmedFileListProvider.notifier)
                  .update(idx, TrimmedFile(name, start, end));
            },
          );
        },
      ),
      // Merge Files 버튼은 하단에 고정
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA7C7E7), // pastel tone
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed:
              allSelected
                  ? () async {
                    final confirmed = await showConfirmMergeDialog(
                      context,
                      files,
                    );
                    if (confirmed == true) {
                      Navigator.pushNamed(
                        context,
                        '/result',
                        arguments: {
                          'fileName': 'merged.mp3',
                          'filePath': '/Music/SnipMerge/',
                        },
                      );
                    }
                  }
                  : null,
          child: const Text("Merge Files"),
        ),
      ),
    );
  }
}
