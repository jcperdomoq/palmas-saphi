class Category {
  final String name;
  final String pathImage;
  final bool selected;

  Category({
    required this.name,
    required this.pathImage,
    this.selected = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'pathImage': pathImage,
        'selected': selected,
      };

  @override
  String toString() {
    return 'Category{name: $name, pathImage: $pathImage, selected: $selected}';
  }
}
