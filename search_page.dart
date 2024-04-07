import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {


  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String selectedCity = '';
  final String key = '/*  your weatherApi speacial key   */';


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/Drizzle.jpg') , fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
       appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
       ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: TextField(
                    onChanged: (value){
                      selectedCity = value;
                      print(value);
                    },
                    decoration: InputDecoration(hintText: 'Şehir Seçiniz'  ,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                    ),
                    ),
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(onPressed: () async{
                  var response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$selectedCity&appid=$key&units=metric'));

                  if(response.statusCode == 200)
                    {
                      Navigator.pop(context , selectedCity);
                    }
                  else
                    {
                      Future<void> _showMyDialog() async {
                        return showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Lokasyon bulunamadi'),
                                    Text('Lütfen geçerli adres girin'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Approve'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      _showMyDialog();
                    }

                  }, child: Text("Select City" , style: TextStyle(color: Colors.white , fontSize: 20),),)
              ],
            ),
        ),
      ),
    );

  }
}

