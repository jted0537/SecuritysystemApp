class Work {
  final String workId;
  final List<int> responseCntList;
  final List<String> alarmTimeList;

  Work({
    this.workId,
    this.responseCntList,
    this.alarmTimeList,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      workId: json['work_id'],
      responseCntList: json['response_cnt'],
      alarmTimeList: json['alarm_time_list'] ? json['alarm_time_list'] : null,
    );
  }
}
