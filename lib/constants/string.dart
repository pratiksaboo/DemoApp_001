class StringConstant{
  static bool networkStat = true;

  StringConstant._();


  static const String WEATHER_API_KEY = "80dd5e825ecd5aac59b67905be5719ec";
  static const String USER = "USER";
  static const String BLOGS = "BLOGS";
  static const String GALLERY = "GALLERY";
  static const String IMAGE = "IMAGE";
  static const String NOMINEE = "NOMINEE";
  static const String QUOTES = "QUOTES";
  static const String APP_SETTING = "APP_SETTING";
  static const String GLOBAL_CONSTANT = "GLOBAL";

  static const String PARENT = "Parent";
  static const String SPOUSE = "Spouse";
  static const String CHILDREN = "Children";
  static const String SIBLING = "Sibling";
  static const String PARTNER = "Partner";
  static const String FRIEND = "Friend";
  static const String OTHER = "Other";


  static const Map<String,int> monthsInYear = {
    "January" : 1 ,
    "February" : 2 ,
    "March" : 3 ,
    "April" : 4 ,
    "May" : 5 ,
    "June" : 6 ,
    "July" : 7 ,
    "August" : 8 ,
    "September" : 9 ,
    "October" : 10 ,
    "November" : 11 ,
    "December" : 12 ,
  };

  static const Map<int,String> RelationString = {
   0: "Parent" ,
   1: "Spouse"  ,
   2: "Children" ,
   3: "Sibling" ,
   4: "Partner" ,
   5: "Friend" ,
    6:"Other" ,
  };
}