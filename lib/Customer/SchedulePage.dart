import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/contract_service.dart';
import 'ContractDetailPage.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool loading = true;
  List contracts = [];
  List locations = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");

    final customerId =
    await ContractService.getCustomerIdByEmail(email!);

    final data =
    await ContractService.getCustomerContracts(customerId);

    setState(() {
      contracts = data["contracts"] ?? [];
      locations = data["locations"] ?? [];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch & Hợp đồng"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contracts.length,
        itemBuilder: (_, i) {
          final c = contracts[i];
          return Card(
            child: ListTile(
              title: Text(c["contractTitle"]),
              subtitle: Text(
                "${c["startDate"].substring(0, 10)} → ${c["endDate"].substring(0, 10)}",
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContractDetailPage(
                      contract: c,
                      locations: locations,
                    ),
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
