import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:web_scraper/web_scraper.dart';

class WebCrawlerApp extends StatefulWidget {
  const WebCrawlerApp({super.key});

  @override
  _WebCrawlerAppState createState() => _WebCrawlerAppState();
}

class _WebCrawlerAppState extends State<WebCrawlerApp> {
  //final webScraper = WebScraper();

  bool isLoading = false;
  List elements = [];
  TextEditingController controller = TextEditingController();

  void extractDataTeste(String url) async {
    final response = await http.Client().get(Uri.https(url));

    var document = parser.parse(response.body);

    var resp = document.getElementsByTagName('a[href]').toList();

    setState(() {
      for (int i = 0; i < resp.length; i++) {
        var respTemp = resp[i].attributes.remove('href');

        if (respTemp!.contains('h', 0) && respTemp.contains('t', 1)) {
          if (elements.contains(respTemp)) {
            elements.remove(respTemp);
          } else {
            elements.add(respTemp);
          }
        } else if (respTemp.contains('/', 0)) {
          if (elements.contains(respTemp)) {
            elements.remove(respTemp);
          } else {
            elements.add(url + respTemp);
          }
        } else {
          if (elements.contains(respTemp)) {
            elements.remove(respTemp);
          } else {
            elements.add(respTemp);
          }
        }

        //print(elements);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    extractDataTeste('');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 230,
                    color: Colors.white38,
                    child: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Pesquisar..",
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white70,
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.pinkAccent.shade200,
                    child: MaterialButton(
                      onPressed: () async {
                        var resp = controller.text;
                        setState(() {
                          extractDataTeste(resp);
                          isLoading = true;
                        });
                      },
                      child: const Text("Enter"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
              child: !isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: controller.text.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(children: [
                                ExpansionTile(
                                  title: Text(elements[index]),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: const Text(''),
                                            margin:
                                                const EdgeInsets.only(bottom: 10.0),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              // launch(webScraper.baseUrl! +
                                              //     attributes['href']);
                                            },
                                            child: const Text(
                                              'Abrir no navegador',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ]);
                      }))),
    );
  }
}
