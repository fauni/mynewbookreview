class Book {
  String? id;
  String? title;
  String? subtitle;
  List<String>? authors;
  String? publisher;
  String? publishedDate;
  String? description;
  List<String>? categories;
  double? averageRating;
  int? ratingsCount;
  String? shelf;
  ImageLinks? imageLinks;

  Book({
    this.id,
    this.title,
    this.subtitle,
    this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.categories,
    this.averageRating,
    this.ratingsCount,
    this.shelf,
    this.imageLinks,
  });

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    authors = json['authors']?.cast<String>();
    publisher = json['publisher'];
    publishedDate = json['publishedDate'];
    description = json['description'];
    categories = json['categories']?.cast<String>();
    averageRating = (json['averageRating'] != null)
        ? double.tryParse(json['averageRating'].toString())
        : null;
    ratingsCount = json['ratingsCount'];
    shelf = json['shelf'];
    imageLinks = json['imageLinks'] != null
        ? ImageLinks.fromJson(json['imageLinks'])
        : null;
  }
}

class ImageLinks {
  String? smallThumbnail;
  String? thumbnail;

  ImageLinks({this.smallThumbnail, this.thumbnail});

  ImageLinks.fromJson(Map<String, dynamic> json) {
    smallThumbnail = json['smallThumbnail'];
    thumbnail = json['thumbnail'];
  }
}
