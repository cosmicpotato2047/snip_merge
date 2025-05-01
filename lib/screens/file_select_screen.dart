import 'package:flutter/material.dart';

class FileSelectScreen extends StatefulWidget {
  const FileSelectScreen({super.key});

  @override
  State<FileSelectScreen> createState() => _FileSelectScreenState();
}

class _FileSelectScreenState extends State<FileSelectScreen> {
  late final int fileCount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Start Screen에서 전달된 파일 개수를 argument로 받아옴.
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is int) {
      fileCount = args;
    } else {
      fileCount = 2; // 인자가 없으면 기본값 2로 설정.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select and Trim Files")),
      backgroundColor: const Color(0xFFF8FAFB), // off-white pastel background
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fileCount,
        itemBuilder: (context, index) {
          return MP3FileCard(index: index);
        },
      ),
      // Merge Files 버튼은 하단에 고정
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA7C7E7), // pastel tone
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: () {
            // Merge Files 기능 구현 후 결과 화면으로 연결
            Navigator.pushNamed(context, '/result');
          },
          child: const Text("Merge Files"),
        ),
      ),
    );
  }
}

/// MP3 파일 카드 위젯
class MP3FileCard extends StatefulWidget {
  final int index;
  const MP3FileCard({required this.index, super.key});

  @override
  State<MP3FileCard> createState() => _MP3FileCardState();
}

class _MP3FileCardState extends State<MP3FileCard> {
  bool isFileSelected = false;
  String? fileName;
  // 예제에서는 총 길이를 100초로 가정. 실제 구현 시 파일 길이에 따라 설정하면 됨.
  RangeValues trimValues = const RangeValues(0, 100);

  bool adjustStart = true;
  static const double minimalGap = 1.0;
  static const double maxDuration = 100.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      // 파일 미선택 시 낮은 opacity, 선택 시 흰색 배경
      color: isFileSelected ? Colors.white : Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 파일 선택 버튼
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB3E5FC), // pastel blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  // 실제 앱에서는 file_picker 등으로 파일을 선택하면 됨.
                  setState(() {
                    isFileSelected = true;
                    fileName = "audio_file_${widget.index + 1}.mp3";
                  });
                },
                child: const Text("Select File"),
              ),
            ),
            const SizedBox(height: 8),
            if (isFileSelected)
              Center(
                child: Text(
                  fileName!,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            const SizedBox(height: 16),
            // 2. 슬라이더를 통한 트림 범위 설정
            Text(
              "Trim selection:",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
            RangeSlider(
              values: trimValues,
              min: 0,
              max: 100,
              divisions: 100,
              activeColor: const Color(0xFF81D4FA), // pastel blue/mint tint
              inactiveColor: Colors.grey.shade300,
              // 파일이 선택된 경우에만 활성화
              onChanged:
                  isFileSelected
                      ? (values) {
                        setState(() {
                          trimValues = values;
                        });
                      }
                      : null,
              labels: RangeLabels(
                "${trimValues.start.toStringAsFixed(0)}s",
                "${trimValues.end.toStringAsFixed(0)}s",
              ),
            ),
            const SizedBox(height: 8),
            // 3. Start/End 조정 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1) Start/End 토글
                ToggleButtons(
                  isSelected: [adjustStart, !adjustStart],
                  borderRadius: BorderRadius.circular(8),
                  onPressed: (i) => setState(() => adjustStart = (i == 0)),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Start'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('End'),
                    ),
                  ],
                ),

                // 2) 네비게이션 버튼들
                //    Expanded로 감싸서 남는 공간만큼 버튼 그룹이 고르게 퍼지도록
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavButton("-1s", -1),
                      _buildNavButton("-0.5s", -0.5),
                      _buildNavButton("+0.5s", 0.5),
                      _buildNavButton("+1s", 1),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 4. 미리 듣기 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPreviewButton("▶ Play start–3s", () {
                  // 실제 구현 시 오디오 플레이어 연동
                  debugPrint(
                    "Preview Play start–3s for file ${widget.index + 1}",
                  );
                }),
                _buildPreviewButton("▶ Play All", () {
                  debugPrint("Play All for file ${widget.index + 1}");
                }),
                _buildPreviewButton("▶ Play -3s-end", () {
                  debugPrint("Preview Play -3s-end file ${widget.index + 1}");
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 네비게이션 버튼 생성 함수
  Widget _buildNavButton(String label, double offset) {
    return ElevatedButton(
      onPressed:
          isFileSelected
              ? () {
                setState(() {
                  double s = trimValues.start;
                  double e = trimValues.end;
                  if (adjustStart) {
                    s = (s + offset).clamp(0.0, e - minimalGap);
                  } else {
                    e = (e + offset).clamp(s + minimalGap, maxDuration);
                  }
                  trimValues = RangeValues(s, e);
                });
              }
              : null,
      child: Text(label),
    );
  }

  // 미리 듣기 버튼 생성 함수
  Widget _buildPreviewButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD1C4E9), // lavender pastel
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        textStyle: const TextStyle(fontSize: 12),
      ),
      onPressed: isFileSelected ? onPressed : null,
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}

/// 트림된 파일 정보를 담는 모델 (예시)
class TrimmedFile {
  final String name;
  final Duration start;
  final Duration end;

  TrimmedFile(this.name, this.start, this.end);
}

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
                      onPressed: () async {
                        // trimmedFiles 리스트는 MP3FileCard 각 State에서 수집해 두었다고 가정
                        final confirmed = await showConfirmMergeDialog(
                          context//,
                          // trimmedFiles,
                        );
                        if (confirmed == true) {
                          Navigator.pushNamed(context, '/result');
                        }
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
