class FilesImgVideo {
  final int fileId;
  final String receiveFiles;

  FilesImgVideo({
    required this.fileId,
    required this.receiveFiles,
  });

  factory FilesImgVideo.fromJson(Map<String, dynamic> json) {
    return FilesImgVideo(
      fileId: json['fileId'] as int,
      receiveFiles: json['receiveFiles'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'receiveFiles': receiveFiles,
    };
  }
}