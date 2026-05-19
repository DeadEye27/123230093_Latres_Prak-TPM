class SpaceItem {
  final int id;
  final String title;
  final String newsSite;
  final String? imageUrl;
  final String? summary;
  final String? publishedAt;
  final String? url;

  SpaceItem({
    required this.id,
    required this.title,
    required this.newsSite,
    this.imageUrl,
    this.summary,
    this.publishedAt,
    this.url,
  });

  factory SpaceItem.fromJson(Map<String, dynamic> json) {
    return SpaceItem(
      id: json['id'],
      title: json['title'] ?? '',
      newsSite: json['news_site'] ?? '',
      imageUrl: json['image_url'],
      summary: json['summary'],
      publishedAt: json['published_at'],
      url: json['url'],
    );
  }
}