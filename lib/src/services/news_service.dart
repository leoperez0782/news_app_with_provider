import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:news_provider/src/models/category_model.dart';
import 'package:news_provider/src/models/news_models.dart';
import '../keys.dart';

final _URL_NEWS = 'https://newsapi.org/v2';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  bool _isLoading = true;
  String _selectedCategory = 'business';

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadLines();
    categories.forEach((element) {
      this.categoryArticles[element.name] = [];
    });
  }

  bool get isLoading => this._isLoading;

  String get selectedCategory => this._selectedCategory;

  set selectedCategory(String value) {
    this._selectedCategory = value;

    this._isLoading = true;
    this.getArticlesByCategory(value);
    notifyListeners();
  }

  List<Article>? get getSelectedCategoryArticles =>
      this.categoryArticles[this.selectedCategory];

  getTopHeadLines() async {
    print('cargando headlines...');

    final url = '$_URL_NEWS/top-headlines?apiKey=$API_KEY&country=us';
    final resp = await http.get(Uri.parse(url));

    final newsResponse = newsResponseFromJson(resp.body);

    this.headlines.addAll(newsResponse.articles!.map((a) => a).toList());
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (categoryArticles[category]!.length > 0) {
      this._isLoading = false;
      return this.categoryArticles[category];
    }
    final url =
        '$_URL_NEWS/top-headlines?apiKey=$API_KEY&country=us&category=$category';
    final resp = await http.get(Uri.parse(url));

    final newsResponse = newsResponseFromJson(resp.body);

    this
        .categoryArticles[category]!
        .addAll(newsResponse.articles!.map((a) => a).toList());
    this._isLoading = false;
    notifyListeners();
  }
}
