import 'dart:io';
import 'package:dio/dio.dart';
import '../config/api_client.dart';

class UploadService {
  Future<String> uploadFile(File file, String folder) async {
    final fileName = file.path.split('/').last;
    final fileType = fileName.endsWith('.png') ? 'image/png' : 'image/jpeg';

    final res = await api.post('/uploads/presigned-url', data: {'fileName': fileName, 'fileType': fileType, 'folder': folder});
    final uploadUrl = res.data['data']['uploadUrl'];
    final fileUrl = res.data['data']['fileUrl'];

    final bytes = await file.readAsBytes();
    await Dio().put(uploadUrl, data: bytes, options: Options(headers: {'Content-Type': fileType}));

    return fileUrl;
  }
}
