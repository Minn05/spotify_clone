import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favourite_button/favourite_button_state.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_song.dart';
import 'package:spotify/service_locator.dart';

class FavouriteButtonCubit extends Cubit<FavouriteButtonState> {
  FavouriteButtonCubit() : super(FavouriteButtonInitial());

  Future<void> favouriteButtonUpdate(String songId) async {
    var result = await sl<AddOrRemoveFavouriteSongsUseCase>().call(
      params: songId,
    );
    result.fold(
      (l) {},
      (isFavourite) {
        emit(
          FavouriteButtonUpdate(isFavourite: isFavourite),
        );
      },
    );
  }
}
