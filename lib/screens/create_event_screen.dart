import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/event_service.dart';
import '../models/event.dart';

class CreateEventScreen extends StatefulWidget {
  final String userId; // userId passed into the screen

  // Accept userId in the constructor
  CreateEventScreen({required this.userId});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _eventDate;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final EventService _eventService = EventService();

  // Create event logic
  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) {
      return; // If the form is not valid, return
    }

    setState(() {
      _isLoading = true;
    });

    final event = Event(
      id: '', // ID will be generated by Firestore or your backend
      title: _titleController.text,
      description: _descriptionController.text,
      date: _eventDate!,
      userId: widget.userId, // Using the userId passed into the widget
    );

    try {
      await _eventService.createEvent(event); // Calling the service to create the event
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event Created Successfully!')));
      Navigator.pop(context); // Go back after creating the event
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Date picker logic
  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _eventDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // Associate the form with the key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Event Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Event Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Event Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Event Date
              Row(
                children: [
                  Text(
                    _eventDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(_eventDate!),
                    style: TextStyle(fontSize: 16, color: _eventDate == null ? Colors.red : Colors.black),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: Icon(Icons.calendar_today),
                    label: Text('Pick Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Loading indicator or Create Event button
              _isLoading
                  ? Center(child: CircularProgressIndicator()) // Show loading indicator while event is being created
                  : ElevatedButton(
                onPressed: _createEvent,
                child: Text('Create Event'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}