import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'modals/websites.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Websites> webList = [];

  lodeJasonBank() async {
    String jsonData = await rootBundle.loadString("assets/json/data.json");
    List res = jsonDecode(jsonData);
    setState(() {
      webList = res.map((e) => Websites.fromJSON(e)).toList();
    });
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    lodeJasonBank();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Education App"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: webList.length,
          itemBuilder: (context, i) => Container(
            margin: const EdgeInsets.only(top: 15),
            child: Card(
              child: ListTile(
                isThreeLine: true,
                leading: SizedBox(
                  width: 80,
                  height: double.infinity,
                  child: Image.asset(
                    webList[i].logo,
                    fit: BoxFit.fill,
                  ),
                ),
                title: Text(
                  "${webList[i].name}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  "${webList[i].website}",
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed("details_page", arguments: webList[i]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}