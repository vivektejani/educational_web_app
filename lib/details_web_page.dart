import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DetailWebPage extends StatefulWidget {
  const DetailWebPage({Key? key}) : super(key: key);

  @override
  State<DetailWebPage> createState() => _DetailWebPageState();
}

class _DetailWebPageState extends State<DetailWebPage> {
  final GlobalKey inAppWebViewKey = GlobalKey();
  InAppWebViewController? inAppWebViewController;
  TextEditingController searchController = TextEditingController();
  String searchedText = "";
  double progress = 0;
  String url = "";
  List<String> allBookmarks = [];
  InAppWebViewController? webViewController;

  late PullToRefreshController pullToRefreshController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
    print("");
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(res.name),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () async {
              searchController.text = "";
              await inAppWebViewController!.loadUrl(
                urlRequest: URLRequest(
                  url: Uri.parse(
                    "https://www.google.co.in",
                  ),
                ),
              );
              inAppWebViewController?.goBack();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              inAppWebViewController?.goBack();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              inAppWebViewController?.reload();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              inAppWebViewController?.goForward();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 0.5,
          ),
          Expanded(
            flex: 15,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                InAppWebView(
                  key: inAppWebViewKey,
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(res.website),
                  ),
                  onWebViewCreated: (controller) async {
                    inAppWebViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      searchController.text = this.url;
                    });
                  },
                  onLoadStop: (controller, url) async {
                    await pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      searchController.text = this.url;
                    });
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: Icon(Icons.cancel),
            onPressed: () async {
              if (progress <= 100) {
                pullToRefreshController.endRefreshing();
                progress == 3.0;
              }
            },
            mini: true,
            heroTag: null,
          ),
          FloatingActionButton(
            child: Icon(Icons.bookmark_add_outlined),
            onPressed: () async {
              Uri? uri = await inAppWebViewController!.getUrl();
              if (allBookmarks.isEmpty) {
                allBookmarks.add(uri.toString());
              } else {
                allBookmarks.forEach((e) {
                  if (uri.toString() != e) {
                    allBookmarks.add(uri.toString());
                  }
                });
              }
            },
            mini: true,
            heroTag: null,
          ),
          FloatingActionButton(
            child: Icon(Icons.bookmarks_outlined),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Center(
                      child: Text("All Bookmarks"),
                    ),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: allBookmarks
                            .map((e) => GestureDetector(
                          child: Row(
                            children: [
                              Text(e),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    int i = e.indexOf(e);
                                    setState(() {
                                      allBookmarks.removeAt(i);
                                    });
                                  },
                                  icon: Icon(Icons.cancel_outlined))
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();

                            inAppWebViewController!.loadUrl(
                                urlRequest:
                                URLRequest(url: Uri.parse(e)));
                          },
                        ))
                            .toSet()
                            .toList()),
                  ));
            },
            mini: true,
            heroTag: null,
          ),
        ],
      ),
    );
  }
}