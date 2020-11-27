class ChapterListModel {
  String message;
  String status;
  Data data;

  ChapterListModel({this.message, this.status, this.data});

  ChapterListModel.fromJson(Map<String, dynamic> json) {
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
  String createdOn;

  Video(
      {this.videoId,
        this.title,
        this.dis,
        this.thumb,
        this.video,
        this.bookId,
        this.chapterId,
        this.createdOn});

  Video.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    title = json['title'];
    dis = json['dis'];
    thumb = json['thumb'];
    video = json['video'];
    bookId = json['book_id'];
    chapterId = json['chapter_id'];
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
    data['created_on'] = this.createdOn;
    return data;
  }
}

class Pdf {
  String pdfId;
  String title;
  String dis;
  String thumb;
  String pdf;
  String bookId;
  String chapterId;
  String createdAt;

  Pdf(
      {this.pdfId,
        this.title,
        this.dis,
        this.thumb,
        this.pdf,
        this.bookId,
        this.chapterId,
        this.createdAt});

  Pdf.fromJson(Map<String, dynamic> json) {
    pdfId = json['pdf_id'];
    title = json['title'];
    dis = json['dis'];
    thumb = json['thumb'];
    pdf = json['pdf'];
    bookId = json['book_id'];
    chapterId = json['chapter_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pdf_id'] = this.pdfId;
    data['title'] = this.title;
    data['dis'] = this.dis;
    data['thumb'] = this.thumb;
    data['pdf'] = this.pdf;
    data['book_id'] = this.bookId;
    data['chapter_id'] = this.chapterId;
    data['created_at'] = this.createdAt;
    return data;
  }
}