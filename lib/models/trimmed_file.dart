/// 트림된 파일 정보를 담는 모델 (예시)
class TrimmedFile {
  final String name;
  final Duration start;
  final Duration end;

  TrimmedFile(this.name, this.start, this.end);

  // ─── 1) 빈 상태를 나타내는 named constructor ───
  /// 초기화용 빈 파일(아직 선택되지 않음)
  TrimmedFile.empty()
      : name = '',
        start = Duration.zero,
        end = Duration.zero;

  // ─── 2) 유효한 트림 파일인지 확인하는 getter ───
  bool get isValid => name.isNotEmpty && end > start;

}