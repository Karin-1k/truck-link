import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trucklink/global/appcolors.dart'; // Ensure this path is correct

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
      appBar: AppBar(
        title: Text("Edit Trip"),
        backgroundColor: AppColors.mainColor, // Set AppBar background color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Origin TextField
              TextField(
                controller: originController,
                decoration: InputDecoration(
                  labelText: "Origin",
                  labelStyle:
                      TextStyle(color: AppColors.mainColor), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded border
                    borderSide:
                        BorderSide(color: AppColors.mainColor), // Border color
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
              ),
              SizedBox(height: 16.0), // Add some spacing

              // Destination TextField
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  labelText: "Destination",
                  labelStyle:
                      TextStyle(color: AppColors.mainColor), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded border
                    borderSide:
                        BorderSide(color: AppColors.mainColor), // Border color
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
              ),
              SizedBox(height: 16.0), // Add some spacing

              // Select Departure Date Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor, // Button color
                ),
                onPressed: () async {
                  departureDate = await showDatePicker(
                    context: context,
                    initialDate: departureDate!,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  setState(() {});
                },
                child: Text(
                  "Select Departure Date",
                  style: TextStyle(
                      color: Colors.white), // White text color inside button
                ),
              ),
              if (departureDate != null)
                Text(
                  "Selected Date: ${departureDate!.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(color: Colors.black),
                ),
              SizedBox(height: 16.0), // Add some spacing

              // Select Departure Time Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor, // Button color
                ),
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
                child: Text(
                  "Select Departure Time",
                  style: TextStyle(
                      color: Colors.white), // White text color inside button
                ),
              ),
              if (departureTime != null)
                Text(
                  "Selected Time: ${departureTime!.toLocal().toString().split(' ')[1].substring(0, 5)}",
                  style: TextStyle(color: Colors.black),
                ),
              SizedBox(height: 16.0), // Add some spacing

              // Save Changes Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor, // Button color
                ),
                onPressed: () {
                  widget.tripData.reference.update({
                    'origin': originController.text,
                    'destination': destinationController.text,
                    'departureDate': departureDate!.toIso8601String(),
                    'departureTime': departureTime!.toIso8601String(),
                  });
                  Get.back();
                },
                child: Text(
                  "Save Changes",
                  style: TextStyle(
                      color: Colors.white), // White text color inside button
                ),
              ),
              SizedBox(height: 16.0), // Add some spacing

              // Cancel Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red color for Cancel button
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.white), // White text color inside button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
