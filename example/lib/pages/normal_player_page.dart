import 'package:better_player/better_player.dart';
import 'package:better_player_example/constants.dart';
import 'package:better_player_example/utils.dart';
import 'package:flutter/material.dart';

import '../common_icons.dart';

class NormalPlayerPage extends StatefulWidget {
  @override
  _NormalPlayerPageState createState() => _NormalPlayerPageState();
}

class _NormalPlayerPageState extends State<NormalPlayerPage> {
  BetterPlayerController _betterPlayerController;
  int _startTime = DateTime.now().microsecond;
  int _endTime = DateTime.now().microsecond;

  @override
  void initState() {
    _startTime = DateTime.now().microsecond;
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
            autoPlay: true,
            fit: BoxFit.contain,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              enableMute: false,
              enableProgressText: true,
              pauseIcon: CommonIcons.icon_video_play,
              playIcon: CommonIcons.icon_video_pause,
              fullscreenEnableIcon: CommonIcons.icon_video_full_screen,
            ));
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "https://va-videos.oss-cn-hangzhou.aliyuncs.com/video-record/local/default/1-%E6%95%B0%E6%8D%AE%E6%94%B6%E9%9B%86-6c5cc740-772f-11eb-9157-d1c1a15411e5/index.m3u8",
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        _endTime = DateTime.now().microsecond;
        debugPrint('33---normal_player_page-----初始化完成');
        debugPrint('34---normal_player_page-----${(_endTime - _startTime)}');
      }
    });
    // _betterPlayerController.addListener(() {
    //   if (_betterPlayerController.isVideoInitialized()) {
    //     _endTime = DateTime.now().microsecond;
    //     debugPrint('33---normal_player_page-----初始化完成');
    //     debugPrint(
    //         '34---normal_player_page-----${(_endTime - _startTime) / 1000}');
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Normal player"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Normal player with configuration managed by developer.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
          ElevatedButton(
            child: Text("Play file data source"),
            onPressed: () async {
              String url = await Utils.getFileUrl(Constants.fileTestVideoUrl);
              BetterPlayerDataSource dataSource =
                  BetterPlayerDataSource(BetterPlayerDataSourceType.file, url);
              _betterPlayerController.setupDataSource(dataSource);
            },
          ),
          RaisedButton(
              child: Text('seekTo'),
              onPressed: () {
                _betterPlayerController.seekTo(Duration(seconds: 7000));
              })
        ],
      ),
    );
  }
}
