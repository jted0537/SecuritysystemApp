// For each Work
class Work {
  final String workId;
  final List<int> responseCntList;
  final List<String> alarmTimeList;

  Work({
    this.workId,
    this.responseCntList,
    this.alarmTimeList,
  });

  // Convert json type to Work object
  factory Work.fromJson(Map<String, dynamic> json) {
    var list = json['response_cnt'] as List;
    var list2 =
        json['alarmTime_list'] == null ? null : json['alarmTime_list'] as List;
    List<int> responseList = List<int>.from(list);
    List<String> alarmTimeList =
        list2 == null ? null : List<String>.from(list2);
    return Work(
      workId: json['work_id'],
      responseCntList: responseList,
      alarmTimeList: alarmTimeList == null ? null : alarmTimeList,
    );
  }
}
