import 'package:flutter/material.dart';
import 'package:resumify_mobile/presentation/screens/search_video_screen.dart';

class HomeScreen extends StatefulWidget {
  final int index;
  const HomeScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState(index);
}

class _HomeScreenState extends State<HomeScreen> {
  final int index;
  _HomeScreenState(this.index);

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            //margin: EdgeInsets.all(16.0),
            child: NavigationRail(
              backgroundColor: Color.fromRGBO(229, 229, 229, 100),
              selectedIndex: _selectedIndex,
              groupAlignment: -1,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.none,

              trailing:
              IconButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                icon: const Icon(Icons.exit_to_app),

              ),

              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.account_box_outlined),
                  selectedIcon: Icon(Icons.account_box_rounded),
                  label: Text('First'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.translate),
                  selectedIcon: Icon(Icons.translate_sharp),
                  label: Text('Second'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.library_books_outlined),
                  selectedIcon: Icon(Icons.library_books_rounded),
                  label: Text('Third'),
                ),
              ],
            ),
          ),


          Expanded(
              child: Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(builder: (context) => _getScreenForIndex(_selectedIndex),
                  );
                },
              )
          ),
        ],
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return TabOne();
      case 1:
        return SearchVideo();
      default:
        return TabOne();
    }
  }

}


class TabOne extends StatefulWidget {
  const TabOne({super.key});

  @override
  State<TabOne> createState() => _TabOneState();
}

class _TabOneState extends State<TabOne> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Contenido de la pestaña 1'),
    );
  }
}

