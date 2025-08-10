import 'package:eonix/home_screens/overview_screen.dart';
import 'package:eonix/screens/market_list_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userName;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
  }

  int selectedMenuIndex = 0;

  final List<String> menuTitles = [
    "Vue d'ensemble",
    "Bourse",
    "Analyse",
    "Paramètres"
  ];
  final List<IconData> menuIcons = [
    Icons.dashboard,
    Icons.show_chart,
    Icons.analytics,
    Icons.settings
  ];

  Widget _buildContent() {
    switch (selectedMenuIndex) {
      case 0:
        return OverviewScreen(); // Affiche la vue d'ensemble
      case 1:
        return MarketListScreen(); // Affiche la liste des marchés dans la vue d'ensemble
      case 2:
        return Center(child: Text("Analyse"));
      case 3:
        return Center(child: Text("Paramètres"));
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = userName.split(" ").map((e) => e[0]).take(2).join();

    return Scaffold(
      body: Row(
        children: [
          // 🔹 Barre latérale gauche
          Container(
            width: 255,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo en haut
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset('assets/EONIX.png', height: 80),
                ),

                // Menu principal généré dynamiquement
                for (int i = 0; i < menuTitles.length; i++)
                  if (i < 3) // Les 3 premiers en haut
                    ListTile(
                      leading: Icon(menuIcons[i]),
                      title: Text(menuTitles[i]),
                      selected: selectedMenuIndex == i,
                      onTap: () {
                        setState(() {
                          selectedMenuIndex = i;
                        });
                      },
                    ),
                    Spacer(),

                Divider(),
                // Paramètres en bas
                ListTile(
                  leading: Icon(menuIcons[3]),
                  title: Text(menuTitles[3]),
                  selected: selectedMenuIndex == 3,
                  onTap: () {
                    setState(() {
                      selectedMenuIndex = 3;
                    });
                  },
                ),
              ],
            ),
          ),

          // 🔹 Contenu principal
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.5,
                title: Text(menuTitles[selectedMenuIndex], style: TextStyle(color: Colors.indigo)),
                centerTitle: false,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 16,
                          child: Text(initials, style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        SizedBox(width: 8),
                        Text(userName, style: TextStyle(color: Colors.black87))
                      ],
                    ),
                  )
                ],
              ),
              body: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}
