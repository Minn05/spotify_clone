import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/themes/app_colors.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayer extends StatelessWidget {
  SongEntity songEntity;
  SongPlayer({
    Key? key,
    required this.songEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        action: IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
        title: const Text(
          'Now playing',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit()
          ..loadSong(
              '${AppUrl.songFirestorage}${songEntity.title}-${songEntity.artist}.mp3?${AppUrl.mediaAlt}'),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(children: [
            _songCover(context),
            const SizedBox(
              height: 30,
            ),
            _songDetail(context),
            const SizedBox(
              height: 30,
            ),
            _songPlayer(context),
          ]),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
              image: NetworkImage(
                  '${AppUrl.coverFirestorage}${songEntity.title}-${songEntity.artist}.jpg?${AppUrl.mediaAlt}'),
              fit: BoxFit.cover),
        ));
  }

  Widget _songDetail(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                songEntity.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                songEntity.artist,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_outline,
            size: 35,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
        builder: (context, state) {
      if (state is SongPlayerLoading) {
        return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator());
      }

      if (state is SongPlayerLoaded) {
        return Column(
          children: [
            Slider(
              value: context
                  .read<SongPlayerCubit>()
                  .songPosition
                  .inSeconds
                  .toDouble(),
              min: 0.0,
              max: context
                  .read<SongPlayerCubit>()
                  .songDuration
                  .inSeconds
                  .toDouble(),
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fomartDuration(
                    context.read<SongPlayerCubit>().songPosition)),
                Text(fomartDuration(
                    context.read<SongPlayerCubit>().songDuration)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                context.read<SongPlayerCubit>().playOrPauseSong();
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Icon(
                  context.read<SongPlayerCubit>().audioPlayer.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
            ),
          ],
        );
      }

      return Container();
    });
  }

  String fomartDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
