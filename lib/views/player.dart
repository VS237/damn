import 'package:damn/consts/text_style.dart';
import 'package:damn/controllers/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:damn/consts/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Obx(
            ()=> Expanded(
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: QueryArtworkWidget(
                  id: data[controller.playIndex.value].id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget:
                      const Icon(Icons.music_note, size: 48, color: whiteColor),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Obx(
              () => Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    data[controller.playIndex.value].displayNameWOExt,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: ourStyle(
                      color: bgDarkColor,
                      family: bold,
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    data[controller.playIndex.value].artist.toString(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: ourStyle(
                      color: bgDarkColor,
                      family: regular,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          controller.position.value,
                          style: ourStyle(color: bgDarkColor),
                        ),
                        Expanded(
                          child: Slider(
                            thumbColor: sliderColor,
                            inactiveColor: bgColor,
                            activeColor: sliderColor,
                            min: Duration(seconds: 0).inSeconds.toDouble(),
                            max: controller.value.value,
                            value: controller.value.value,
                            onChanged: (newValue) {
                              controller
                                  .changeDurationToSeconds(newValue.toInt());
                              newValue = newValue;
                            },
                          ),
                        ),
                        Text(
                          controller.duration.value,
                          style: ourStyle(color: bgDarkColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    controller.playSong(data[controller.playIndex.value-1].uri,
                        controller.playIndex.value-1);
                  },
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    size: 40,
                    color: bgDarkColor,
                  )),
              Obx(
                () => CircleAvatar(
                  radius: 35,
                  backgroundColor: bgDarkColor,
                  child: Transform.scale(
                    scale: 2.5,
                    child: IconButton(
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            controller.audioPlayer.pause();
                            controller.isPlaying(false);
                          } else {
                            controller.audioPlayer.play();
                            controller.isPlaying(true);
                          }
                        },
                        icon: controller.isPlaying.value
                            ? const Icon(
                                Icons.pause,
                                color: whiteColor,
                              )
                            : const Icon(
                                Icons.play_arrow_rounded,
                                color: whiteColor,
                              )),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    controller.playSong(data[controller.playIndex.value+1].uri,
                        controller.playIndex.value+1);
                  },
                  icon: const Icon(
                    Icons.skip_next_rounded,
                    size: 40,
                    color: bgDarkColor,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
