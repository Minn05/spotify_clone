import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/core/configs/themes/app_colors.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/home/bloc/play_list_cubit.dart';
import 'package:spotify/presentation/home/bloc/play_list_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class PlayList extends StatelessWidget {
  const PlayList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child:
          BlocBuilder<PlayListCubit, PlayListState>(builder: (context, state) {
        if (state is PlayListLoading) {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        if (state is PlayListLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Playlist',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'See More',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xffc6c6c6)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _songs(state.songs),
              ],
            ),
          );
        }
        return Container();
      }),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SongPlayer(
                            songEntity: songs[index],
                          )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  transform: Matrix4.translationValues(10, 10, 0),
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? AppColors.darkGrey
                        : const Color(0xffE6E6E6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: context.isDarkMode
                        ? const Color(0xff959595)
                        : const Color(0xff555555),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          songs[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          songs[index].artist,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(songs[index]
                        .duration
                        .toStringAsFixed(2)
                        .replaceAll('.', ':'))),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_outline,
                    size: 30,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
              height: 20,
            ),
        itemCount: songs.length);
  }
}
