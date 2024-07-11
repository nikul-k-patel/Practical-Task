import '../model/mainCategory_response.dart';
import '../model/product_response.dart';
import '../model/subCategory_response.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class MainCategoryLoadingState extends HomeState {}

class MainCategorySuccessState extends HomeState {
  final MainCategoryResponse successState;

  MainCategorySuccessState(this.successState);
}

class MainCategoryErrorState extends HomeState {
  final MainCategoryResponse errorState;

  MainCategoryErrorState(this.errorState);
}
///sub category
class SubCategoryLoadingState extends HomeState {}

class SubCategorySuccessState extends HomeState {
  final SubCategoryResponse successState;

  SubCategorySuccessState(this.successState);
}

class SubCategoryErrorState extends HomeState {
  final SubCategoryResponse errorState;

 SubCategoryErrorState(this.errorState);
}

/// product list
class ProductLoadingState extends HomeState {}

class ProductSuccessState extends HomeState {
  final ProductResponse successState;

  ProductSuccessState(this.successState);
}

class ProductErrorState extends HomeState {
  final ProductResponse errorState;

  ProductErrorState(this.errorState);
}