import '../utils/enumeration_mem.dart';

class ModelServerResponse{
  late EnumServerSyncStatus status;
  dynamic data;
  ModelServerResponse({required this.status, required this.data});
}