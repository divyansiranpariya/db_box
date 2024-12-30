class Todo {
  int? id;
  String title;
  bool isBookmarked;

  Todo({
    this.id,
    required this.title,
    this.isBookmarked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      isBookmarked: map['isBookmarked'] == 1,
    );
  }
}
