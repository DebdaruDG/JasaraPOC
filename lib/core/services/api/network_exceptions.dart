class NetworkExceptions {
  static String getMessage(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'No internet connection.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timeout. Please try again.';
    } else {
      return 'Unexpected error occurred.';
    }
  }
}
