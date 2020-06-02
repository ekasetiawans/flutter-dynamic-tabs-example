import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

// anggap aja ini group buat jadi tab
class ProductGroup {
  final String name;
  final String id;

  ProductGroup({this.name, this.id});

  // anggap aja hasil panggil dari API
  static Future<List<ProductGroup>> all() async {
    return await Future.delayed(Duration(seconds: 3), () {
      return List<ProductGroup>.generate(
        100,
        (index) => ProductGroup(id: "group$index", name: "Group Ke $index"),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ProductGroup> groups;
  @override
  void initState() {
    super.initState();
    ProductGroup.all().then((value) {
      if (mounted) {
        setState(() {
          groups = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: groups?.length ?? 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dynamic Tabs"),
          bottom: groups == null
              ? null
              : TabBar(
                  isScrollable: true,
                  tabs: groups
                      .map<Tab>((item) => Tab(
                            text: item.name,
                          ))
                      .toList(),
                ),
        ),
        body: buildViews(),
      ),
    );
  }

  buildViews() {
    if (groups == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return TabBarView(
      children: groups
          .map<Widget>(
            (item) => Container(
              key: ValueKey(
                  item), // ini buat memastikan container ini nggak salah nampilin grup
              child: Column(
                children: [
                  Text("Nama Group: " + item.name),
                  Text("ID Group: " + item.id),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
