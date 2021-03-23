////////////////////////////////////////////
///
///     CTCH204 - Assignment#3
///
///     Program:  Assignment3.pde   bus.pde
///               hud.pde           meatCrayon.pde
///               points.pde        skid.pde
///     Title: "YQR Bus Simulator"
///     Author: Bradley Bateman - 200262023
///     Email: batemanb@uregina.ca
///     Date: Mar 21/2021
///
////////////////////////////////////////////
//
//      CONSTANTS
//
////////////////////////////////////////////
final float TIMER_LENGTH = 30.0;  // DEFAULT: 30.0 - Length of round
final int TOTAL_PEEPS = 200;      // DEFAULT: 200 - maximum characters
final int SPAWN_FREQUENCY = 5;    // DEFAULT: 5 - values >=1 lower numbers mean more people, but bad performance
final int PHRASE_FREQUENCY = 20;  // DEFAULT: 20 - kills per phrase change
final int MAX_BUS_SPEED = 6;      // DEFAULT: 6 - bus go brrrrrr...  
final float BUS_FRICTION = 0.9;   // DEFAULT: 0.9 - 1.0 -> no deceleration - very sensitive try adding nines
final int BLOOD_SIZE = 15;        // DEFAULT: 15 - soo much bloooood....

////////////////////////////////////////////
//
//      GLOBAL VARIABLES
//
////////////////////////////////////////////

Bus bus = new Bus();      // it's a bus!
int score = 0;            // init score
int highScore, lowScore;  // scores!
boolean newHighScore = false;   // tracks if a new highscore is achieved
int deathCounter = 0;           
String currentPhrase = "";      
boolean left, right, up, down;  // controls
PFont font,font2,font3;         // fonts
float timer = TIMER_LENGTH; 
float elapsed;  // tracks milliseconds
float target;   // used for offsetting TIMER_LENGTH seconds
PImage img;     // stores the png of the bus


ArrayList<MeatCrayon> crayons = new ArrayList<MeatCrayon>(); // all the little people
ArrayList<Skid> skids = new ArrayList<Skid>();               // blood of the little people
ArrayList<Points> points = new ArrayList<Points>();          // points particles

enum GameState {
  TITLE,
  PLAYING,
  FINISHED
}

// Different people types
enum Type {
  DEFAULT, // just a person
  WHEELS,  // person with wheels - slow
  OLD,     // cane - slower
  ARISTON  // much speddy boi - fast as F@#%
}
GameState currentState = GameState.TITLE; // init gamestate

void setup() {
  size(500,500,P2D);
  surface.setTitle("YQR Bus Simulator");

  // load external files
  font = loadFont("Monospaced.bold-32.vlw");
  font2 = loadFont("Cambria-Italic-14.vlw");
  font3 = loadFont("Monospaced.bold-16.vlw");
  img = loadImage("busScaled.png");

  
  // create/load highscore file
  fileExists();
  String[] scores = loadStrings(dataFile("scores.txt"));
  lowScore = int(scores[0]);
  highScore = int(scores[1]);
  
  // init controls
  left = false;
  right = false;
  up = false;
  down = false; 
}
////////////////////////////////////////////
///
///     DRAW LOOP
///
///     Elements in the game are drawn in layers. First 
///     the background, followed by the blood trails. Next 
///     are the people, bus, then finally the heads up display. 
///
////////////////////////////////////////////
void draw() {
  background(100);
  textFont(font);

  if(currentState != GameState.TITLE) 
  {
    drawSkids(skids);
    drawMeatCrayon(crayons);
  }
  bus.update();
  bus.drawBus();
  drawPoints(points);
  drawHud();
}
////////////////////////////////////////////
///
///     keyPressed/keyReleased functions
///
///     Is automagically triggered when a key is pressed/released
///     on the keyboard. I've added support for the
///     arrow keys and WASD. The SPACEBAR is used to
///     initialize the game by setting states and initializing
///     variables.
///
////////////////////////////////////////////

void keyPressed() {
  switch (keyCode) {
  case 32://space
    if(currentState != GameState.PLAYING) {
      currentState = GameState.PLAYING;
      timer = TIMER_LENGTH;
      target = millis() + (TIMER_LENGTH*1000);
      score = 0;
      newHighScore = false;
      currentPhrase = "";
    }
    break;
  case 65:// A
  case 37:// left
    left = true;
    break;
  case 68:// D
  case 39:// right
    right = true;
    break;
  case 87:// W
  case 38:// up
    up = true;
    break;
  case 83:// S
  case 40:// down
    down = true;
    break;
  }
}

void keyReleased() {
  switch (keyCode) {
  case 65:// A
  case 37:// left
    left = false;
    break;
  case 68:// D
  case 39:// right
    right = false;
    break;
  case 87:// W
  case 38:// up
    up = false;
    break;
  case 83:// S
  case 40:// down
    down = false;
    break;
  }
}
////////////////////////////////////////////
///
///     fileExists() function
///
///     This function checks to see if the "scores.txt"
///     file exists in the data folder. If it doesn't exist
///     then the saveStrings function will create a new file
///     with initial lowscore and highscore of "0".
///
////////////////////////////////////////////
void fileExists(){
  File f = dataFile("scores.txt");
  boolean exist = f.isFile();
  if(!exist) {
    saveStrings(f, new String[]{"0","0"});
  } 
}
