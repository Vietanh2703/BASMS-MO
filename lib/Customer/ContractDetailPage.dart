import 'package:adoan/Customer/location_map_page.dart';
import 'package:flutter/material.dart';

class ContractDetailPage extends StatelessWidget {
  final Map<String, dynamic> contract;
  final List locations;

  const ContractDetailPage({
    super.key,
    required this.contract,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    final shifts = contract["shiftSchedules"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(contract["contractTitle"]),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: shifts.length,
        itemBuilder: (_, i) {
          final shift = shifts[i];

          final location = locations.firstWhere(
                (l) => l["id"] == shift["locationId"],
          );

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(shift["scheduleName"]),
              subtitle: Text(
                "${shift["shiftStartTime"]} - ${shift["shiftEndTime"]}",
              ),
              trailing: const Icon(Icons.map),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LocationMapPage(location: location),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
