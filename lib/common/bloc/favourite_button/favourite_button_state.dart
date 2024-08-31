abstract class FavouriteButtonState {}

class FavouriteButtonInitial extends FavouriteButtonState {}

class FavouriteButtonUpdate extends FavouriteButtonState {
  final bool isFavourite;

  FavouriteButtonUpdate({required this.isFavourite});
}
