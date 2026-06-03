
class AppStrings {
  // Singleton pattern
  static final AppStrings instance = AppStrings._internal();
  factory AppStrings() => instance;
  AppStrings._internal();

  final String baseUrl = 'https://anjaapi.dsrt321.online';

}