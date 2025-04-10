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
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
              onChanged: isFileSelected
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
            // 3. 슬라이더 값 조정용 네비게이션 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton("-1s", -1),
                _buildNavButton("-0.5s", -0.5),
                _buildNavButton("+0.5s", 0.5),
                _buildNavButton("+1s", 1),
              ],
            ),
            const SizedBox(height: 8),
            // 4. 미리 듣기 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPreviewButton("▶ Start 0–3s", () {
                  // 실제 구현 시 오디오 플레이어 연동
                  debugPrint("Preview Start 0–3s for file ${widget.index + 1}");
                }),
                _buildPreviewButton("▶ End -3s", () {
                  debugPrint("Preview End -3s for file ${widget.index + 1}");
                }),
                _buildPreviewButton("▶ Play All", () {
                  debugPrint("Play All for file ${widget.index + 1}");
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
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFCCBC), // peach/light orange pastel
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        textStyle: const TextStyle(fontSize: 14),
      ),
      onPressed: isFileSelected
          ? () {
              setState(() {
                // offset을 추가해 슬라이더 값을 조절 (경계값 체크 포함)
                double newStart = (trimValues.start + offset).clamp(0, trimValues.end - 1);
                double newEnd = (trimValues.end + offset).clamp(trimValues.start + 1, 100);
                trimValues = RangeValues(newStart, newEnd);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        textStyle: const TextStyle(fontSize: 12),
      ),
      onPressed: isFileSelected ? onPressed : null,
      child: Text(
        label,
        textAlign: TextAlign.center,
      ),
    );
  }
}
