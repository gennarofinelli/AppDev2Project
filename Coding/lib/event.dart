class Event{
  String date;
  String name;
  String address;
  String startTime;
  String endTime;

  Event({
    required this.date,
    required this.name,
    required this.address,
    required this.startTime,
    required this.endTime
  });

  Event.fromMap(Map<String, dynamic> result)
      : date = result['eventDate'],
        name = result['name'],
        address = result['address'],
        startTime = result['startTime'],
        endTime = result['endTime'];

  Map<String, Object?> toMap() {
    return {
      'eventDate': date,
      'name': name,
      'address': address,
      'startTime': startTime,
      'endTime' : endTime,
    };
  }
}