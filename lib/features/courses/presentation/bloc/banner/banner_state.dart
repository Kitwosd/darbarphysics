part of 'banner_bloc.dart';

class BannerState extends Equatable {
  final ApiDataStatus status;
  final List<BannerModel> bannerItems;

  const BannerState({
    this.status = ApiDataStatus.initial,
    this.bannerItems = const [],
  });

  BannerState copyWith({
    ApiDataStatus? status,
    List<BannerModel>? bannerItems,
  }) {
    return BannerState(
      status: status ?? this.status,
      bannerItems: bannerItems ?? this.bannerItems,
    );
  }

  @override
  List<Object> get props => [status, bannerItems];
}
