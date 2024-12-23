import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new event
  Future<void> createEvent(Event event) async {
    try {
      await _db.collection('events').add(event.toMap());
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  // Retrieve all events
  Future<List<Event>> getEvents() async {
    try {
      final snapshot = await _db.collection('events').get();
      return snapshot.docs.map((doc) => Event.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Error retrieving events: $e');
    }
  }

  // Update an existing event
  Future<void> updateEvent(Event event) async {
    try {
      await _db.collection('events').doc(event.id).update(event.toMap());
    } catch (e) {
      throw Exception('Error updating event: $e');
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _db.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }

  // Retrieve events for a specific user
  Future<List<Event>> getUserEvents(String userId) async {
    try {
      final snapshot = await _db
          .collection('events')
          .where('userId', isEqualTo: userId)
          .get();

      final userEvents = snapshot.docs
          .map((doc) => Event.fromMap(doc.data(), doc.id))
          .toList();

      return userEvents;
    } catch (e) {
      throw Exception('Error retrieving user events: $e');
    }
  }

  // Fetch the list of users who have subscribed/booked the event
  Future<List<String>> getSubscribedUsers(String eventId) async {
    try {
      final subscribedUsersSnapshot = await _db
          .collection('subscriptions')
          .where('eventId', isEqualTo: eventId) // Query for specific event
          .get();

      List<String> userIds = [];
      for (var doc in subscribedUsersSnapshot.docs) {
        userIds.add(doc['userId']);
      }
      return userIds;
    } catch (e) {
      throw Exception('Error fetching subscribed users: $e');
    }
  }

  // Fetch event details by eventId
  Future<Event> getEventById(String eventId) async {
    try {
      final eventDoc = await _db.collection('events').doc(eventId).get();
      if (eventDoc.exists) {
        final eventData = eventDoc.data();
        return Event(
          id: eventDoc.id,
          title: eventData?['title'] ?? 'Untitled Event',
          description: eventData?['description'] ?? 'No description available',
          date: (eventData?['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          userId: eventData?['userId'] ?? 'Unknown User',
        );
      } else {
        throw Exception('Event not found');
      }
    } catch (e) {
      throw Exception('Error fetching event: $e');
    }
  }



}
