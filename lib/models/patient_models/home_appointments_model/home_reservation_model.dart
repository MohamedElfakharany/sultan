class HomeReservationsModel {
  bool? status;
  dynamic message;
  List<HomeReservationsDataModel>? data;
  Extra? extra;
  Errors? errors;

  HomeReservationsModel(
      {this.status, this.message, this.data, this.extra, this.errors});

  HomeReservationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HomeReservationsDataModel>[];
      json['data'].forEach((v) {
        data!.add(HomeReservationsDataModel.fromJson(v));
      });
    }
    extra = json['extra'] != null ? Extra.fromJson(json['extra']) : null;
    errors =
        json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class HomeReservationsDataModel {
  dynamic id;
  dynamic date;
  dynamic time;
  List<Null>? family;
  Address? address;
  Branch? branch;
  List<Null>? coupon;
  dynamic price;
  dynamic tax;
  dynamic discount;
  dynamic total;
  dynamic status;
  dynamic statusEn;
  dynamic rate;
  dynamic rateMessage;
  CreatedAt? createdAt;
  List<Tests>? tests;
  List<Offers>? offers;
  List<Null>? technical;

  HomeReservationsDataModel(
      {this.id,
      this.date,
      this.time,
      this.family,
      this.address,
      this.branch,
      this.coupon,
      this.price,
      this.tax,
      this.discount,
      this.total,
      this.status,
      this.statusEn,
      this.rate,
      this.rateMessage,
      this.createdAt,
      this.tests,
      this.offers,
      this.technical});

  HomeReservationsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    // if (json['family'] != null) {
    //   family = <Null>[];
    //   json['family'].forEach((v) { family!.add(new Null.fromJson(v)); });
    // }
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    branch =
        json['branch'] != null ? Branch.fromJson(json['branch']) : null;
    // if (json['coupon'] != null) {
    //   coupon = <Null>[];
    //   json['coupon'].forEach((v) { coupon!.add(new Null.fromJson(v)); });
    // }
    price = json['price'];
    tax = json['tax'];
    discount = json['discount'];
    total = json['total'];
    status = json['status'];
    statusEn = json['statusEn'];
    rate = json['rate'];
    rateMessage = json['rateMessage'];
    createdAt = json['created_at'] != null
        ? CreatedAt.fromJson(json['created_at'])
        : null;
    if (json['tests'] != null) {
      tests = <Tests>[];
      json['tests'].forEach((v) {
        tests!.add(Tests.fromJson(v));
      });
    }
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(Offers.fromJson(v));
      });
    }
    // if (json['technical'] != null) {
    //   technical = <Null>[];
    //   json['technical'].forEach((v) { technical!.add(new Null.fromJson(v)); });
    // }
  }
}

class Address {
  dynamic id;
  dynamic latitude;
  dynamic longitude;
  dynamic address;
  dynamic specialMark;
  dynamic floorNumber;
  dynamic buildingNumber;

  Address(
      {this.id,
      this.latitude,
      this.longitude,
      this.address,
      this.specialMark,
      this.floorNumber,
      this.buildingNumber});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    specialMark = json['special_mark'];
    floorNumber = json['floor_number'];
    buildingNumber = json['building_number'];
  }
}

class Branch {
  dynamic id;
  dynamic title;

  Branch({this.id, this.title});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}

class CreatedAt {
  dynamic date;
  dynamic time;

  CreatedAt({this.date, this.time});

  CreatedAt.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }
}

class Tests {
  dynamic id;
  dynamic title;
  dynamic category;
  dynamic price;
  dynamic image;

  Tests({this.id, this.title, this.category, this.price, this.image});

  Tests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'];
    price = json['price'];
    image = json['image'];
  }
}

class Offers {
  dynamic id;
  dynamic title;
  dynamic price;
  dynamic image;

  Offers({this.id, this.title, this.price, this.image});

  Offers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    image = json['image'];
  }
}

class Extra {
  dynamic phone;
  Pagination? pagination;

  Extra({this.phone, this.pagination});

  Extra.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class Pagination {
  dynamic total;
  dynamic count;
  dynamic perPage;
  dynamic currentPage;
  dynamic lastPage;

  Pagination(
      {this.total, this.count, this.perPage, this.currentPage, this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['perPage'];
    currentPage = json['currentPage'];
    lastPage = json['lastPage'];
  }
}

class Errors {
  Errors();

  Errors.fromJson(Map<String, dynamic> json) {}
}
