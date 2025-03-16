import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(title: Text("Post a Trip")),
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
              SizedBox(height: 30),
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
                child: Text("Select Departure Date"),
              ),
              if (departureDate != null) 
                Text(
                  "Selected Date: ${departureDate!.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
                child: Text("Select Departure Time"),
              ),
              if (departureTime != null) 
                Text(
                  "Selected Time: ${departureTime!.format(context)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 20),
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
                child: Text("Post Trip"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
