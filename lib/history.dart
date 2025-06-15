
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'sql.dart';
import 'fire.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}


String formatDate(dynamic date) {
  if (date is Timestamp) {
    return date.toDate().toString(); // or use DateFormat for pretty print
  } else if (date is String) {
    try {
      return DateTime.parse(date).toString(); // also format if needed
    } catch (_) {
      return date; // fallback if it's not a real ISO string
    }
  } else {
    return 'Unknown date format';
  }
}
class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> records = [];

  Future<void> fetchData() async {
    print('Connecting to DB');

    // Get data from your database
    final data = await getData(); // Make sure getData() returns Future<List>

    // Now update state synchronously
    setState(() {
      records = data;
    });
    print("📦 Received: $records");
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Automatically fetch data when the widget loads
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: records.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: true, // Prevents infinite height issue inside scroll
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];//get records
            final rawDate = formatDate( record['date'] ?? ''); //recognize dateTime
            final str = record['value'] ?? ''; //get strings
            String formattedDate;
            try {  // convert dataTime to desired formatted string
              final parsedDate = DateTime.parse(rawDate).toLocal();
              formattedDate =
              '${parsedDate.year.toString().padLeft(4, '0')}-'
                  '${parsedDate.month.toString().padLeft(2, '0')}-'
                  '${parsedDate.day.toString().padLeft(2, '0')} '
                  '${parsedDate.hour.toString().padLeft(2, '0')}:'
                  '${parsedDate.minute.toString().padLeft(2, '0')}:'
                  '${parsedDate.second.toString().padLeft(2, '0')}';
            } catch (_) {
              formattedDate = rawDate; // fallback if parsing fails
            }
            return ListTile(
              title: Text('[$formattedDate] $str'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await clearHistory();  // You should make sure this is async
          await fetchData();     // Refresh the list after clearing
          setState(() {});       // Trigger rebuild
        },
        tooltip: 'Clear History',
        child: const Icon(Icons.delete),
      ),
    );
  }
}





