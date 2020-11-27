class HomeData {
  String message;
  String status;
  List<Data> data;

  HomeData();

 // HomeData({this.message, this.status, this.data});

  HomeData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String bookImage;
  String book_id;
  List<Chapter> chapter;

  Data();
//  Data({this.bookImage, this.chapter});

  Data.fromJson(Map<String, dynamic> json) {
    bookImage = json['book_image'];
    book_id=json["book_id"];
    if (json['chapter'] != null) {
      chapter = new List<Chapter>();
      json['chapter'].forEach((v) {
        chapter.add(new Chapter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_image'] = this.bookImage;
    if (this.chapter != null) {
      data['chapter'] = this.chapter.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chapter {
  String chapterId;
  String bookId;
  String name;
  String image;
  String createdOn;

  Chapter(this.chapterId, this.bookId, this.name, this.image, this.createdOn);

  Chapter.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapter_id'];
    bookId = json['book_id'];
    name = json['name'];
    image = json['image'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapter_id'] = this.chapterId;
    data['book_id'] = this.bookId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['created_on'] = this.createdOn;
    return data;
  }
}