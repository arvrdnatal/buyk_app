abstract class IServices {
  Future add(String id, Map objeto);
  Future delete(String id);
  Future update(String id, Map<String, dynamic> informacoes);
  Future get(String id);
  Future getAll();
}