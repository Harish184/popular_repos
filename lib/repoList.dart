import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class repoList extends StatefulWidget {
  const repoList({Key? key}) : super(key: key);

  @override
  State<repoList> createState() => _repoListState();
}

class _repoListState extends State<repoList> {
  List repositories = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  Future<void> getList() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/search/repositories?q=created:>2022-04-29&sort=stars&order=desc'));
    if (response.statusCode == 200) {
      final repoJson = json.decode(response.body);
      setState(() {
        repositories = repoJson['items'];
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Popular Repositories'),
        ),
        body: repositories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: repositories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width* 0.02),
                                  child: Text((index+1).toString(),style: TextStyle(fontSize: height * 0.04),),
                                )
                              ],
                            ),
                            SizedBox(width: width * 0.02,),
                            Column(
                              children: [
                                Container(
                                  width: width * 0.15,
                                  height: height * 0.07,
                                  child: Column(
                                    children: [
                                      Center(
                                          child: Image.network(
                                              repositories[index]['owner']
                                                  ['avatar_url']))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                    height:height* 0.04,width:width * 0.14,child: Text(repositories[index]['owner']['login'],style: TextStyle(fontWeight: FontWeight.bold)))
                              ],
                            ),
                            SizedBox(
                              width: width * 0.08,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.40,
                                            child: Text(repositories[index]['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: height * 0.02),)),
                                        Row(
                                          children: [
                                            Icon(Icons.star,color: Colors.amber,size: 20,),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(repositories[index]['stargazers_count'].toString()),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  repositories[index]['description'] == null
                                      ? Text('No Description')
                                      : Row(
                                          children: [
                                            Container(
                                              width: width * 0.60,
                                              height: height * 0.08,
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  repositories[index]
                                                      ['description'],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }));
  }
}
