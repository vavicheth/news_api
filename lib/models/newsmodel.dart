

import 'dart:convert';

NewsRequest getNewsFromMap(String jsonMap){
  var map=json.decode(jsonMap);
  return NewsRequest.fromMap(map);

}

class NewsRequest{
  String status;
  int totalResults;
  List<Article> articles;

  NewsRequest({this.status,this.totalResults,this.articles});

  factory NewsRequest.fromMap(Map<String,dynamic> map){
    var list=map['articles'] as List;
    List<Article> datalist = list.map((f) => Article.fromMap(f)).toList();

    return NewsRequest(
      status: map['status'],
      totalResults: map['totalResults'],
      articles: datalist

    );
  }

}

class Article{
  String title;
  String author;
  String urlToImage;

  Article ({this.title,this.author,this.urlToImage});

  factory Article.fromMap(Map<String,dynamic> map){
    return Article(
      title: map['title'],
      author: map['author'],
      urlToImage: map['urlToImage'],
    );
  }


}