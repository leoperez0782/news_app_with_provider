import 'package:flutter/material.dart';
import 'package:news_provider/src/pages/tab1_page.dart';
import 'package:news_provider/src/pages/tab2_page.dart';
import 'package:news_provider/src/services/news_service.dart';
import 'package:provider/provider.dart';

class TabsPage extends StatelessWidget {
  //final String _apiKey = 'ced38edd69244c518276e88943d9a95e';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _NavigationModel(),
      child: Scaffold(
        body: _Pages(),
        bottomNavigationBar: _Navigation(),
      ),
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavigationModel>(context);
    final newService = Provider.of<NewsService>(context);

    return BottomNavigationBar(
      currentIndex: navegacionModel.actualPage,
      onTap: (i) {
        navegacionModel.actualPage = i;
        newService.selectedCategory = newService.selectedCategory;
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Para ti'),
        BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Encabezados'),
      ],
    );
  }
}

class _Pages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavigationModel>(context);
    return PageView(
      //physics: BouncingScrollPhysics(),
      controller: navegacionModel.pageController,
      physics: NeverScrollableScrollPhysics(), //No deja hacer scroll
      children: [Tab1page(), Tab2Page()],
    );
  }
}

class _NavigationModel with ChangeNotifier {
  int _actualPage = 0;
  PageController _pageController = PageController();

  int get actualPage => this._actualPage;

  set actualPage(int valor) {
    this._actualPage = valor;
    this._pageController.animateToPage(valor,
        duration: Duration(milliseconds: 250), curve: Curves.ease);
    notifyListeners();
  }

  PageController get pageController => _pageController;
}
