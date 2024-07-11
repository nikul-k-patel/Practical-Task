import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../../base/base_stateful_state.dart';
import '../../../../common_widgets/common_widgets.dart';
import '../../../../common_widgets/shimmer_view_widget.dart';
import '../../../../common_widgets/text_widget.dart';
import '../../../../resources/color.dart';
import '../../test_stripe_screen/test_stripe_screen.dart';
import 'home_cubit/home_cubit.dart';
import 'home_cubit/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStatefulWidgetState<HomeScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final ScrollController _verticalScrollController = ScrollController();
  final List<ScrollController> _horizontalScrollControllers = [];
  bool hasReachedMax = false;

  @override
  bool get extendBodyBehindAppBar => true;

  @override
  bool get shouldHaveSafeArea => false;

  @override
  Color? get scaffoldBgColor => colorBlack;
  int selectedIndex = -1;
  @override
  void initState() {
    super.initState();

    HomeCubit.get(context).mainCategoryList();
    HomeCubit.get(context).subCategoryPageIndex = 1;

    // Adding listeners to scroll controllers
    _verticalScrollController.addListener(_onVerticalScroll);
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _onVerticalScroll() {
    if (_verticalScrollController.position.atEdge) {
      if (_verticalScrollController.position.pixels == 0) {
        // At the top
      } else {
        // At the bottom
        _onLoading();
      }
    }
  }

  void _onHorizontalScroll(ScrollController controller, int index) {
    setState(() {
      selectedIndex = index;
    });
    if (controller.position.atEdge && controller.position.pixels != 0) {
      HomeCubit.get(context).productListApiCall(subCategoryId: HomeCubit.get(context).subCategoryList[index].id.toString(), index: index);
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.resetNoData();
    HomeCubit.get(context).subCategoryPageIndex = 1;
    HomeCubit.get(context).productPageIndex = 1;
    HomeCubit.get(context).subCategoryListApiCall(clearList: true);
  }

  Future<void> _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    HomeCubit.get(context).subCategoryPageIndex++;
    await HomeCubit.get(context).subCategoryListApiCall(clearList: false);
  }

  int categoryIndex = 0;
  String categoryName = "";
  @override
  Widget buildBody(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (BuildContext context, HomeState state) async {
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
        if (state is SubCategoryErrorState) {
          _refreshController.loadNoData();
          _refreshController.refreshFailed();
        }
        if (state is SubCategorySuccessState) {
          if (state.successState.result?.category?[0].subCategories == null) {
            _refreshController.loadNoData();
            _refreshController.refreshFailed();
          }
        }

        if (state is ProductSuccessState) {
          setState(() {
            selectedIndex = -1;
          });
        }
      },
      builder: (BuildContext context, state) {
        var homeCubit = HomeCubit.get(context);
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: SizedBox(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: homeCubit.isLoading && HomeCubit.get(context).subCategoryPageIndex == 1
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              commonLoader(color: colorWhite, size: 50.h),
                              heightBox(20.h),
                              TextWidget(
                                text: "Loading...",
                                color: colorWhite,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Column(
                              children: [
                                heightBox(45.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        push(context, enterPage: const TestStripScreen());
                                      },
                                      child: Icon(
                                        Icons.filter_alt_outlined,
                                        color: colorWhite,
                                        size: 26.sp,
                                      ),
                                    ),
                                    widthBox(12.w),
                                    Icon(
                                      Icons.search,
                                      color: colorWhite,
                                      size: 26.sp,
                                    ),
                                    widthBox(15.w),
                                  ],
                                ),
                                SizedBox(
                                  height: 50.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: homeCubit.categoryList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: 20.w,
                                          right: index == homeCubit.categoryList.length - 1 ? 20.w : 0,
                                        ),
                                        child: InkWell(
                                          splashColor: colorTransparent,
                                          onTap: () {
                                            setState(() {
                                              categoryIndex = index;
                                              HomeCubit.get(context).subCategoryPageIndex = 1;
                                              categoryName = homeCubit.categoryList[index].name.toString();
                                              if (categoryName == "Ceramic") {
                                                homeCubit.subCategoryListApiCall(clearList: true);
                                              }
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                text: homeCubit.categoryList[index].name.toString(),
                                                color: categoryIndex == index ? colorWhite : colorWhite.withOpacity(0.5),
                                                fontSize: categoryIndex == index ? 16.sp : 14.sp,
                                                textAlign: TextAlign.left,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    topRight: Radius.circular(12.r),
                                  ),
                                ),
                                child: categoryName != "Ceramic"
                                    ? Center(
                                        child: TextWidget(
                                          text: "No data found!",
                                          color: colorBlack,
                                          maxLines: 1,
                                          fontSize: 18.sp,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : homeCubit.isLoading2 && HomeCubit.get(context).subCategoryPageIndex == 1
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                commonLoader(color: colorBlack, size: 45.h),
                                                heightBox(20.h),
                                                TextWidget(
                                                  text: "Loading.......",
                                                  color: colorBlack,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          )
                                        : SmartRefresher(
                                            controller: _refreshController,
                                            enablePullDown: true,
                                            enablePullUp: true,
                                            onRefresh: _onRefresh,
                                            onLoading: _onLoading,
                                            child: ListView.builder(
                                              controller: _verticalScrollController,
                                              itemCount: homeCubit.subCategoryList.length,
                                              itemBuilder: (context, index) {
                                                ScrollController horizontalController = ScrollController();
                                                _horizontalScrollControllers.add(horizontalController);
                                                horizontalController.addListener(() => _onHorizontalScroll(horizontalController, index));

                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: index == homeCubit.subCategoryList.length - 1 ? 20.h : 0.h,
                                                      ),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                              child: TextWidget(
                                                                text: homeCubit.subCategoryList[index].name.toString(),
                                                                color: colorBlack,
                                                                fontSize: 15.5.sp,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            heightBox(10.h),
                                                            SizedBox(
                                                              height: 115.h,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: ListView.builder(
                                                                      controller: horizontalController,
                                                                      scrollDirection: Axis.horizontal,
                                                                      itemCount: homeCubit.subCategoryList[index].product!.length,
                                                                      itemBuilder: (context, index2) {
                                                                        return Padding(
                                                                          padding: EdgeInsets.only(
                                                                            left: 20.w,
                                                                            right: index2 == homeCubit.subCategoryList[index].product!.length - 1
                                                                                ? 20.w
                                                                                : 0,
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                  color: colorWhite,
                                                                                ),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.r),
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: homeCubit
                                                                                        .subCategoryList[index].product![index2].imageName
                                                                                        .toString(),
                                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                                      height: 90.h,
                                                                                      width: 110.w,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(8.r),
                                                                                        image: DecorationImage(
                                                                                          image: imageProvider,
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    placeholder: (context, url) => ShimmerViewWidget(
                                                                                      height: 90.h,
                                                                                      width: 110.w,
                                                                                      borderRadius: 8.r,
                                                                                    ),
                                                                                    errorWidget: (context, url, error) => Container(
                                                                                      height: 90.h,
                                                                                      width: 110.w,
                                                                                      decoration: BoxDecoration(
                                                                                        color: colorTransparent,
                                                                                        borderRadius: BorderRadius.circular(8.r),
                                                                                      ),
                                                                                      child: Icon(
                                                                                        Icons.error,
                                                                                        color: colorPrimary,
                                                                                        size: 18.sp,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 25.h,
                                                                                width: 110.w,
                                                                                alignment: Alignment.bottomLeft,
                                                                                child: TextWidget(
                                                                                  text: homeCubit.subCategoryList[index].product![index2].name
                                                                                      .toString(),
                                                                                  color: colorBlack.withOpacity(0.65),
                                                                                  maxLines: 1,
                                                                                  textOverflow: TextOverflow.ellipsis,
                                                                                  fontSize: 12.sp,
                                                                                  textAlign: TextAlign.left,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible: homeCubit.isLoading3 && index == selectedIndex,
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(right: 20.w, left: 15),
                                                                      child: commonLoader(color: colorBlack, size: 20),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            heightBox(5.h),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 15.h),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
