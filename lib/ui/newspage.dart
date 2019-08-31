import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_api/models/newsmodel.dart';
import 'package:http/http.dart' as http;

NewsRequest parseData(String data){
  NewsRequest newsRequest = getNewsFromMap(data);
  return newsRequest;
}

Future<NewsRequest> getData (String url) async{
  http.Response response=await http.Client().get(url);
  if(response.statusCode ==200){
    return compute(parseData, response.body);
  }else{
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
      body: _buildBody(),
    );
  }

  _buildBody() {

    return Container(
      alignment: Alignment.center,
      child: FutureBuilder<NewsRequest>(
        future: getData('https://newsapi.org/v2/everything?q=bitcoin&apiKey=019b09431ea94a32a56d6f8978b7f36f'),
          builder: (context,snapshot){
            if(snapshot.hasError) return Text("${snapshot.error}");
            else{
              if(snapshot.connectionState ==ConnectionState.done){
                if(snapshot.hasData){
                  NewsRequest newsRequest=snapshot.data;
                  return Container(
                    child: _buildListView(newsRequest.articles),
                  );
                }else{
                  return Text('No data');
                }
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }

          }
      ),
    );
  }

  _buildListView(List<Article> data) {
    return Container(
      color: Colors.indigoAccent,
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context,index){
            return _buildListviewItem(data[index]);
          }
      ),
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
            child: Image.network(itemdata.urlToImage??'https://rhondabrowningwhite.files.wordpress.com/2016/05/breaking-news.jpg',fit: BoxFit.cover,),
          ),
          Text(itemdata.title)
        ],
      ),
    );
  }
}
