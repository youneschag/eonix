import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatefulWidget {
  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  int index = 0;

  final titles = ['Vue d\'ensemble', 'Marché', 'Historique', 'Paramètres'];
  final routes = ['/portfolio', '/market', '/orders', '/settings'];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 260,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Eonix', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  Divider(),
                  _navTile(0, Icons.dashboard, 'Vue d\'ensemble'),
                  _navTile(1, Icons.show_chart, 'Marché'),
                  _navTile(2, Icons.history, 'Historique'),
                  Spacer(),
                  Divider(),
                  _navTile(3, Icons.settings, 'Paramètres'),
                  SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: Navigator(
                initialRoute: '/portfolio',
                onGenerateRoute: (settings) {
                  Widget page;
                  switch (settings.name) {
                    case '/portfolio':
                      page = Navigator.of(context).widget.pages.isEmpty ? Container() : Container();
                      page = Navigator.of(context).widget.pages.isEmpty ? Container() : Container();
                      page = Container(); // not used
                      break;
                    default:
                      page = Container();
                  }
                  // We'll simply use pushReplacement to root routes of MaterialApp
                  return MaterialPageRoute(builder: (_) {
                    // delegate to main routes by name
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final target = routes[index];
                      if (ModalRoute.of(context)!.settings.name != target) {
                        Navigator.of(context).pushReplacementNamed(target);
                      }
                    });
                    return Center(child: CircularProgressIndicator());
                  });
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Navigator(
          onGenerateRoute: (settings) {
            // Delegate to main app routes
            return MaterialPageRoute(builder: (_) {
              final routeName = routes[index];
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(routeName);
              });
              return Center(child: CircularProgressIndicator());
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Vue'),
            BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Marché'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historique'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
          ],
        ),
      );
    }
  }

  Widget _navTile(int i, IconData icon, String title) {
    final active = index == i;
    return ListTile(
      leading: Icon(icon, color: active ? Colors.indigo : Colors.black54),
      title: Text(title, style: TextStyle(color: active ? Colors.indigo : Colors.black87)),
      selected: active,
      onTap: () {
        setState(() => index = i);
        // navigate to route via main navigator
        final target = routes[i];
        Navigator.of(context).pushReplacementNamed(target);
      },
    );
  }
}
