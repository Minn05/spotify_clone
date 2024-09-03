import 'package:dartz/dartz.dart';

abstract class SongsRepository {
  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> addOrRemoveFavouriteSongs(String songId);
  Future<bool> isFavourite(String songId);
  Future<Either> getUserFavouriteSongs();
}
