import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../repo_api/dio_helper.dart';
import '../../../../../repo_api/rest_constants.dart';
import '../model/mainCategory_response.dart';
import '../model/product_response.dart';
import '../model/subCategory_response.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  ///main category list api call
  MainCategoryResponse? mainCategoryResponse;
  List<CategoryMain> categoryList = [];
  bool isLoading = false;
  void mainCategoryList() {
    isLoading = true;
    emit(MainCategoryLoadingState());
    DioHelper.postData(
      url: RestConstants.mainCategoryUrl,
      data: {"CategoryId": 0, "DeviceManufacturer": "Google", "DeviceModel": "Android SDK built for x86", "DeviceToken": " ", "PageIndex": 1},
    ).then((value) {
      isLoading = false;
      mainCategoryResponse = MainCategoryResponse.fromJson(value.data);
      categoryList.addAll(mainCategoryResponse!.result!.category!);
      emit(MainCategorySuccessState(mainCategoryResponse!));
    }).catchError((error) {
      isLoading = false;
      if (error is DioError) {}

      emit(MainCategoryErrorState(MainCategoryResponse(message: error.toString())));
    });
  }

  ///sub category list api call
  SubCategoryResponse? subCategoryResponse;
  List<SubCategory> subCategoryList = [];

  /// List<ProductList> productList = [];
  bool isLoading2 = false;
  int subCategoryPageIndex = 1;
  subCategoryListApiCall({required bool clearList}) async {
    isLoading2 = true;
    emit(SubCategoryLoadingState());
    DioHelper.postData(
      url: RestConstants.subCategoryUrl,
      data: {"CategoryId": 56, "PageIndex": subCategoryPageIndex},
    ).then((value) {
      if (clearList == true) {
        subCategoryList.clear();
      }
      isLoading2 = false;
      subCategoryResponse = SubCategoryResponse.fromJson(value.data);

      subCategoryList.addAll(subCategoryResponse!.result!.category![0].subCategories!);
      // subCategoryResponse!.result!.category![0].subCategories!.forEach((subCategory) {
      //   productList.addAll(subCategory.product!);
      // });
      emit(SubCategorySuccessState(subCategoryResponse!));
    }).catchError((error) {
      isLoading2 = false;
      if (error is DioError) {}

      emit(SubCategoryErrorState(SubCategoryResponse(message: error.toString())));
    });
  }

  /// product list api
  ProductResponse? productResponse;
  List<ResultData> productList = [];
  int productPageIndex = 1;
  bool isLoading3 = false;
  void productListApiCall({required String subCategoryId, required int index}) {
    isLoading3 = true;
    emit(ProductLoadingState());
    DioHelper.postData(
      url: RestConstants.productListUrl,
      data: {"PageIndex": productPageIndex, "SubCategoryId": subCategoryId},
    ).then((value) {
      isLoading3 = false;
      productResponse = ProductResponse.fromJson(value.data);
      productList.addAll(productResponse!.result!);

      if (index < subCategoryList.length) {
        subCategoryList[index].product ??= [];
        subCategoryList[index].product!.addAll(productResponse!.result!.map((resultData) => ProductList(
              name: resultData.name,
              priceCode: resultData.priceCode,
              imageName: resultData.imageName,
              id: resultData.id,
            )));
      }

      emit(ProductSuccessState(productResponse!));
    }).catchError((error) {
      isLoading3 = false;
      if (error is DioError) {}

      emit(ProductErrorState(ProductResponse(message: error.toString())));
    });
  }
}
