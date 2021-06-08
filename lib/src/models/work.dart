class Work {
  final String workId;
  final List<bool> responseCntList;
  final List<String> alarmTimeList;

  Work({
    this.workId,
    this.responseCntList,
    this.alarmTimeList,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    var list = json['response_cnt'] as List;
    var list2 = json['alarmTime_list'] as List;
    List<bool> responseList = List<bool>.from(list);
    List<String> alarmTimeList = List<String>.from(list2);
    return Work(
      workId: json['work_id'],
      responseCntList: responseList,
      alarmTimeList: alarmTimeList,
    );
  }
}
