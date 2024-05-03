class ReceiveFile {
  final int fileId;
  final String receiveFiles;

  ReceiveFile({required this.fileId, required this.receiveFiles});

  factory ReceiveFile.fromJson(Map<String, dynamic> json) => ReceiveFile(
    fileId: json["fileId"],
    receiveFiles: json["receiveFiles"],
  );
  Map<String, dynamic> toJson() => {
    "fileId": fileId,
    "receiveFiles": receiveFiles,
  };
}
