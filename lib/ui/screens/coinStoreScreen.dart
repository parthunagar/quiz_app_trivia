import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterquiz/app/app_localization.dart';
import 'package:flutterquiz/app/routes.dart';
import 'package:flutterquiz/features/inAppPurchase/inAppPurchaseCubit.dart';
import 'package:flutterquiz/features/profileManagement/cubits/updateScoreAndCoinsCubit.dart';
import 'package:flutterquiz/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:flutterquiz/features/profileManagement/profileManagementRepository.dart';
import 'package:flutterquiz/ui/widgets/circularProgressContainer.dart';
import 'package:flutterquiz/ui/widgets/customAppbar.dart';
import 'package:flutterquiz/ui/widgets/errorContainer.dart';
import 'package:flutterquiz/utils/constants/in_app_purchase_products.dart';
import 'package:flutterquiz/utils/constants/string_labels.dart';
import 'package:flutterquiz/utils/ui_utils.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'home/widgets/guest_mode_dialog.dart';

class CoinStoreScreen extends StatefulWidget {
  final bool isGuest;

  const CoinStoreScreen({super.key, required this.isGuest});

  @override
  State<CoinStoreScreen> createState() => _CoinStoreScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<InAppPurchaseCubit>(
            create: (_) => InAppPurchaseCubit(
              productIds: inAppPurchaseProducts.values.toList(),
            ),
          ),
          BlocProvider<UpdateScoreAndCoinsCubit>(
            create: (_) =>
                UpdateScoreAndCoinsCubit(ProfileManagementRepository()),
          ),
        ],
        child: CoinStoreScreen(isGuest: routeSettings.arguments as bool),
      ),
    );
  }
}

class _CoinStoreScreenState extends State<CoinStoreScreen>
    with SingleTickerProviderStateMixin {
  bool canGoBack = true;

  void initPurchase() {
    context
        .read<InAppPurchaseCubit>()
        .initializePurchase(inAppPurchaseProducts.values.toList());
  }

  Widget _buildProducts(List<ProductDetails> products) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * UiUtils.vtMarginPct,
        horizontal: MediaQuery.of(context).size.width * UiUtils.hzMarginPct,
      ),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        var coins = inAppPurchaseProducts.keys
            .where((element) {
              return inAppPurchaseProducts[element] == products[index].id;
            })
            .toList()
            .first;

        return GestureDetector(
          onTap: () {
            if (widget.isGuest) {
              showDialog(
                context: context,
                builder: (_) => GuestModeDialog(onTapYesButton: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(Routes.login);
                }),
              );
            } else {
              canGoBack = false;
              context
                  .read<InAppPurchaseCubit>()
                  .buyConsumableProducts(products[index]);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 20),
                  child: SvgPicture.asset(
                    "assets/images/coins/coin_pack_a.svg",
                    width: 40,
                    height: 26,
                  ),
                ),
                Text(
                  product.description,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onTertiary
                        .withOpacity(0.4),
                  ),
                ),
                Text(
                  "$coins ${AppLocalization.of(context)!.getTranslatedValues(coinsLbl)!}",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 4,
                  ),
                  child: Text(
                    product.price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final InAppPurchaseCubit inAppPurchaseCubit =
            context.read<InAppPurchaseCubit>();
        if (inAppPurchaseCubit.state is InAppPurchaseProcessInProgress) {
          return Future.value(false);
        }
        if (!canGoBack) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: QAppBar(
          title: Text(
              AppLocalization.of(context)!.getTranslatedValues(coinStoreKey)!),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: BlocConsumer<InAppPurchaseCubit, InAppPurchaseState>(
                bloc: context.read<InAppPurchaseCubit>(),
                listener: (context, state) {
                  print("State change to ${state.toString()}");
                  if (state is InAppPurchaseProcessSuccess) {
                    var coins = inAppPurchaseProducts.keys
                        .where((e) =>
                            inAppPurchaseProducts[e] ==
                            state.purchasedProductId)
                        .toList()
                        .first;
                    context.read<UserDetailsCubit>().updateCoins(
                          addCoin: true,
                          coins: coins,
                        );
                    context.read<UpdateScoreAndCoinsCubit>().updateCoins(
                          context.read<UserDetailsCubit>().getUserId(),
                          coins,
                          true,
                          boughtCoinsKey,
                        );
                    UiUtils.setSnackbar(
                        AppLocalization.of(context)!
                            .getTranslatedValues(coinsBoughtSuccessKey)!,
                        context,
                        false);
                    canGoBack = true;
                  } else if (state is InAppPurchaseProcessFailure) {
                    canGoBack = true;
                    UiUtils.setSnackbar(
                        AppLocalization.of(context)!
                            .getTranslatedValues(state.errorMessage)!,
                        context,
                        false);
                  }
                },
                builder: (context, state) {
                  //initial state of cubit
                  if (state is InAppPurchaseInitial ||
                      state is InAppPurchaseLoading) {
                    return const Center(
                      child: CircularProgressContainer(whiteLoader: false),
                    );
                  }

                  //if occurred problem while fetching product details
                  //from appstore or playstore
                  if (state is InAppPurchaseFailure) {
                    //
                    return Center(
                      child: ErrorContainer(
                        showBackButton: false,
                        errorMessage: AppLocalization.of(context)!
                            .getTranslatedValues(state.errorMessage)!,
                        onTapRetry: initPurchase,
                        showErrorImage: true,
                      ),
                    );
                  }

                  if (state is InAppPurchaseNotAvailable) {
                    return Center(
                      child: ErrorContainer(
                        showBackButton: false,
                        errorMessage: AppLocalization.of(context)!
                            .getTranslatedValues(inAppPurchaseUnavailableKey)!,
                        onTapRetry: initPurchase,
                        showErrorImage: true,
                      ),
                    );
                  }

                  //if any error occurred in while making in-app purchase
                  if (state is InAppPurchaseProcessFailure) {
                    return _buildProducts(state.products);
                  }
                  //
                  if (state is InAppPurchaseAvailable) {
                    return _buildProducts(state.products);
                  }
                  //
                  if (state is InAppPurchaseProcessSuccess) {
                    return _buildProducts(state.products);
                  }
                  if (state is InAppPurchaseProcessInProgress) {
                    return _buildProducts(state.products);
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
