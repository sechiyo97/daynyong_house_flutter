class Schedule {
  final DateTime date;
  final bool isReserved;
  final String info;

  Schedule({
    required this.date,
    required this.isReserved,
    required this.info,
  });

  factory Schedule.fromCsvRow(List<dynamic> row) {
    dynamic dateParts = row[0].split('/');
    DateTime date = DateTime.utc(int.parse(dateParts[0]),
        int.parse(dateParts[1]), int.parse(dateParts[2]));
    bool isReserved = row[1].isNotEmpty == true;
    String info = row[2].toString();
    return Schedule(
        date: date,
        isReserved: isReserved,
        info: info,
    );
  }
}
