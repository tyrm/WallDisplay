import controlP5.*;
import com.temboo.core.*;
import com.temboo.Library.Yahoo.Weather.*;

JSONObject config;

// Create a session using your Temboo account application details
TembooSession session;

ControlP5 cp5;
PImage backgroundImg;

final String weatherWOEID = "12797181";
int weatherConditionCode;
String weatherConditionText;
int weatherForecastCode;
String weatherForecastText;
int weatherHigh;
int weatherLow;
int weatherTemperature;
  
void setup() {
  size(800,480);
  //fullScreen();
  noStroke();

  // Load Config
  config = loadJSONObject("config.json");
  session = new TembooSession(config.getString("tembooUsername"), config.getString("tembooApplication"), config.getString("tembooKey"));
  weatherUpdateStats();

  if (config.getBoolean("hideCursor")) {
    noCursor();
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

  cp5.addTextlabel("label")
     .setText("A single ControlP5 textlabel, in yellow.")
     .setFont(loadFont("UASquared-26.vlw"))
     .setPosition(100,50)
     ;

  // 
}

void draw() {
  background(backgroundImg);

}

void weatherUpdateStats() {
  // Create the Choreo object using your Temboo session
  GetWeather getWeatherChoreo = new GetWeather(session);

  // Set inputs
  getWeatherChoreo.setWOEID(weatherWOEID);

  // Run the Choreo and store the results
  GetWeatherResultSet getWeatherResults = getWeatherChoreo.run();

  // Update display variables
  weatherConditionCode = int(getWeatherResults.getConditionCode());
  weatherConditionText = getWeatherResults.getConditionText();
  weatherForecastCode  = int(getWeatherResults.getForecastCode());
  weatherForecastText  = getWeatherResults.getForecastText();
  weatherHigh          = int(getWeatherResults.getHigh());
  weatherLow           = int(getWeatherResults.getLow());
  weatherTemperature   = int(getWeatherResults.getTemperature());
}