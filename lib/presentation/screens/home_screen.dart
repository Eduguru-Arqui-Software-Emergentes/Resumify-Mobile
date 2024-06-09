import 'package:flutter/material.dart';
import 'package:resumify_mobile/presentation/views/library_view.dart';
import 'package:resumify_mobile/presentation/views/profile_view.dart';
import 'package:resumify_mobile/presentation/views/convert_text_view.dart';
import 'package:resumify_mobile/presentation/views/search_video_view.dart';

class HomeScreen extends StatefulWidget {
  final int index;
  const HomeScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState(index);
}

class _HomeScreenState extends State<HomeScreen> {
  final int index;
  _HomeScreenState(this.index);

  int selectedIndex = 0;

  @override
  void initState(){
    selectedIndex = index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //final screens = [const PlantsView(), const CalendarView(), const IdentificationView(), const SpecialistView(), const SettingsView()];
    final List<Widget> screens = [SearchVideo(), LibraryView(), ProfileView()];

    return Scaffold(
      appBar: AppBar(
        title: Text("Resumify, your assistant", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,),
      backgroundColor: const Color.fromRGBO(40, 40, 40, 1.0),
      body: SafeArea(
        child: IndexedStack(
            index: selectedIndex,
            children: screens
        ),),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value){
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 20,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.blue
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined),
              activeIcon: Icon(Icons.library_books),
              label: "Library",
              backgroundColor: Colors.blue
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: "Settings",
              backgroundColor: Colors.blue
          )
        ],
      ),
    );
  }
}