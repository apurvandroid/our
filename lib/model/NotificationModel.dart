class NotificationModel {
  String message;
  String status;
  List<DataNotification> data;

  NotificationModel({this.message, this.status, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<DataNotification>();
      json['data'].forEach((v) {
        data.add(new DataNotification.fromJson(v));
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

class DataNotification{
  String pushId;
  String title;
  String dis;
  String createdOn;

  DataNotification({this.pushId, this.title, this.dis, this.createdOn});

  DataNotification.fromJson(Map<String, dynamic> json) {
    pushId = json['push_id'];
    title = json['title'];
    dis = json['dis'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['push_id'] = this.pushId;
    data['title'] = this.title;
    data['dis'] = this.dis;
    data['created_on'] = this.createdOn;
    return data;
  }
}