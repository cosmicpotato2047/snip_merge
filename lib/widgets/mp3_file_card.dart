import 'package:flutter/material.dart';
import '../models/trimmed_file.dart';

/// MP3 파일 카드 위젯
class MP3FileCard extends StatefulWidget {
  final int index;
  final void Function(String name, Duration start, Duration end) onTrimChanged;

  const MP3FileCard({
    required this.index,
    required this.onTrimChanged,
    super.key,
  });

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

  void _selectFile() {
    setState(() {
      isFileSelected = true;
      fileName = 'audio_${widget.index + 1}.mp3';
    });
    _notifyParent();
  }

  void _updateTrim(RangeValues newValues) {
    setState(() => trimValues = newValues);
    _notifyParent();
  }

  void _notifyParent() {
    if (fileName != null) {
      widget.onTrimChanged(
        fileName!,
        Duration(seconds: trimValues.start.toInt()),
        Duration(seconds: trimValues.end.toInt()),
      );
    }
  }

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
                  // 부모에게 선택,트림 상태를 알려주는 호출
                  widget.onTrimChanged(
                    fileName!,
                    Duration(seconds: trimValues.start.toInt()),
                    Duration(seconds: trimValues.end.toInt()),
                  );
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
                  isFileSelected ? (values) => _updateTrim(values) : null,
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

