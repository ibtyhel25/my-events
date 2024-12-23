import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/event_service.dart';
import '../models/event.dart';

class UpdateEventScreen extends StatefulWidget {
  final Event event;
  final String userId;

  UpdateEventScreen({required this.event, required this.userId});

  @override
  _UpdateEventScreenState createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _eventDate;

  final EventService _eventService = EventService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(text: widget.event.description);
    _eventDate = widget.event.date;
  }

  // Update event method with validation and userId
  Future<void> _updateEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_eventDate != null) {
        try {
          setState(() {
            _isLoading = true;
          });
          final updatedEvent = Event(
            id: widget.event.id,
            title: _titleController.text,
            description: _descriptionController.text,
            date: _eventDate!,
            userId: widget.userId,
          );
          await _eventService.updateEvent(updatedEvent);
          Navigator.pop(context, updatedEvent); // Return the updated event to the previous screen
        } catch (e) {
          _showErrorDialog('Error updating event: $e');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        _showErrorDialog('Please select a valid event date.');
      }
    }
  }

  // Date picker method
  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _eventDate = pickedDate;
      });
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Icon(Icons.error_outline, color: Colors.red, size: 40),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Event', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Event Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Event Title',
                    labelStyle: TextStyle(color: Colors.black87),
                    hintText: 'Enter event title',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Event Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Event Description',
                    labelStyle: TextStyle(color: Colors.black87),
                    hintText: 'Enter event description',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Event Date Picker
                Text(
                  _eventDate == null
                      ? 'Select Date'
                      : DateFormat('yyyy-MM-dd').format(_eventDate!),
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'Pick Date',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                SizedBox(height: 20),

                // Update Event Button with loading indicator and centered button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: _updateEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Update Event',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
