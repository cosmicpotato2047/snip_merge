import 'package:flutter/material.dart';
import '../models/trimmed_file.dart';

/// 확인 모달 띄우기 함수
Future<bool?> showConfirmMergeDialog(
  BuildContext context,
  List<TrimmedFile> files,
) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // 바깥 탭으로는 닫히지 않게
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 타이틀
              Text(
                'Confirm Merge',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),

              // 파일 리스트
              ...files.map((file) {
                String rangeLabel =
                    '${_formatDuration(file.start)} → ${_formatDuration(file.end)}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // 파일명 태그
                      Chip(
                        label: Text(file.name),
                        backgroundColor: Colors.pink.shade50,
                      ),
                      const SizedBox(width: 12),
                      // 트림 범위 태그
                      Chip(
                        label: Text(rangeLabel),
                        backgroundColor: Colors.green.shade50,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // 버튼
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB3E5FC),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },

                      child: const Text(
                        'Merge Now',
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Duration을 “MM:SS” 형태로 포맷팅
String _formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final m = twoDigits(d.inMinutes.remainder(60));
  final s = twoDigits(d.inSeconds.remainder(60));
  return '$m:$s';
}