class Guard {
  final String guardName;
  final String type;
  final String slotTitle;
  final String startTime;
  final String endTime;
  final int frequency;
  final bool status;

  Guard(
      {this.guardName,
      this.type,
      this.slotTitle,
      this.startTime,
      this.endTime,
      this.frequency,
      this.status});

  factory Guard.fromJson(
      Map<String, dynamic> json1, Map<String, dynamic> json2) {
    return Guard(
      guardName: json1['guard_name'],
      type: json1['type'],
      status: json1['status'],
      slotTitle: json2['slot_title'],
      startTime: json2['start_time'],
      endTime: json2['end_time'],
      frequency: json2['frequency'],
    );
  }
}
