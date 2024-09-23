import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/models/article_model.dart';
import '../services/news_service.dart';
import 'news_list_view.dart';

class NewsListViewBuilder extends StatefulWidget {
  const NewsListViewBuilder({
    super.key,
    required this.category,
    this.searchQuery = '', // Added searchQuery
  });

  final String category;
  final String searchQuery; // Add search query parameter

  @override
  State<NewsListViewBuilder> createState() => _NewsListViewBuilderState();
}

class _NewsListViewBuilderState extends State<NewsListViewBuilder> {
  late Future<List<ArticleModel>> future;

  @override
  void initState() {
    super.initState();
    // Fetch top headlines based on the category and search query
    future = fetchNews();
  }

  // Method to fetch news based on category and search query
  Future<List<ArticleModel>> fetchNews() {
    // Call your service to get headlines, include search query if necessary
    return NewsService(Dio()).getTopHeadlines(
      category: widget.category,
      searchQuery: widget.searchQuery, // Pass the search query here if your service supports it
    );
  }

  @override
  void didUpdateWidget(covariant NewsListViewBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the search query has changed, refetch the news
    if (oldWidget.searchQuery != widget.searchQuery) {
      future = fetchNews(); // Refetch when the search query changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Filter the articles based on the search query
          List<ArticleModel> filteredArticles = snapshot.data!.where((article) {
            return article.title.toLowerCase().contains(widget.searchQuery.toLowerCase());
          }).toList();

          // Check if there are no filtered articles
          if (filteredArticles.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                child: Text('No articles found for your search.'),
              ),
            );
          }

          // Display filtered articles
          return NewsListView(
            articles: filteredArticles,
          );
        } else if (snapshot.hasError) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text('Oops, there was an error. Try again later.'),
            ),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
