import 'package:clima_app/services/weather.dart';
import 'package:clima_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import'city_screen.dart';

class LocationScreen extends StatefulWidget {

  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool isLoading = false;
  WeatherModel weatherModel = WeatherModel();
  late int temperature;
  late String weatherIcon;
  late String tempIcon;
  late String cityName;
  @override
  void initState() {
    super.initState();

    UpdateUI(widget.locationWeather);
  }

  void UpdateUI(dynamic weatherData){
    setState(() {
      if(weatherData == null){
        temperature = 0;
        weatherIcon = 'Error';
        tempIcon = 'Unable to get weather data';
        cityName = '';
        return;
      }
      cityName = weatherData['name'];
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      tempIcon = weatherModel.getMessage(temperature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/location_background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        var weatherData = await weatherModel.getLocationWeather();
                        UpdateUI(weatherData);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Icon(
                        Icons.near_me,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)
                        {
                          return CityScreen();
                        }));
                        if (typedName != null){
                          setState(() {
                            isLoading = true;
                          });
                         var weatherData = await weatherModel.getCityWeather(typedName);
                         UpdateUI(weatherData);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Icon(
                        Icons.location_city,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$temperature°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        '$weatherIcon',
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Text(
                    "$tempIcon in $cityName!",
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        if (isLoading) ...[
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SpinKitSpinningLines(
              color: Colors.white,
              size: 100.0,
            ),
          ),
        ],
    ]
    );
  }
}


