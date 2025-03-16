import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripEditScreen extends StatefulWidget {
  final String tripId;
  final DocumentSnapshot tripData;

  TripEditScreen({required this.tripId, required this.tripData});

  @override
  _TripEditScreenState createState() => _TripEditScreenState();
}

class _TripEditScreenState extends State<TripEditScreen> {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  DateTime? departureDate;
  DateTime? departureTime;

  @override
  void initState() {
    super.initState();
    originController.text = widget.tripData["origin"];
    destinationController.text = widget.tripData["destination"];
    departureDate = DateTime.parse(widget.tripData["departureDate"]);
    departureTime = DateTime.parse(widget.tripData["departureTime"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Trip")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: originController,
                decoration: InputDecoration(labelText: "Origin"),
              ),
              TextField(
                controller: destinationController,
                decoration: InputDecoration(labelText: "Destination"),
              ),
              ElevatedButton(
                onPressed: () async {
                  departureDate = await showDatePicker(
                    context: context,
                    initialDate: departureDate!,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  setState(() {}); 
                },
                child: Text("Select Departure Date"),
              ),
              if (departureDate != null)
                Text(
                    "Selected Date: ${departureDate!.toLocal().toString().split(' ')[0]}"),
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(departureTime!),
                  );
                  if (time != null) {
                    departureTime = DateTime(
                      departureDate!.year,
                      departureDate!.month,
                      departureDate!.day,
                      time.hour,
                      time.minute,
                    );
                    setState(() {}); 
                  }
                },
                child: Text("Select Departure Time"),
              ),
              if (departureTime != null)
                Text(
                    "Selected Time: ${departureTime!.toLocal().toString().split(' ')[1].substring(0, 5)}"),
              ElevatedButton(
                onPressed: () {
                  widget.tripData.reference.update({
                    'origin': originController.text,
                    'destination': destinationController.text,
                    'departureDate': departureDate!.toIso8601String(),
                    'departureTime': departureTime!.toIso8601String(),
                  });
                  Get.back(); 
                },
                child: Text("Save Changes"),
              ),
              // Cancel Button
              ElevatedButton(
                onPressed: () {
                  Get.back(); 
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
