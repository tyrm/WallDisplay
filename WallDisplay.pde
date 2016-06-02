import controlP5.*;

boolean useOnlineData = false;

JSONObject config; // Configuration Values

ControlP5 cp5;
Textlabel labelClock;
Textlabel labelWeatherIcon;
Textlabel labelWeatherHigh;
Textlabel labelWeatherLow;
Textlabel labelWeatherTemperature;

PImage backgroundImg;
  
void setup() {
  size(800,480);
  //fullScreen();
  noStroke();

  // Load Config
  config = loadJSONObject("config.json");
  
  if (config.getBoolean("hideCursor")) {
    noCursor();
  }
  
  if (!config.isNull("useOnlineData")) {
    useOnlineData = config.getBoolean("useOnlineData");
  }

  // Load images
  backgroundImg = loadImage("bkg_firecherry.jpg");

  // Build UI
  cp5 = new ControlP5(this);

  // Create Tabs
  cp5.addTab("lights");

  // if you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)

  cp5.getTab("default")
     .setColorBackground(0x7F001F3F)
     .setColorActive(0x7F39CCCC)
     .setHeight(40)
     .setWidth(100)
     .activateEvent(true)
     .setLabel("home")
     .setId(1)
     .getCaptionLabel().align(CENTER,CENTER)
     ;

  cp5.getTab("lights")
     .setColorBackground(0x7F001F3F)
     .setColorActive(0x7F39CCCC)
     .setHeight(40)
     .setWidth(100)
     .activateEvent(true)
     .setId(2)
     .getCaptionLabel().align(CENTER,CENTER)
     ;

  labelClock = cp5.addTextlabel("clock")
                  .setText("00:00")
                  .setFont(loadFont("UASquared-150.vlw"))
                  .setColorValue(0xbfffffff)
                  .setPosition(0,320)
                  ;
  
  // Weather Display
  labelWeatherIcon = cp5.addTextlabel("weatherIcon")
                        .setText(str(char(0xf07d)))
                        .setFont(loadFont("WeatherIcons-Regular-200.vlw"))
                        .setColorValue(0xbfffffff)
                        .setPosition(350,220)
                        ;

  labelWeatherHigh = cp5.addTextlabel("weatherHigh")
                        .setText(str(100) + "*")
                        .setFont(loadFont("UASquared-50.vlw"))
                        .setColorValue(0xbfffdddd)
                        .setPosition(690,400)
                        ;
  
  labelWeatherLow = cp5.addTextlabel("weatherLocal")
                       .setText(str(100) + "*")
                       .setFont(loadFont("UASquared-50.vlw"))
                       .setColorValue(0xbfddddff)
                       .setPosition(590,400)
                       ;
  
  labelWeatherTemperature = cp5.addTextlabel("weatherTemperature")
                               .setText(str(100) + "*")
                               .setFont(loadFont("UASquared-100.vlw"))
                               .setColorValue(0xbfffffff)
                               .setPosition(600,300)
                               ;
  
  weatherUpdateStats();
}

void draw() {
  background(backgroundImg);
  
  labelClock.setText(pad(hour(),2)+":"+pad(minute(),2));
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }
}

void weatherUpdateStats() {
  String url;
  if (useOnlineData) {
    url = "https://api.wunderground.com/api/" +
    config.getString("wundergroundKey") +
    "/conditions/forecast/q/" +
    config.getString("wundergroundLocation") +
    ".json";
  }
  else {
    url = "test.json";
  }
  JSONObject response = loadJSONObject(url);
  JSONObject theWeather = response.getJSONObject("current_observation");
  JSONObject theForecast = response.getJSONObject("forecast").getJSONObject("simpleforecast").getJSONArray("forecastday").getJSONObject(0);
  
  
  println(theWeather.getString("observation_time"));
  
  labelWeatherTemperature.setText(str(theWeather.getFloat("temp_f")));
  
  String high = theForecast.getJSONObject("high").getString("fahrenheit");
  labelWeatherHigh.setText(high);
  if (high.length() > 2) {
    labelWeatherHigh.setPosition(690,400);
  }
  else {
    labelWeatherHigh.setPosition(710,400);
  }
  
  String low = theForecast.getJSONObject("low").getString("fahrenheit");
  labelWeatherLow.setText(low);
  if (low.length() > 2) {
    labelWeatherLow.setPosition(590,400);
  }
  else {
    labelWeatherLow.setPosition(610,400);
  }
  labelWeatherLow.setText(theForecast.getJSONObject("low").getString("fahrenheit"));
}

String pad(int n, int l) {
  String num_str = str(n);
  
  for (int i = num_str.length() ; i < l; i = i+1) {
    num_str = "0" + num_str;
  }
  
  return num_str;
}