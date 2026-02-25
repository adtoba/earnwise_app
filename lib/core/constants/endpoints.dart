class Endpoints {
  static const String baseUrl = 'http://192.168.4.244:8080/api/v1';
  // static const String baseUrl = 'https://api.getearnwise.com/api/v1';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh-token';

  static const String categories = '/categories';

  static String expertsByCategory(String category) => '/experts/category/$category';

  static String profile = "/users/profile";

  static String users = "/users/";

  static String experts = "/experts/";
  static String expertDashboard = "/experts/dashboard";

  static String posts = "/posts/";

  static String postComments(String postId) => "/posts/comments/$postId";
}