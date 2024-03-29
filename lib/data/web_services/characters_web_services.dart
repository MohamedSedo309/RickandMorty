import 'package:dio/dio.dart';
import 'package:rick_and_morty_bloc/constants/strings.dart';

class Characters_WebServices {
  late Dio dio;

  Characters_WebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get('character');
      return response.data["results"];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getRandomQuote() async {
    Dio _dio = Dio();
    BaseOptions _options = BaseOptions(
      baseUrl: "https://api.quotable.io/quotes/",
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );
    _dio = Dio(_options);
    try {
      Response response = await _dio.get('random');
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
