class Schedule {
  final DateTime date;
  final bool isReserved;
  final String info;

  Schedule({
    required this.date,
    required this.isReserved,
    required this.info,
  });

  factory Schedule.fromGoogleSheetRow(List<dynamic> row) {
    dynamic dateParts = row[0].split('/');
    DateTime date = DateTime.utc(int.parse(dateParts[0]),
        int.parse(dateParts[1]), int.parse(dateParts[2]));
    bool isReserved = (row.length > 1) ? row[1].isNotEmpty == true : false;
    String info = (row.length > 2) ? row[2].toString() : "";
    return Schedule(
        date: date,
        isReserved: isReserved,
        info: info,
    );
  }
}
