////////////////////////////////////////////
///
///    MeatCrayon class - best class
///
///    dead - ya dead mon?
///    type - defaults to a normal person, randomized in constructor
///    colour - random body colour
///    skin - random colour lerped between beige and brown
///    x,y - location of person - used for drawing and collision detection
///    movementSpeed - will have different values based on person type
///    points - different types have different point values
///
////////////////////////////////////////////

public class MeatCrayon {
  boolean dead;
  Type type = Type.DEFAULT;
  color colour, skin;
  int x, y, movementSpeed, points;
  
  MeatCrayon(){
    dead = false;
    type = int(random(0,16))%15 == 0 ? Type.OLD : type;     // 1/15 chance of being old
    type = int(random(0,21))%20==0 ? Type.WHEELS : type;    // 1/20 chance of having wheels
    type = int(random(0,76))%75==0 ? Type.ARISTON : type;   // 1/75 chance of being Ariston
    colour = color(random(0,255),random(0,255),random(0,255));
    skin =  color(lerpColor(color(#EDC6B4),color(#643925), random(0.00,1.00)));
    
    switch(type){
      case DEFAULT:
        movementSpeed = 5;
        points = 69;   // Nice
        break;
      case OLD:
        movementSpeed = 3;
        points = 306;
        break;
      case WHEELS: 
        movementSpeed = 4;
        points = 420;
        break;
      case ARISTON:
        movementSpeed = 10;
        points = 1337;
        break;  
    }
    x = int(random(10,490));  // Starting position is between 10 and 490
    y = 0;                    // on the X-axis
  }
  
////////////////////////////////////////////
///
///    update() function
///
///    Moves the person forward to their doom or salvation
///    based on the movementSpeed defined above. Calls the
///    polyPoint function to see if the person has collided
///    with the bus. If there is a collision, the person is
///    marked as dead and their skid locations are initialized.
///
///    If a person is dead, and the game is still playing, then
///    they will recieve points for the kill (you can still kill
///    stragglers after the game ends, but it doesn't contribute
///    to your score).
///
////////////////////////////////////////////
  
  void update() {
    
    x += int(random(-2,2));  // Bit of a jitter to make things less mechanical
    y += int(random(0, movementSpeed)); // random acceleration/frame
    
    if(bus.polyPoint(bus.v, x, y)) {
      dead = true;
      bus.skidOrigin.add(new PVector(x, y));
      bus.skidTranslated.add(new PVector(x, y));

      if(currentState == GameState.PLAYING) {
        score += points;           // add points to score
        if (score > highScore) {   // update highscore if the score
          highScore = score;       // is now the highscore
          newHighScore = true;     // by setting this true, your score will
        }                          // turn red in the HUD
      }
    }
  }
}

////////////////////////////////////////////
///
///    drawMeatCrayon() function
///
///    Accepts an ArrayList of type MeatCrayon. Spawns a new person if
///    the criteria are met. Iterates through the list of meatCrayons
///    and draws them based on their type. 
///
///    Then it updates, and checks if it died. If dead, it will create 
///    a new skid, point, removes the crayon from the list, increase the 
///    death count, and either display or clear the phrase based on the criteria.
///
///    If it isn't dead, and it's location is now off the screen, it will remove
///    the crayon from the list.
///
////////////////////////////////////////////

void drawMeatCrayon (ArrayList<MeatCrayon> meatCrayon){
  if(crayons.size() < TOTAL_PEEPS &&       // If max - don't spawn more
     frameCount%SPAWN_FREQUENCY == 0 &&    // only spawn on certain frames
     currentState == GameState.PLAYING) {  // only spawn if gamestate is playing
    crayons.add(new MeatCrayon());
  }
  
  for(int i = meatCrayon.size() -1; i >=0; i--){
    MeatCrayon crayon = meatCrayon.get(i);
    
    if(crayon.type == Type.ARISTON){  // Draw the back wheel of motorcycle
      fill(100);                      // first so it can be behind the body
      strokeWeight(2);
      ellipse(crayon.x-2, crayon.y-2,6,10);
      fill(0);
      strokeWeight(1);
    }
    
    fill(crayon.colour);              // Draw the body - 
    rect(crayon.x, crayon.y,5,15);    // This is a universal part which
    fill(crayon.skin);                // is the same for all crayon types
    circle(crayon.x+2.5,crayon.y,10);
    circle(crayon.x-2,crayon.y+10,4);
    circle(crayon.x+7,crayon.y+10,4);
    
    if(crayon.type == Type.OLD){  // Old guys get a cane
      noFill();
      stroke(#643C00);
      strokeWeight(2);
      arc(crayon.x-8, crayon.y+6,5,5,-PI,0);
      line(crayon.x-5, crayon.y+6,crayon.x-5, crayon.y+16);
      fill(0);
      stroke(0);
      strokeWeight(1);
    }
    
    if(crayon.type == Type.WHEELS){  // Wheeled people get wheels
      noFill();
      strokeWeight(2);
      arc(crayon.x+5, crayon.y+15,8,8,-PI/2,PI);
      circle(crayon.x, crayon.y+14,8);
      fill(0);
      strokeWeight(1);
    }
    
    if(crayon.type == Type.ARISTON){  // Draws the front wheel
      fill(100);
      strokeWeight(2);
      ellipse(crayon.x+5, crayon.y+14,6,10);
      fill(0);
      strokeWeight(1);
    }
    crayon.update();  // Runs the update
    if(crayon.dead){  // Ya ded mon?
      skids.add(new Skid());
      points.add(new Points(crayon.x,crayon.y, crayon.points));
      meatCrayon.remove(crayon);
      deathCounter++;
      if(deathCounter%(PHRASE_FREQUENCY/2) == 0){
         currentPhrase = ""; 
      }
      if(deathCounter%PHRASE_FREQUENCY == 0) {  // Bigger numbers make better randomness
        currentPhrase = phrases[int((random(phrases.length*100)/100))]; // random() with only 15 posibilities
      }                                                                 // didn't seem random at all

    }
    if(crayon.y > 500) {
      meatCrayon.remove(crayon);
    }
  }
}

////////////////////////////////////////////
///
///    DATA
///
///    Random list of inspiring quotes I got off of
///    the internet. Sources pending...
///
////////////////////////////////////////////

String[] phrases = {
  "Dang potholes!!!",
  "10 Points for the old guy!",
  "Did you guys hear something?",
  "Gotta go fast!",
  "I don't remember a speedbump being there...",
  "I'm gonna need a car wash.",
  "And they said I needed glasses...",
  "Is somebody cooking barbeque?",
  "Cleanup on isle nine!",
  "Don't scratch the paint!",
  "Red is definitely your colour...",
  "Get on D-Bus!!",
  "Why are you runnin?",
  "Look at all those chickens!",
  "I am SPEED!!"
};
