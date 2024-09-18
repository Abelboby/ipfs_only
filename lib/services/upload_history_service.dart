import 'package:flutter/foundation.dart';

class UploadHistoryService extends ChangeNotifier {
  final List<Upload> _uploads = [];

  List<Upload> get uploads => _uploads;

  void addUpload(String cid, String filePath) {
    _uploads.add(Upload(cid, filePath, DateTime.now()));
    notifyListeners();
  }
}

class Upload {
  final String cid;
  final String filePath;
  final DateTime timestamp;

  Upload(this.cid, this.filePath, this.timestamp);
}
