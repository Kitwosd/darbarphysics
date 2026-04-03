class PackageCourse {
  final int id;
  final String title;
  final String image;
  final String cost;

  PackageCourse({
    required this.id,
    required this.title,
    required this.image,
    required this.cost,
  });

  factory PackageCourse.fromJson(Map<String, dynamic> json) {
    return PackageCourse(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      cost: json['cost'] ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'image': image, 'cost': cost};
  }
}
