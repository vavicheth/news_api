import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_api/models/newsmodel.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

NewsRequest parseData(String data) {
  NewsRequest newsRequest = getNewsFromMap(data);
  return newsRequest;
}

Future<NewsRequest> getData(String url) async {
  http.Response response = await http.Client().get(url);
  if (response.statusCode == 200) {
    return compute(parseData, response.body);
  } else {
    print('error: ${response.statusCode}');
    return null;
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppbar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.deepPurple[900],
      title: Text('Hot News'),
    );
  }

  _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg_drawer_01.jpg"),
              fit: BoxFit.cover),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(child: Container()),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onTap: () {
                //TODO: press home menu
                print("Home clicked!");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.chrome_reader_mode,
                color: Colors.white,
              ),
              title: Text(
                "Documents",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onTap: () {
                //TODO: press document menu
                print("Document clicked!");
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildBottomAppBar() {
    return BottomAppBar(
      child: Container(
        color: Colors.deepPurple[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  //TODO: Home action
                }),
            IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: Colors.white,
                ),
                onPressed: () {
                  //TODO: Favorite action
                }),
            IconButton(
                icon: Icon(
                  Icons.account_box,
                  color: Colors.white,
                ),
                onPressed: () {
                  //TODO: Account action
                }),
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  //TODO: Setting action
                }),
          ],
        ),
      ),
    );
  }

  _buildBody() {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder<NewsRequest>(
          future: getData(
              'https://newsapi.org/v2/everything?q=apple&from=2019-08-30&to=2019-08-30&sortBy=popularity&apiKey=019b09431ea94a32a56d6f8978b7f36f'),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Text("${snapshot.error}");
            else {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  NewsRequest newsRequest = snapshot.data;
                  return Container(
                    child: _buildListView(newsRequest.articles),
                  );
                } else {
                  return Text('No data');
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          }),
    );
  }

  _buildListView(List<Article> data) {
    return Container(
      color: Colors.indigo[900],
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _buildListviewItem(data[index]);
          }),
    );
  }

  _buildListviewItem(Article itemdata) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Column(
        children: <Widget>[
          Container(
            height: 150.0,
            child: Image.network(
              itemdata.urlToImage ??
                  'https://rhondabrowningwhite.files.wordpress.com/2016/05/breaking-news.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Text(
            itemdata.title,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
