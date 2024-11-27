class Registration {
  String eventName;
  String userName;

  Registration({
    required this.eventName,
    required this.userName,
  });

  Registration.fromMap(Map<String, dynamic> result)
      : eventName = result['eventName'],
        userName = result['userName'];

  Map<String, Object?> toMap() {
    return {
      'eventName' : eventName,
      'userName' : userName
    };
  }
}