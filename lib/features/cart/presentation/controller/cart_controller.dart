import 'package:get/get.dart';

import '../../../restaurant/data/model/menu_model.dart';

class CartController {
  var cartDataDetails = <MenuModel>[].obs;

  double cartTotalPrice() {
    double total = 0;
    double delivartFee = 25.0;
    double serviceFee = 12.0;
    for (var item in cartDataDetails) {
      num price = item.price;
      total += price + delivartFee + serviceFee;
    }
    return total;
  }
}
