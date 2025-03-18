import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/state_managment/drivercontroller/trip_controller.dart';

class TripPostingScreen extends StatefulWidget {
  @override
  _TripPostingScreenState createState() => _TripPostingScreenState();
}

class _TripPostingScreenState extends State<TripPostingScreen> {
  final TripController tripController = Get.put(TripController());
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  DateTime? departureDate;
  TimeOfDay? departureTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post a Trip"),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align text to the start for better readability
            children: [
              SizedBox(height: 30,),
              // Origin Input
              TextField(
                controller: originController,
                style: const TextStyle(
                    color:
                        Colors.black), // White text color inside text field
                decoration: InputDecoration(
                  labelText: "Origin",
                  labelStyle: const TextStyle(
                      color: Colors.black), // White label text
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 10),
                ),
              ),
              const SizedBox(height: 15),
      
              // Destination Input
              TextField(
                controller: destinationController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Destination",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 10),
                ),
              ),
              const SizedBox(height: 30),
      
              // Select Departure Date
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      departureDate = pickedDate;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.mainColor, // Using the custom primary color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  "Select Departure Date",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (departureDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Selected Date: ${departureDate!.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
      
              const SizedBox(height: 20),
      
              // Select Departure Time
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      departureTime = pickedTime;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.mainColor, // Using the custom primary color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                ),
                child: const Text("Select Departure Time",
                    style: TextStyle(color: Colors.white)),
              ),
              if (departureTime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Selected Time: ${departureTime!.format(context)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
      
              const SizedBox(height: 30),
      
              // Post Trip Button
              ElevatedButton(
                onPressed: () {
                  if (departureTime != null && departureDate != null) {
                    final selectedDepartureDateTime = DateTime(
                      departureDate!.year,
                      departureDate!.month,
                      departureDate!.day,
                      departureTime!.hour,
                      departureTime!.minute,
                    );
      
                    tripController.createTrip(
                      originController.text,
                      destinationController.text,
                      selectedDepartureDateTime,
                      departureDate!,
                    );
                  } else {
                    Get.snackbar("Error", "Please select both date and time");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.mainColor, // Using the custom primary color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                ),
                child: const Text("Post Trip",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
