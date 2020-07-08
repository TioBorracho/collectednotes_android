class Site {
  final int id;
  final String about;
  final String name;
  final String domain;
  final String headline;
  final String host;
  final int userId;
  final String paymentPlatform;
  final String sitePath;
  final String tinyletter;
  final bool isPremium;
  final bool published;
  final DateTime createdAt;
  final DateTime updatedAt;

  Site({this.id, this.about, this.name, this.domain, this.headline, this.host, this.userId, this.paymentPlatform, this.sitePath, this.tinyletter, this.isPremium, this.published, this.createdAt, this.updatedAt} 
      );

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: json['id'],
      name: json['name'], 
      about: json['about'],
      domain: json['domain'],
      headline: json['headline'],
      host: json['host'],
    userId: json['user_id'],
      paymentPlatform: json['payment_platform'],
    sitePath: json['site_path'],
    tinyletter: json['tinyletter'],
    isPremium: json['is_remium'],
    published: json['published'],
    createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

