
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> addRecord(String s) async {
  try {
    await FirebaseFirestore.instance.collection('calculations').add({
      'date': Timestamp.now(),
      'value': s,
    });
    print("✅ Record Added");
  } catch (error) {
    print("❌ Failed to add record: $error");
  }
}


Future<List<dynamic>> getData() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('calculations').get();

    // Convert each document to a Map<String, dynamic>
    List<dynamic> dataList = snapshot.docs.map((doc) => doc.data()).toList();
    print("✅ Data read successfully");
    return dataList;
  } catch (e) {
    print('❌ Error fetching data: $e');
    return [];
  }
}

Future<void> clearHistory() async {
  try {
    // Get all documents in the collection
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('calculations').get();
    // Loop through each document and delete it
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
    print('✅ All documents have been deleted.');
  } catch (e) {
    print('❌ Error deleting documents: $e');
  }
}