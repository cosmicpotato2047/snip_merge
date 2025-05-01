import 'package:flutter/material.dart';
import '../models/trimmed_file.dart';
import '../widgets/mp3_file_card.dart';
import '../widgets/confirm_merge_dialog.dart';

class FileSelectScreen extends StatefulWidget {
  const FileSelectScreen({super.key});

  @override
  State<FileSelectScreen> createState() => _FileSelectScreenState();
}

class _FileSelectScreenState extends State<FileSelectScreen> {
  late final int fileCount;
  final List<TrimmedFile?> trimmedFiles = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    fileCount = (args is int) ? args : 2;
    trimmedFiles
      ..clear()
      ..addAll(List.filled(fileCount, null));
  }

  @override
  Widget build(BuildContext context) {
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
              // 카드에서 전달된 데이터 저장
              trimmedFiles[idx] = TrimmedFile(name, start, end);
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
          onPressed: () async {
            // null이 아닌 카드만 골라서 다이얼로그 호출
            final files = trimmedFiles.whereType<TrimmedFile>().toList();
            final confirmed = await showConfirmMergeDialog(context, files);
            if (confirmed == true) {
              Navigator.pushNamed(context, '/result', arguments: files);
            }
          },
          child: const Text("Merge Files"),
        ),
      ),
    );
  }
}
