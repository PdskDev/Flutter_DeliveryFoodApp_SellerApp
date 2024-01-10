class Menus {
  String? nemuID;
  String? sellerUID;
  String? nemuTitle;
  String? nemuShortInfo;
  String? menuImageURL;
  //String? publishedDate;
  String? status;

  Menus({
    this.nemuID,
    this.sellerUID,
    this.nemuTitle,
    this.nemuShortInfo,
    this.menuImageURL,
    //this.publishedDate,
    this.status
});

  Menus.fromJson(Map<String, dynamic> json)
  {
    nemuID = json["nemuID"];
    sellerUID = json["sellerUID"];
    nemuTitle = json["nemuTitle"];
    nemuShortInfo = json["nemuShortInfo"];
    menuImageURL = json["menuImageURL"];
    //publishedDate = json["publishedDate"].toString();
    status = json["status"];
  }

  Map<String , dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nemuID'] = nemuID;
    data['sellerUID'] = sellerUID;
    data['nemuTitle'] = nemuTitle;
    data['nemuShortInfo'] = nemuShortInfo;
    data['menuImageURL'] = menuImageURL;
    //data['publishedDate'] = publishedDate;
    data['status'] = status;

    return data;
  }



}