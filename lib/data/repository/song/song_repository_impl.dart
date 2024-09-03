import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/song/song_firebase_service.dart';
import 'package:spotify/domain/repository/song/song_repo.dart';

import '../../../service_locator.dart';

class SongRepositoryImpl extends SongsRepository {
  @override
  Future<Either> getNewsSongs() async {
    return await sl<SongFirebaseService>().getNewsSongs();
  }

  @override
  Future<Either> getPlayList() async {
    return await sl<SongFirebaseService>().getPlayList();
  }

  @override
  Future<Either> addOrRemoveFavouriteSongs(String songId) async {
    return await sl<SongFirebaseService>().addOrRemoveFavouriteSongs(songId);
  }

  @override
  Future<bool> isFavourite(String songId) async {
    return await sl<SongFirebaseService>().isFavourite(songId);
  }

  @override
  Future<Either> getUserFavouriteSongs() async {
    return await sl<SongFirebaseService>().getUserFavouriteSongs();
  }
}
