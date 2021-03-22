////////////////////////////////////////////
///
///    drawHud() function
///
///    This is the last element to draw and thus is an
///    overlay for the game field
///
////////////////////////////////////////////

void drawHud() {
  // draw the top bar
  fill(#D8D8D8);
  rect(0,0,500,40);
  
  // draw the text on the top bar 
  // and the score at the bottom
  textSize(32);
  textFont(font);
  fill(0);
  text("Time: " + nf(timer,2,3) , 270, 30);
  fill(#D8D8D8);
  text("Score: " + score, 9, 481);
  fill(0);
  text("Score: " + score, 10, 480);
  textSize(16);
  textFont(font3);
  text("Lowscore: " + lowScore , 10, 16);
  // If the score beats the highscore, it turns red on the top bar
  if(newHighScore) {fill(#FF0000);}
  text("Highscore: " + highScore , 10, 34);


  switch(currentState) {
    case PLAYING: 
    {
      elapsed = millis();     // Grabs the total seconds elapsed since the program started
      timer = updateTimer();  // calculates the remaining time on the timer  

      if(timer < 0) {
        timer = 0.000;  // this often ends slightly negative, so reset it to a proper 0.00
        currentState = GameState.FINISHED; // update game state
        saveScores();  // save the scores to file
      }
      if(currentPhrase != "") { // draws a phrase on screen if the 
        textFont(font2);        // value was previously set
        textSize(14);           // The ellipse is dynamically sized
        textAlign(CENTER);      // based on the length of the phrase
        fill(#D8D8D8);
        ellipse(bus.x,bus.y-5,textWidth(currentPhrase) + 30, 30);
        fill(0);
        text(currentPhrase, bus.x, bus.y); 
        textAlign(LEFT);
      }
      break;
    }
    case TITLE:
    {
      textSize(32);
      textFont(font);
      textAlign(CENTER);
      fill(#D8D8D8);
      text("PRESS SPACE TO START", width/2, height/2);
      fill(0);
      text("PRESS SPACE TO START", width/2+1, height/2-1); 
      textAlign(LEFT);
      break;
    }
    case FINISHED:
    {
      textSize(32);
      textFont(font);
      textAlign(CENTER);
      fill(#D8D8D8);
      text("No charges were laid...", width/2, height/2);
      fill(0);
      text("No charges were laid...", width/2+1, height/2-1); 
      textSize(18);
      textFont(font3);
      fill(#D8D8D8);
      text("Press space to play again!", width/2, height/2+20);
      fill(0);
      text("Press space to play again!", width/2+1, height/2+19); 
      textAlign(LEFT);
      break;
    }
    default:
    break;
  }
}

////////////////////////////////////////////
///
///    updateTimer() function returns float
///
///    target is initialized to elapsed+30 seconds when the game starts
///    every time this is called, more time has elapsed and time counts
///    down. Result is divided by 1000 to convert from milliseconds to seconds.
///
////////////////////////////////////////////

float updateTimer() {
  return (target - elapsed)/1000.0;
}

////////////////////////////////////////////
///
///    saveScores() function
///
///    If no lowScore is set, or the new score is lower than the
///    previous lowScore, it is set. These values are then written
///    to /data/scores.txt  If the file doesn't exist, it will be created.
///
////////////////////////////////////////////

void saveScores() {
  if(lowScore ==0 || score < lowScore){
    lowScore = score; 
  }
  String[] newScores = {str(lowScore),str(highScore)}; 
  saveStrings(dataPath("scores.txt"),newScores);
}
