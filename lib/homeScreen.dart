import 'package:flutter/material.dart';
import 'package:weathernew/api.dart';
import 'package:weathernew/weatherModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiResponse? response;
  bool inProgress = false;
  String message = "Search for the location to get the data";
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
           padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchWidget(),
                SizedBox(height: 20,),
                if(inProgress) CircularProgressIndicator()
                else
                  Expanded(
                      child: SingleChildScrollView(
                          child: _buildWeatherWidget()
                      )
                  )
              ],
            ),
          ),
        )
    );
  }


  Widget _buildSearchWidget()
  {
    return SearchBar(
      hintText: "Search location",
      onSubmitted: (value)
      {
        _getWeatherData(value);
      },
    );
  }
  Widget _buildWeatherWidget()
  {
    if(response==null)
      {
        return Text(message);
      }else
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 35,
                  ),

                  Text(response?.location?.name??"",
                    style: const TextStyle(fontSize: 35,fontWeight: FontWeight.w500),),

                  Text(response?.location?.country??"",
                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),

                ],
              ),
             SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text((response?.current?.tempC.toString()??"")+"°c",
                      style: const TextStyle(fontSize: 35,fontWeight: FontWeight.w500),),
                  ),

                  Text((response?.current?.condition?.text?.toString()??""),
                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
                ],
              ),
              Center(
                  child: SizedBox(
                      height:200,
                      child:
                      Image.network(
                        "https:${response?.current?.condition?.icon}".replaceAll("64x64", "128x128"),
                        scale: 0.7,)
                  )
              ),
              Card(
                elevation: 4,
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _dataAndTitleWidget("Humidity",response?.current?.humidity?.toString()??""),
                        _dataAndTitleWidget("Wind Speed",(response?.current?.windKph?.toString()??""+"Km/h")),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _dataAndTitleWidget("UV",response?.current?.uv?.toString()??""),
                        _dataAndTitleWidget("Precipitation",(response?.current?.precipMm?.toString()??""+"mm")),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _dataAndTitleWidget("Local Time",response?.location?.localtime?.split("").last??""),
                        _dataAndTitleWidget("Local Date",(response?.location?.localtime?.split("").first??"")),
                      ],)
                  ],
                ),
              )
            ],
          );
        }
  }

  _getWeatherData(String location) async{
    setState(() {
      inProgress = true;
    });

    try{
      response= await WeatherApi().getCurrentWeather(location);
    }
    catch(e)
    {
     setState(() {
       message="Failed to get weather info";
       response=null;
     });
    }
    finally{
      setState(() {
        inProgress = false;
      });
    }


  }

  Widget _dataAndTitleWidget(String title,String data)
  {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(data,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.black),),
          Text(title,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.black))
        ],
      ),
    );
  }
}
