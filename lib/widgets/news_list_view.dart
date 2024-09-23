import 'package:flutter/cupertino.dart';

import '../models/article_model.dart';
import 'news_tile.dart';

class NewsListView extends StatelessWidget {
  final List<ArticleModel> articles;

  const NewsListView({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    // Check if articles are empty
    if (articles.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('No articles available for this category.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: NewsTile(
              articleModel: articles[index],
            ),
          );
        },
        childCount: articles.length,
      ),
    );
  }
}
