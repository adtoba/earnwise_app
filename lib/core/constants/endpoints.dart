class Endpoints {
  static const String baseUrl = 'http://172.20.10.3:8080/api/v1';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh-token';

  static const String categories = '/categories';

  static String expertsByCategory(String category) => '/experts/category/$category';
}