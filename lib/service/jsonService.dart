class JsonService {
  static late JsonService _instance;

  JsonService._internal();

  static JsonService getInstance() {
    if (_instance == null) {
      _instance = JsonService._internal();
    }
    return _instance;
  }
}
