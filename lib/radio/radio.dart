import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:islamiapplication/main/my_theme.dart';
import 'package:islamiapplication/radio/RadioResponse.dart';
import 'package:http/http.dart' as http;

class RadioTap extends StatelessWidget {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getRadios(),
        builder: (context, snapshot) {
          var radio = snapshot.data?.radios ?? [];
          if (snapshot.hasData) {
            Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            Center(
                child: Text(
              'something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
            ));
          }
          return Column(
            children: [
              SizedBox(
                height: 140,
              ),
              Image.asset('assets/images/radio_image.png'),
              SizedBox(
                height: 70,
              ),
              Text(
                'اذاعة القران الكريم ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: ListView.builder(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      RadioItem(radioModel: radio[index], audioPlayer: player,),
                  itemCount: radio.length,
                ),
              ),
            ],
          );
        });
  }

  Future<RadioResponse> getRadios() async {
    Uri url = Uri.parse('https://mp3quran.net/api/v3/radios');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var bodystring = response.body;
      var json = jsonDecode(bodystring);
      return RadioResponse.fromJson(json);
    } else {
      throw Exception('error');
    }
  }
}

class RadioItem extends StatelessWidget {
  RadioModel radioModel;
  AudioPlayer audioPlayer;
  RadioItem({required this.radioModel,required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text(
            radioModel?.name ?? '',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async{
                    await audioPlayer.play(UrlSource(radioModel.url??''));
                  },
                  icon: Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: MyTheme.prim,
                  )),
              SizedBox(
                width: 30,
              ),
              IconButton(
                  onPressed: () async{
                    await audioPlayer.stop();
                  },
                  icon: Icon(
                    Icons.stop,
                    size: 40,
                    color: MyTheme.prim,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
