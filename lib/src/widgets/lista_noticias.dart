import 'package:flutter/material.dart';
import 'package:news_provider/src/models/news_models.dart';
import 'package:news_provider/src/services/read_news_service.dart';
import 'package:news_provider/src/theme/tema.dart';

class NewsList extends StatelessWidget {
  final List<Article> news;
  const NewsList(this.news);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: this.news.length,
        itemBuilder: (BuildContext context, int index) {
          return _News(this.news[index], index);
        });
  }
}

class _News extends StatelessWidget {
  final Article news;
  final int index;

  const _News(this.news, this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBarCard(this.news, this.index),
        _TitleCard(this.news),
        _ImageCard(this.news),
        _BodyCard(this.news),
        _ButtonsCard(this.news),
        SizedBox(
          height: 10,
        ),
        Divider()
      ],
    );
  }
}

class _TopBarCard extends StatelessWidget {
  final Article news;
  final int index;
  const _TopBarCard(this.news, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text('${index + 1}', style: TextStyle(color: myTheme.accentColor)),
          Text('${news.source?.name}')
        ],
      ),
    );
  }
}

class _TitleCard extends StatelessWidget {
  final Article news;
  const _TitleCard(this.news);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        news.title!,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final Article news;
  const _ImageCard(this.news);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        child: Container(
          child: (news.urlToImage != null)
              ? FadeInImage(
                  placeholder: AssetImage('assets/img/giphy.gif'),
                  image: NetworkImage(news.urlToImage!),
                )
              : Image(image: AssetImage('assets/img/no-image.png')),
        ),
      ),
    );
  }
}

class _BodyCard extends StatelessWidget {
  final Article news;
  const _BodyCard(this.news);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text((news.description != null) ? news.description! : ''),
    );
  }
}

class _ButtonsCard extends StatelessWidget {
  final Article news;
  const _ButtonsCard(this.news);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            //Favorite button
            onPressed: () {
              print('funciona');
            },
            fillColor: myTheme.accentColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.star_border),
          ),
          SizedBox(
            width: 10,
          ),
          RawMaterialButton(
            //Read button
            onPressed: () {
              final service = ReadNewsService();

              try {
                service.launchInWebViewOrVC(news.url!);
              } catch (error) {
                _showModal(error.toString(), context);
              }
            },
            fillColor: Colors.blue[800],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.more),
          ),
        ],
      ),
    );
  }

  void _showModal(String error, BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(error),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
