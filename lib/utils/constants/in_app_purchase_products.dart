//in-app purchase products configuration

//
//Make sure to have same ids of consumable product in both play and app store
//
const inAppPurchaseProducts = {
  //number of coins : it's respective consumable id
  100: "100_consumable_coins",
  500: "500_consumable_coins",
  1000: "1000_consumable_coins",
};

// class InAppPurchaseProduct {
//   const InAppPurchaseProduct({
//     required this.coins,
//     required this.price,
//     required this.name,
//     required this.consumable_id,
//     required this.cover,
//   });
//
//   final int coins;
//   final double price;
//   final String cover;
//   final String name;
//   final String consumable_id;
// }
//
// const List<InAppPurchaseProduct> prods = const [
//   const InAppPurchaseProduct(
//     coins: 5,
//     price: 1.99,
//     name: "Small Pack",
//     consumable_id: "5_consumable_coins",
//     cover: "coins_pack_a.svg",
//   ),
//   const InAppPurchaseProduct(
//     coins: 10,
//     price: 3.99,
//     name: "Medium Pack",
//     consumable_id: "10_consumable_coins",
//     cover: "coins_pack_b.svg",
//   ),
//   const InAppPurchaseProduct(
//     coins: 35,
//     price: 10.49,
//     name: "Large Pack",
//     consumable_id: "35_consumable_coins",
//     cover: "coins_pack_c.svg",
//   ),
// ];
