import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favourite_button/favourite_button_cubit.dart';
import 'package:spotify/common/bloc/favourite_button/favourite_button_state.dart';
import 'package:spotify/core/configs/themes/app_colors.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';

class FavouriteButton extends StatelessWidget {
  final SongEntity songEntity;
  final Function? function;
  const FavouriteButton({super.key, required this.songEntity, this.function});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteButtonCubit(),
      child: BlocBuilder<FavouriteButtonCubit, FavouriteButtonState>(
        builder: (context, state) {
          if (state is FavouriteButtonInitial) {
            return IconButton(
              onPressed: () async {
                await context
                    .read<FavouriteButtonCubit>()
                    .favouriteButtonUpdate(songEntity.songId);
                if (function != null) {
                  function!();
                }
              },
              icon: Icon(
                songEntity.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_outline,
                size: 30,
                color: AppColors.darkGrey,
              ),
            );
          }

          if (state is FavouriteButtonUpdate) {
            return IconButton(
              onPressed: () {
                context
                    .read<FavouriteButtonCubit>()
                    .favouriteButtonUpdate(songEntity.songId);
              },
              icon: Icon(
                state.isFavourite ? Icons.favorite : Icons.favorite_outline,
                size: 30,
                color: AppColors.darkGrey,
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
