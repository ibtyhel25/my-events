class Event {
  String id;
  String title;
  String description;
  DateTime date;
  String userId; // Add the userId field

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.userId, // Initialize userId
  });

  // Convert the Event object to a Map to store in Firestore or other databases
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'userId': userId, // Add userId to the map
    };
  }

  // Create an Event object from a Map
  Event.fromMap(Map<String, dynamic> map, String id)
      : id = id,
        title = map['title'],
        description = map['description'],
        date = DateTime.parse(map['date']),
        userId = map['userId']; // Extract userId from the map
}
