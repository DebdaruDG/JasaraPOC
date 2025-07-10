class Logger {
  static void log(String message) {
    print('[DEBUG] $message');
  }

  static void error(String message) {
    print('[ERROR] $message');
  }
}
