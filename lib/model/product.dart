class Product {

  //variables

  int? id;
  String? image;
  String? title;
  dynamic price;


  //constructor
  Product(
      {
        this.id,
        this.image,
        this.title,
        this.price,

      });


  //deserialized json object
  Product.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    image = json['image'];
    title = json['title'];
    price = json['price'];

  }


  //serialization of json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();

    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    data['price'] = price;

    return data;
  }
}