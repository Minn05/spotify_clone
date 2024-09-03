import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/domain/usecases/song/get_favourites_song.dart';
import 'package:spotify/presentation/profile/bloc/favourite_song_state.dart';
import 'package:spotify/service_locator.dart';

class FavouriteSongsCubit extends Cubit<FavouriteSongsState> {
  FavouriteSongsCubit() : super(FavouriteSongsLoading());

  List<SongEntity> favouriteSongs = [];

  Future<void> getFavouriteSongs() async {
    var result = await sl<GetFavouriteSongUseCase>().call();

    result.fold((l) {
      emit(FavouriteSongsFailure());
    }, (r) {
      favouriteSongs = r;
      emit(FavouriteSongsLoaded(favouriteSongs: favouriteSongs));
    });
  }

  void removeSong(int index) {
    favouriteSongs.removeAt(index);
    emit(FavouriteSongsLoaded(favouriteSongs: favouriteSongs));
  }
}
