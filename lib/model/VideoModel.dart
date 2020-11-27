class VideoModel {
  String message;
  String status;
  Data data;

  VideoModel({this.message, this.status, this.data});

  VideoModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Video> video;
  List<Pdf> pdf;

  Data({this.video, this.pdf});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['video'] != null) {
      video = new List<Video>();
      json['video'].forEach((v) {
        video.add(new Video.fromJson(v));
      });
    }
    if (json['pdf'] != null) {
      pdf = new List<Pdf>();
      json['pdf'].forEach((v) {
        pdf.add(new Pdf.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.video != null) {
      data['video'] = this.video.map((v) => v.toJson()).toList();
    }
    if (this.pdf != null) {
      data['pdf'] = this.pdf.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Video {
  String videoId;
  String title;
  String dis;
  String thumb;
  String video;
  String bookId;
  String chapterId;
  String type;
  String createdOn;

  Video(
      {this.videoId,
        this.title,
        this.dis,
        this.thumb,
        this.video,
        this.bookId,
        this.chapterId,
        this.type,
        this.createdOn});

  Video.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    title = json['title'];
    dis = json['dis'];
    thumb = json['thumb'];
    video = json['video'];
    bookId = json['book_id'];
    chapterId = json['chapter_id'];
    type = json['type'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    data['title'] = this.title;
    data['dis'] = this.dis;
    data['thumb'] = this.thumb;
    data['video'] = this.video;
    data['book_id'] = this.bookId;
    data['chapter_id'] = this.chapterId;
    data['type'] = this.type;
    data['created_on'] = this.createdOn;
    return data;
  }
}

class Pdf {
  String chapterId;
  String bookId;
  String name;
  String image;
  String createdOn;

  Pdf({this.chapterId, this.bookId, this.name, this.image, this.createdOn});

  Pdf.fromJson(Map<String, dynamic> json) {
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