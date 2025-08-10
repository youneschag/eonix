import 'package:flutter/material.dart';
import 'package:eonix/class/PerfTile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class OverviewScreen extends StatefulWidget {
  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  DateTimeRange selectedRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 7)),
    end: DateTime.now(),
  );

  // Exemple de données dynamiques pour le graphique
  List<double> perfData = [100, 102, 101, 105, 107, 110, 108, 112];

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Exemple de montants dynamiques (à remplacer par tes vraies données)
    final double liquidites = 20000;
    final double compteBourse = 100000;
    final double total = liquidites + compteBourse;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Solde total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 8),

          // Cartes horizontales pour chaque compte
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Card(
                  margin: EdgeInsets.only(right: 12),
                  child: Container(
                    width: 180,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Liquidités", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text("${liquidites.toStringAsFixed(0)} MAD", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(right: 12),
                  child: Container(
                    width: 180,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Compte bourse", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text("${compteBourse.toStringAsFixed(0)} MAD", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                // Ajoute d'autres comptes ici si besoin
              ],
            ),
          ),

          SizedBox(height: 16),
          // ...le reste de la section (total, bouton, etc.)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total :", style: TextStyle(fontSize: 16)),
              Text("${total.toStringAsFixed(0)} MAD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo)),
            ],
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Ajouter un compte"),
            ),
          ),

          SizedBox(height: 24),
          Text("Performance globale", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),

          // Plage de dates sélectionnée
          Row(
            children: [
              Text(
                "Du ${dateFormat.format(selectedRange.start)} au ${dateFormat.format(selectedRange.end)}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 12),
              TextButton(
                onPressed: () async {
                  DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    initialDateRange: selectedRange,
                  );
                  if (picked != null) {
                    setState(() {
                      selectedRange = picked;
                      // Ici, recharge tes données perfData et pourcentages selon la nouvelle plage
                    });
                  }
                },
                child: Text("Modifier", style: TextStyle(color: Colors.indigo)),
              ),
            ],
          ),

          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PerfTile(label: "Jour", value: "+0,5%", color: Colors.green),
                  PerfTile(label: "Semaine", value: "+2,5%", color: Colors.green),
                  PerfTile(label: "Mois", value: "-1,2%", color: Colors.red),
                  PerfTile(label: "Année", value: "+8,7%", color: Colors.green),
                ],
              ),
            ),
          ),

          SizedBox(height: 12),
          // Graphique d'évolution sur la plage sélectionnée
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          perfData.length,
                          (i) => FlSpot(i.toDouble(), perfData[i]),
                        ),
                        isCurved: true,
                        color: Colors.indigo,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) => Text(
                            value.toStringAsFixed(0),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 2, // Affiche une date sur deux (adapte selon perfData)
                          getTitlesWidget: (value, meta) {
                            int idx = value.toInt();
                            if (idx < 0 || idx >= perfData.length) return Container();
                            // Exemple : affiche la date du point (adapte selon tes vraies dates)
                            DateTime date = selectedRange.start.add(Duration(days: idx));
                            return Text(
                              DateFormat('dd/MM').format(date),
                              style: TextStyle(fontSize: 11),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 24),
          Text("Derniers mouvements", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.arrow_upward, color: Colors.green),
                  title: Text("Achat - BMCE"),
                  subtitle: Text("12/08/2025"),
                  trailing: Text("-2 000 MAD"),
                ),
                ListTile(
                  leading: Icon(Icons.arrow_downward, color: Colors.red),
                  title: Text("Vente - ATW"),
                  subtitle: Text("10/08/2025"),
                  trailing: Text("+1 500 MAD"),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text("Répartition du portefeuille", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Liquidités vs Bourse
              Column(
                children: [
                  Text("Liquidités vs Bourse", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: liquidites,
                            color: Colors.blue,
                            title: "Liquidités\n${((liquidites/(liquidites+compteBourse))*100).toStringAsFixed(1)}%",
                            radius: 50,
                            titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: compteBourse,
                            color: Colors.indigo,
                            title: "Bourse\n${((compteBourse/(liquidites+compteBourse))*100).toStringAsFixed(1)}%",
                            radius: 50,
                            titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // 2. Répartition par type d’actif
              Column(
                children: [
                  Text("Par type d’actif", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 60000,
                            color: Colors.orange,
                            title: "Actions\n60%",
                            radius: 50,
                            titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 40000,
                            color: Colors.green,
                            title: "ETF\n40%",
                            radius: 50,
                            titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // 3. Répartition par action dans un actif
              Column(
                children: [
                  Text("Actions (exemple)", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 30000,
                            color: Colors.purple,
                            title: "BMCE\n50%",
                            radius: 50,
                            titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 30000,
                            color: Colors.teal,
                            title: "ATW\n50%",
                            radius: 50,
                            titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Ajoute ici d'autres camemberts si besoin, ils seront répartis automatiquement
            ],
          ),
        ],
      ),
    );
  }
}