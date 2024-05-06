class ReceiveFile {
  final int fileId;
  final String receiveFiles;

  ReceiveFile({required this.fileId, required this.receiveFiles});

  factory ReceiveFile.fromJson(Map<String, dynamic> json) {
    return ReceiveFile(
      fileId: json['fileId'] ?? 0, // Changed default value to 0
      receiveFiles: json['receiveFiles'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileId': fileId,
      'receiveFiles': receiveFiles,
    };
  }
}