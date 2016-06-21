import controlP5.*;
import java.util.concurrent.TimeUnit;
import org.dishevelled.processing.executor.Executor;

boolean useOnlineData = false;

JSONObject config; // Configuration Values
Executor executor; // Timer

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
                        .setColorValue(0xbfffaaaa)
                        .setPosition(690,400)
                        ;
  
  labelWeatherLow = cp5.addTextlabel("weatherLocal")
                       .setText(str(100) + "*")
                       .setFont(loadFont("UASquared-50.vlw"))
                       .setColorValue(0xbfaaaaff)
                       .setPosition(590,400)
                       ;
  
  labelWeatherTemperature = cp5.addTextlabel("weatherTemperature")
                               .setText(str(100) + "*")
                               .setFont(loadFont("UASquared-100.vlw"))
                               .setColorValue(0xbfffffff)
                               .setPosition(600,300)
                               ;
  
  executor = new Executor(this, 4);
  executor.repeat("weatherUpdateStats", 0, config.getInt("wundergroundRefreshMinutes"), TimeUnit.MINUTES);
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
  JSONObject theWeather = loadJSONObject("https://pup.haus/vesta/api/weather/current_observation");
  
  
  JSONObject forecast = loadJSONObject("https://pup.haus/vesta/api/weather/forecast");
  JSONObject theForecast = forecast.getJSONObject("simpleforecast").getJSONArray("forecastday").getJSONObject(0);
  
  
  println(theWeather.getString("observation_time"));
  
  // Set Outside Temp
  labelWeatherTemperature.setText(str(theWeather.getFloat("temp_f")));
  
  // Set High Temp
  String high = theForecast.getJSONObject("high").getString("fahrenheit");
  labelWeatherHigh.setText(high);
  if (high.length() > 2) {
    labelWeatherHigh.setPosition(690,400);
  }
  else {
    labelWeatherHigh.setPosition(710,400);
  }
  
  // Set Low Temp
  String low = theForecast.getJSONObject("low").getString("fahrenheit");
  labelWeatherLow.setText(low);
  if (low.length() > 2) {
    labelWeatherLow.setPosition(590,400);
  }
  else {
    labelWeatherLow.setPosition(610,400);
  }
  labelWeatherLow.setText(theForecast.getJSONObject("low").getString("fahrenheit"));
  
  // Set Weather Icon
  String iconString = theForecast.getString("icon");
  switch(iconString) {
    case "chanceflurries":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf0b2)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf0b4)));
      }
      break;
    case "chancerain":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf008)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf028)));
      }
      break;
    case "chancesleet":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf0b2)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf0b4)));
      }
      break;
    case "chancesnow":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf00a)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf02a)));
      }
      break;
    case "chancetstorms":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf010)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf02d)));
      }
      break;
    case "clear":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf00d)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf077)));
      }
      break;
    case "cloudy":
      labelWeatherIcon.setText(str(char(0xf013)));
      break;
    case "flurries":
      labelWeatherIcon.setText(str(char(0xf064)));
      break;
    case "fog":
      labelWeatherIcon.setText(str(char(0xf014)));
      break;
    case "hazy":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf0b6)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf063)));
      }
      break;
    case "mostlycloudy":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf002)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf086)));
      }
      break;
    case "partlycloudy":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf07d)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf07e)));
      }
      break;
    case "partlysunny":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf002)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf086)));
      }
      break;
    case "mostlysunny":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf07d)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf07e)));
      }
      break;
    case "sleet":
      labelWeatherIcon.setText(str(char(0xf0b5)));
      break;
    case "rain":
      labelWeatherIcon.setText(str(char(0xf019)));
      break;
    case "snow":
      labelWeatherIcon.setText(str(char(0xf01b)));
      break;
    case "sunny":
      if (hour() < 18) {
        // Day
        labelWeatherIcon.setText(str(char(0xf00d)));
      }
      else {
        // Night
        labelWeatherIcon.setText(str(char(0xf02e)));
      }
      break;
    case "tstorms":
      labelWeatherIcon.setText(str(char(0xf01e)));
      break;
    case "unknown":
      labelWeatherIcon.setText(str(char(0xf03e)));
      break;
  }
}

String pad(int n, int l) {
  String num_str = str(n);
  
  for (int i = num_str.length() ; i < l; i = i+1) {
    num_str = "0" + num_str;
  }
  
  return num_str;
}