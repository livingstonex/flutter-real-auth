import 'package:flutter/material.dart';
import 'package:realauth/api_service.dart';

class PostDetail extends StatelessWidget {
  final int id;
  PostDetail({this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Posts Page"),),
      body: Column(
        children: <Widget>[
          FutureBuilder(
              future: ApiService.getPhoto(id),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  final photoDetail = snapshot.data;
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 5.0,),

                     //Image.network (photoDetail['thumbnailUrl'],),
                      //SizedBox(height: 10.0,),
                      Text( "IMAGE TITLE", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                      SizedBox(height: 5.0,),
                      Text( snapshot.data['title'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      SizedBox(height: 5.0,),
                      Text("Source of Image:   " + snapshot.data['url'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      Image.network(photoDetail['url']),
                      //Text( "Album ID of the Image is:   " + snapshot.data['albumId'], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    ],
                  );
                }
                return Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 10.0,),
                      Text("Am the real deal, and I am Loading ... ", style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold) ),
                    ],
                  ),
                );
              }
          ),

          Container(height:20),
          Divider(color: Colors.black, height: 3,),
          Container(height:20),

//          FutureBuilder(
//              future: ApiService.getCommentsForPost(id),
//              builder: (context, snapshot){
//                if(snapshot.connectionState == ConnectionState.done){
//                  final comments = snapshot.data;
//                  return Expanded(
//                    child: ListView.separated(
//                      separatorBuilder: (context, index){
//                        return Divider(color: Colors.black, height: 2,);
//                      },
//                      itemBuilder: (context, index){
//                        return new ListTile(
//                          title: Text(comments[index]['name'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, ), ),
//                          subtitle: Text(comments[index]['body'],),
//                        );
//                      },
//                      itemCount: comments.length,
//                    ),
//                  );
//                }
//                return Center(
//                  child: CircularProgressIndicator(),
//                );
//              }
//          ),

        ],
      ),
    );
  }
}
