import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/favourite_button/favourite_buton.dart';
import 'package:spotify/presentation/profile/bloc/favourite_song_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favourite_song_state.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

import '../../../core/configs/constants/app_urls.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        backgroundColor:
            context.isDarkMode ? const Color(0xff2c2b2b) : Colors.white,
        title: const Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileInfo(context),
          const SizedBox(height: 30),
          _favouriteSongs(),
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileInfoCubit()..getUser(),
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xff2c2b2b) : Colors.white,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
        ),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
            builder: (context, state) {
          if (state is ProfileInfoLoading) {
            return Center(
              child: Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator()),
            );
          }
          if (state is ProfileInfoLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(state.userEntity.imageURL!)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(state.userEntity.email!),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  state.userEntity.fullName!,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }
          if (state is ProfileInfoFailure) {
            return const Center(child: Text('Please try again '));
          }
          return Container();
        }),
      ),
    );
  }

  Widget _favouriteSongs() {
    return BlocProvider(
      create: (context) => FavouriteSongsCubit()..getFavouriteSongs(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FAVOURITE SONG'),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<FavouriteSongsCubit, FavouriteSongsState>(
              builder: (context, state) {
                if (state is FavouriteSongsLoading) {
                  return Center(
                    child: Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator()),
                  );
                }

                if (state is FavouriteSongsLoaded) {
                  return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SongPlayerPage(
                                        songEntity:
                                            state.favouriteSongs[index]),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        '${AppUrl.coverFirestorage}${state.favouriteSongs[index].title}-${state.favouriteSongs[index].artist}.jpg?${AppUrl.mediaAlt}'),
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SizedBox(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state.favouriteSongs[index].title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        state.favouriteSongs[index].artist,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),

                              //time
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  state.favouriteSongs[index].duration
                                      .toStringAsFixed(2)
                                      .replaceAll('.', ':'),
                                ),
                              ),
                              FavouriteButton(
                                songEntity: state.favouriteSongs[index],
                                key: UniqueKey(),
                                function: () {
                                  context
                                      .read()<FavouriteSongsCubit>()
                                      .removeSong(index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 20,
                          ),
                      itemCount: state.favouriteSongs.length);
                }

                if (state is FavouriteSongsFailure) {
                  return const Text('Please try again');
                }

                return Container(
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
