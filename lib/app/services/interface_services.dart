abstract class IServices {
  Future add(Map<String, dynamic> info);
  Future delete(String id);
  Future update(String id, Map<String, dynamic> info);
  Future get(String id);
  Future getAll();
}