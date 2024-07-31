class Note {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final DateTime lastUpdated; // الحقل الجديد لتاريخ التحديث

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.lastUpdated, // التعديل هنا
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate;
    DateTime parsedLastUpdated;

    try {
      parsedDate = DateTime.parse(map['date']);
    } catch (e) {
      try {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(map['date']));
      } catch (e) {
        parsedDate = DateTime.now();
      }
    }

    try {
      parsedLastUpdated = DateTime.parse(map['lastUpdated']);
    } catch (e) {
      try {
        parsedLastUpdated = DateTime.fromMillisecondsSinceEpoch(int.parse(map['lastUpdated']));
      } catch (e) {
        parsedLastUpdated = DateTime.now();
      }
    }
    
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: parsedDate,
      lastUpdated: parsedLastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(), // التعديل هنا
    };
  }
}
