/// 트림된 파일 정보를 담는 모델 (예시)
class TrimmedFile {
  final String name;
  final Duration start;
  final Duration end;

  TrimmedFile(this.name, this.start, this.end);
}