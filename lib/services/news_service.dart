import 'package:dio/dio.dart';
import 'package:news_app_ui_setup/models/article_model.dart';

class NewsService {
  final Dio dio;
  final String apiKey = '3c88955c487e4d9db668f011dd85e737';

  NewsService(this.dio);

  Future<List<ArticleModel>> getTopHeadlines({
    required String category,
    String searchQuery = '', // Add search query parameter
    int page = 1,
    int pageSize = 20, // Adjust page size as needed
  }) async {
    try {
      final queryParameters = {
        'country': 'us',
        'apiKey': apiKey,
        'category': category,
        'page': page,
        'pageSize': pageSize,
      };

      // Include the search query if provided
      if (searchQuery.isNotEmpty) {
        queryParameters['q'] = searchQuery; // Assuming 'q' is the parameter for search
      }

      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;
        List<dynamic> articles = jsonData['articles'];

        List<ArticleModel> articlesList = [];
        for (var article in articles) {
          ArticleModel articleModel = ArticleModel.fromJson(article);
          articlesList.add(articleModel);
        }

        return articlesList;
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
        return [];
      }
    } catch (e) {
      // Improved error logging
      if (e is DioError) {
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('Response data: ${e.response?.data}');
        }
      } else {
        print('Unexpected error: $e');
      }
      return [];
    }
  }
}
