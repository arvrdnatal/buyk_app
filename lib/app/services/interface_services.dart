abstract class IServices<T> {
  Future add(T objeto);
  Future delete(String id);
  Future update(String id, Map<String, dynamic> informacoes);
  Future get(String id);
  Future getAll();
}