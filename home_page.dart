import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/search_page.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/geolocotor_page.dart';

class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  final String key = '/*  your weatherApi speacial key   */';
  String location = 'kayseri';
  double? temperature;
  String? alldataParsed;
  String weather = 'Snow';
  var locationData;
  Position? cordinates;


  Future<void> getLocationData() async {
    locationData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=metric'));
          final locationDataParsed = jsonDecode(locationData.body);
        setState(() {
          temperature = locationDataParsed['main']['temp'];
          location = locationDataParsed['name'];
          weather = locationDataParsed['weather'].first['main'];
        });
  }

  Future<void> getCordinates() async{
      cordinates = await determinePosition();
      print("cordinates loaded");
  }
//bura duzenle !!!
  Future<void> getLocationDataFromGeo() async {
    if (cordinates != null) {
      locationData = await http.get(Uri.parse(
              'https://api.openweathermap.org/data/2.5/weather?lat${cordinates!.latitude}=&lon${cordinates!.longitude}=&appid=$key&units=metric'));
      final locationDataParsed = jsonDecode(locationData.body);
      setState(() {
        temperature = locationDataParsed['main']['temp'];
        location = locationDataParsed['name'];
        weather = locationDataParsed['weather'].first['main'];
      });
    }
  }

  void getInitialData() async {
    await getLocationData();
    // await getLocationDataFromGeo();
  }

  @override
  void initState() {
    // TODO: implement initState
    getInitialData();
    super.initState();

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/$weather.jpg') , fit: BoxFit.cover)
      ),
      child: (false)
      ? Center(child: CircularProgressIndicator())
      : Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () async {

                await getLocationData();
                print('$locationData');
                final locationDataParsed = jsonDecode(locationData.body);
                print(locationDataParsed);

              },
                  child: Text("data reciever"),
              ),
              Text('$temperature' , style: TextStyle(fontSize: 70, fontWeight:  FontWeight.bold),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                '$location' ,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight:  FontWeight.bold
                    ),
                  ),
                TextButton(
                    onPressed:() async {
                     final selectedCity =  await Navigator.push(context , MaterialPageRoute(builder: (context) => SearchPage(),));
                       location = selectedCity as String;
                       getLocationData();


                      },
                    child: Icon(Icons.search , color: Colors.white),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
