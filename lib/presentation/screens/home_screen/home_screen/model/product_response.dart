class ProductResponse {
  int? status;
  String? message;
  List<ResultData>? result;

  ProductResponse({this.status, this.message, this.result});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Result'] != null) {
      result = <ResultData>[];
      json['Result'].forEach((v) {
        result!.add(new ResultData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.result != null) {
      data['Result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResultData {
  String? name;
  String? priceCode;
  String? imageName;
  int? id;

  ResultData({this.name, this.priceCode, this.imageName, this.id});

  ResultData.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    priceCode = json['PriceCode'];
    imageName = json['ImageName'];
    id = json['Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['PriceCode'] = this.priceCode;
    data['ImageName'] = this.imageName;
    data['Id'] = this.id;
    return data;
  }
}