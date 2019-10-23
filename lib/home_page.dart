import 'package:flutter/material.dart';
import 'package:realauth/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:realauth/post_detail.dart';

class HomePage extends StatefulWidget {
//  final userEmail;
//  HomePage({String this.userEmail});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email;

  @override
  void initState(){
    super.initState();
    _loadData();
  }

 _loadData() async{
     SharedPreferences storage = await SharedPreferences.getInstance();
     var U_email = storage.getString('U_email');

     setState(() {
       email = U_email;
     });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:   FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> NewPost())
            );
          }
      ),
      appBar: AppBar(title: Text("Welcome ${email}"), centerTitle: true,),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: ApiService.getPhotoList(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              final photos = snapshot.data;
              return ListView.separated(
                  separatorBuilder: (context, index){
                    return Divider(color: Colors.black, height: 2,);
                  },
                  itemBuilder: (context, index){
                    return new ListTile(
                      leading: Image.network( photos[index]['thumbnailUrl'],),
                      title: Text(photos[index]['title'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15), ),
                      subtitle: Text(photos[index]['url'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10), ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetail(id: photos[index]['id']),
                          )
                        );
                      },
                    );
                },
                  itemCount: photos.length,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }
}



//=================================================== NEW POST PAGE ==============================================================================

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  TextEditingController titleController = new TextEditingController();
  TextEditingController bodyController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create a new Post"),),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Title"),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(hintText: "Body"),
              ),
              Container(height: 30,),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("Submit"),
                    onPressed: (){
                        if(titleController.text.isEmpty || bodyController.text.isEmpty){
                          showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: Text("Failure"),
                                content: Text("You need to input the content of the post!"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("close")
                                  )
                                ],
                              );
                            }
                          );
                        }else{
                        final post = {
                          'title': titleController.text,
                          'body': bodyController.text,

                        };
                        ApiService.addPost(post).then((success){
                          String title, text;
                          if(success){
                            title = "Success";
                            text = "Your Post has been successfully Submitted";
                          }else{
                            title = "Error";
                            text = "An error occured while submitting your post";
                          }
                          showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: Text(title),
                                content: Text(text),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Close"))
                                ],

                              );
                            }
                          );
                        });
                        }
                    }
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
