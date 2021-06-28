// For guard information
class Guard {
  final String id;
  final String guardName;
  final String type;
  bool status;
  final String slotTitle;
  final String startTime;
  final String endTime;
  final int frequency;

  Guard({
    this.id,
    this.guardName,
    this.type,
    this.status,
    this.slotTitle,
    this.startTime,
    this.endTime,
    this.frequency,
  });

  // Convert json type to Guard object
  factory Guard.fromJson(
      Map<String, dynamic> json1, Map<String, dynamic> json2) {
    return Guard(
      id: json1['employee_id'],
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
