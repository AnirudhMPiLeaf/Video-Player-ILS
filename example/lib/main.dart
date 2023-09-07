import 'package:flutter/material.dart';
import 'package:video_player_ils/plugin/data/models.dart';
import 'package:video_player_ils/video_player_ils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SizedBox(
          // height: 400,
          // width: 400,
          child: VideoPlayerILS(
            // videoPlayerTheme: VideoPlayerTheme(
            //     seekLeftColor: Colors.amber,
            //     seekRightColor: Colors.blue,
            //     playIconActive: Icons.ads_click,
            //     playIconInactive: Icons.file_download,
            //     loopIconColorActive: Colors.green,
            //     seekProgressBarColor: Colors.amber),
            errorCallback: (p0) {
              debugPrint('---$p0');
            },
            urls: [
              VideoQualityModel(
                  url:
                      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                  name: '360p'),
              VideoQualityModel(
                  url:
                      'https://joy1.videvo.net/videvo_files/video/free/video0454/large_watermarked/_import_60648ebe8b20a7.07188709_preview.mp4',
                  name: '720p'),
              VideoQualityModel(
                  url:
                      'https://joy1.videvo.net/videvo_files/video/free/2014-07/large_watermarked/Saint_Barthelemy_preview.mp4',
                  name: '1080p'),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
