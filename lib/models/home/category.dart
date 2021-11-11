class Category {
  String name;
  String pathImage;
  bool selected;

  Category({
    required this.name,
    required this.pathImage,
    this.selected = false,
  });

  @override
  String toString() {
    return 'Category{name: $name, pathImage: $pathImage, selected: $selected}';
  }
}
