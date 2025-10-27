
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/request_model.dart';


class RequestService {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<RequestModel>> getRequests() {
    return _client.from('requests').stream(primaryKey: ['id'])
        .map((data) => data.map((e) => RequestModel.fromMap(e)).toList());
  }


  Future<void> addRequest(RequestModel request) async {
    await _client.from('requests').insert(request.toMap());
  }

  Future<void> updateRequestStatus(String id, String status) async {
    await _client.from('requests').update({'status': status}).eq('id', id);
  }

  Future<void> deleteRequest(String id) async {
    await _client.from('requests').delete().eq('id', id);
  }
  Future<String> uploadImage(File file, String fileName) async {
    final bytes = await file.readAsBytes();

    final response = await _client.storage
        .from('request-images')
        .uploadBinary(fileName, bytes, fileOptions: const FileOptions(upsert: true));

    final publicUrl = _client.storage
        .from('request-images')
        .getPublicUrl(fileName);

    return publicUrl;
  }

}
