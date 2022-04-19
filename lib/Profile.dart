import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String image = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        toolbarHeight: 37,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                        child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                      imageUrl: image,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/user.png"),
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Mahesh Khatri",
                            style: TextStyle(color: Colors.black, fontSize: 23),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "@MaheshKhatri",
                            style: TextStyle(color: Colors.black87, fontSize: 17),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 9),
              child: Text(
                "Life is beautiful",
                style: TextStyle(color: Colors.black87, fontSize: 17),
                textAlign: TextAlign.start,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
