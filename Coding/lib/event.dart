class Event {
  String? id;
  String name;
  String address;
  String date;
  String startTime;
  String endTime;

  Event({
    this.id,
    required this.name,
    required this.address,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      date: data['date'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
    );
  }

  factory Event.fromMapWithID(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      date: data['date'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
