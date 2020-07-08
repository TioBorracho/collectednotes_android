class Note {
  final int id;
  final int siteId;
  final int userId;
  final String body;
  final String path;
  final String headline;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String visibility; // TODO: Change to ENUM
  final String url;

  Note(
      {this.id,
      this.siteId,
      this.userId,
      this.body,
      this.path,
      this.headline,
      this.title,
      this.createdAt,
      this.updatedAt,
      this.visibility,
      this.url});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      siteId: json['site_id'],
      userId: json['user_id'],
      body: json['body'],
      path: json['path'],
      headline: json['headline'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      visibility: json['visibility'],
      url: json['url'],
    );
  }
}
