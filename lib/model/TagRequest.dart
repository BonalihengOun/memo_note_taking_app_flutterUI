class TagRequest {

  final String tagName;

  TagRequest({ required this.tagName});

  factory TagRequest.fromJson(Map<String, dynamic> json) {
    return TagRequest(
      tagName: json['tagName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tagName': tagName,
    };
  }
}
