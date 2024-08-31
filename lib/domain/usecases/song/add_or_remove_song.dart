import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/song/song_repo.dart';
import 'package:spotify/service_locator.dart';

class AddOrRemoveFavouriteSongsUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<SongsRepository>().addOrRemoveFavouriteSongs(params!);
  }
}
