import 'package:news_provider/src/services/news_service.dart';
import 'package:news_provider/src/widgets/lista_noticias.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Tab1page extends StatefulWidget {
  @override
  _Tab1pageState createState() => _Tab1pageState();
}

class _Tab1pageState extends State<Tab1page>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final headlines = Provider.of<NewsService>(context).headlines;
    return Scaffold(
      body: (headlines.length == 0)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : NewsList(headlines),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
