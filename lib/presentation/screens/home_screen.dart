import 'package:flutter/material.dart';

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
    final List<Widget> screens = [];

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
              icon: Icon(Icons.yard_outlined),
              activeIcon: Icon(Icons.yard),
              label: "Plants",
              backgroundColor: Colors.red
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: "Calendar",
              backgroundColor: Colors.green
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.linked_camera_outlined),
              activeIcon: Icon(Icons.linked_camera),
              label: "Identify",
              backgroundColor: Colors.blue
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.psychology_alt_outlined),
              activeIcon: Icon(Icons.psychology_alt),
              label: "Specialists",
              backgroundColor: Colors.orange
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: "Settings",
              backgroundColor: Colors.yellow
          )
        ],
      ),
    );
  }
}