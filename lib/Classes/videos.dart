class Videos {
  String id;
  String title;
  String description;
  String createdon;
  String filename;
  String duration;
  String type;
  String tags;
  String poster;

Videos(
      String id,
      String title,
      String description,
      String createdon,
      String filename,
      String duration,
      String type,
      String tags,
      String poster) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.createdon = createdon;
    this.filename = filename;
    this.duration = duration;
    this.type = type;
    this.tags = tags;
    this.poster = poster;
  }
  Videos.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        createdon = json['createdon'],
        filename = json['filename'],
        duration = json['duration'],
        type = json['type'],
        tags = json['tags'],
        poster = json['poster'];

  Map toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdon': createdon,
      'filename': filename,
      'duration': duration,
      'type': type,
      'tags': tags,
      'poster': poster
    };
  }
}