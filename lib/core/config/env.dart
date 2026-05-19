import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String apiBaseUrl() {
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:4000';
  }

  static String mediaBaseUrl() {
    return dotenv.env['MEDIA_BASE_URL'] ?? apiBaseUrl();
  }
}
