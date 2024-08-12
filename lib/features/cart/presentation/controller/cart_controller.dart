import 'package:get/get.dart';
import 'package:order/features/restaurant/data/model/menu_model.dart';

class CartController {
  RxList<MenuModel> cartDataDetails = <MenuModel>[].obs;

  double cartTotalPrice() {
    double total = 0;
    double delivartFee = 25.0;
    double serviceFee = 12.0;
    for (MenuModel item in cartDataDetails) {
      num price = item.price;
      total += price + delivartFee + serviceFee;
    }
    return total;
  }
}
