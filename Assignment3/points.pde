////////////////////////////////////////////
///
///    Points class - fancy colourful numbers that float into space
///
///    x,y - coordinates
///    colour - random body colour
///    angle - used to generate colours
///    faderR,faderG,faderB - hold my RGB values
///    pointValue - the numbers
///
////////////////////////////////////////////

public class Points {
  float x,y;
  color colour;
  float angle,faderR,faderG,faderB;
  int pointValue;
  
////////////////////////////////////////////
///
///    Constructor
///
///    Takes an x,y and value. Initializes angle.
///
////////////////////////////////////////////
  
  Points(int px, int py, int pv){
      x = px;
      y = py;
      angle = 0.0;
      pointValue = pv;
   }
   
////////////////////////////////////////////
///
///    update() function
///
///    Gets a new RGB fader value. Sets the colour. Shifts it
///    a pixel to the right. Wobbles it. Increments the angle.
///
////////////////////////////////////////////
   
   void update(){
     faderR = (sin(angle) +1)/2;
     faderG = (cos(angle) +1)/2;
     faderB = (tan(angle) +1)/2;
     colour = color(int(faderR*255),int(faderG*255),int(faderB*255));
     x++;
     y += sin(frameCount*0.4) - angle*0.5;  // The 0.4 changes the frequency, and the 0.5
     angle += 0.05;                         // changes the rate of ascention
   }
}

////////////////////////////////////////////
///
///    drawPoints() function
///
///    Takes an ArrayList of type Points. Iterates through the list
///    backwards and displays them. If the point leaves the top of
///    the screen it is removed from the list.
///
////////////////////////////////////////////

void drawPoints(ArrayList<Points> points) {
  for(int i = points.size()-1; i >= 0; i--){
    Points point = points.get(i); 
    fill(point.colour);
    textFont(font2);
    textSize(14);
    text(str(point.pointValue),point.x,point.y);
    point.update();
    if(point.y < 0) points.remove(point);
  }
}
