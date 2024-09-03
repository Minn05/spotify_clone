import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/song/song_model.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/domain/usecases/song/is_favourite_song.dart';
import 'package:spotify/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> addOrRemoveFavouriteSongs(String songId);
  Future<bool> isFavourite(String songId);
  Future<Either> getUserFavouriteSongs();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];

      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .limit(4)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.formJson(element.data());

        bool isFavourite = await sl<IsFavouriteSongUseCase>().call(
          params: element.reference.id,
        );
        songModel.isFavourite = isFavourite;
        songModel.songId = element.reference.id;

        songs.add(
          songModel.toEntity(),
        );
      }
      return Right(songs);
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> getPlayList() async {
    try {
      List<SongEntity> songs = [];

      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.formJson(element.data());

        bool isFavourite = await sl<IsFavouriteSongUseCase>().call(
          params: element.reference.id,
        );
        songModel.isFavourite = isFavourite;
        songModel.songId = element.reference.id;

        songs.add(
          songModel.toEntity(),
        );
      }
      return Right(songs);
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> addOrRemoveFavouriteSongs(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavourite;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favouriteSongs = await firebaseFirestore
          .collection('User')
          .doc(uId)
          .collection('Favourites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favouriteSongs.docs.isNotEmpty) {
        await favouriteSongs.docs.first.reference.delete();

        isFavourite = false;
      } else {
        await firebaseFirestore
            .collection('User')
            .doc(uId)
            .collection('Favourites')
            .add(
          {
            'songId': songId,
            'addedDate': Timestamp.now(),
          },
        );
        isFavourite = true;
      }
      return Right(isFavourite);
    } catch (e) {
      return const Left('An error occurred');
    }
  }

  @override
  Future<bool> isFavourite(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favouriteSongs = await firebaseFirestore
          .collection('User')
          .doc(uId)
          .collection('Favourites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favouriteSongs.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getUserFavouriteSongs() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      List<SongEntity> favouriteSongs = [];
      String uId = user!.uid;

      QuerySnapshot favouritesSnapshot = await firebaseFirestore
          .collection('User')
          .doc(uId)
          .collection('Favourites')
          .get();

      for (var element in favouritesSnapshot.docs) {
        String songId = element['songId'];

        var song =
            await firebaseFirestore.collection('Songs').doc(songId).get();
        SongModel songModel = SongModel.formJson(song.data()!);
        songModel.isFavourite = true;
        songModel.songId = songId;
        favouriteSongs.add(songModel.toEntity());
      }
      return Right(favouriteSongs);
    } catch (e) {
      return const Left('An error occurred');
    }
  }
}
