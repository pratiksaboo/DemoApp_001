class WeatherData {

  MainInfo mainInfo;
  String name;
  SysInfo sysInfo;

  WeatherData( {
    this.name,
    this.mainInfo,
    this.sysInfo,

  });

  factory WeatherData.fromJson(Map<String,dynamic> json) {
    return WeatherData(
      name: json["name"] == null ? null : json['name'],
      mainInfo: json["main"] == null ? null : MainInfo.fromJson(json['main']),
      sysInfo: json["sys"] == null ? null : SysInfo.fromJson(json['sys']),
    );
  }
}



class MainInfo {
  double temp;

   MainInfo({
    this.temp,
  }) ;

  factory MainInfo.fromJson(Map<String, dynamic> json){
    return new MainInfo(
      temp: json['temp'],

    );
  }
}
class SysInfo {
  String country;

  SysInfo({
    this.country,

  }) ;

  factory SysInfo.fromJson(Map<String, dynamic> json){
    return new SysInfo(
      country: json['country'],

    );
  }
}