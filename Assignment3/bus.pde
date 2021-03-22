////////////////////////////////////////////
///
///    Bus class
///
///    x,y,w,h - initial location and size of bus
///    rotation - rotation of bus in radians
///    speed, maxSpeed, friction - for accelleration, and deceleration
///    v - the four verticies for the bus corners. Used for collision detection
///    skidOrigin - coordinates of where a person dies
///    skidTranslated - follows the bus so the blood trail knows where to go
///
////////////////////////////////////////////

public class Bus {
  float x, y, w, h;
  float rotation, speed, maxSpeed, friction;
  PVector[] v = new PVector[4];
  ArrayList<PVector> skidOrigin = new ArrayList<PVector>();
  ArrayList<PVector> skidTranslated = new ArrayList<PVector>();

////////////////////////////////////////////
///
///    Bus default constructor
///
///    Construct and initialize!
///
////////////////////////////////////////////

  Bus() {
    x = 250;
    y = 400;
    w = 100;
    h = 40;
    rotation = radians(270);
    speed = 0;
    maxSpeed = MAX_BUS_SPEED;
    friction = BUS_FRICTION;
    
    v[0] = new PVector(0.0,0.0);
    v[1] = new PVector(0.0,0.0);
    v[2] = new PVector(0.0,0.0);
    v[3] = new PVector(0.0,0.0);
  }
    
////////////////////////////////////////////
///
///    Bus update() function
///
///    Much of the update function is based upon work by John McCaffrey and the
///    sketch can be downloaded from his github:
///    https://github.com/theartboy/lectureDemosProgramming/tree/master/spriteRotation
///    As well there is an accompanying video: https://www.youtube.com/watch?v=9d_a-7Y6SiI
///
////////////////////////////////////////////
    
  void update() {
    
      
      if(v[0].x <= 0  || v[0].x >= 500 ||    // This giant IF statement is used to
         v[1].x <= 0  || v[1].x >= 500 ||    // keep the bus within the 500x500
         v[2].x <= 0  || v[2].x >= 500 ||    // playing window. If any of the 4 verticies
         v[3].x <= 0  || v[3].x >= 500 ||    // leave the window, then the speed is reversed.
         v[0].y <= 30 || v[0].y >= 500 ||    // This gives the bus a bouncing effect when it
         v[1].y <= 30 || v[1].y >= 500 ||    // hits the border. I also multiply the accelleration
         v[2].y <= 30 || v[2].y >= 500 ||    // by 1.1 because you can occasionally get stuck in
         v[3].y <= 30 || v[3].y >= 500) {    // the wall, and this helps prevent that.
        speed = -speed*1.1;
      }
    
    
    if (left && !right ){
     rotation += -.1 * speed/10; 
    }
    if (right && !left ) {
      rotation += .1 * speed/10;
    } 
    if (up && !down){
      if (speed<maxSpeed){
        speed+=0.2;
      }else{
        speed=maxSpeed;
      }
    }
    if (down && !up) {
      if (speed>-maxSpeed){
        speed-=0.2;
      }else{
        speed=-maxSpeed;
      }
    }
    if (!up && !down){
      speed *= friction;
      if(speed < 0.1 && speed > -0.1){  // without this check, the bus
        speed = 0.0;                    // doesn't always come to a
      }                                 // complete stop
    }
 
    x += cos(rotation)*speed;  // updates the bus origin
    y += sin(rotation)*speed;
  }

////////////////////////////////////////////
///
///    drawBus() function
///
///    I think +90% of my development work was spent in this function...
///    The first section updates the four verticies of the bus. Before
///    everything, the push saves the screen orientation to the stack. The translate
///    moves the origin to the middle of the screen and close to the bottom.
///    It then rotates the desired radians, saves the new four verticies,
///    draws the bus and finally resets the previous coordinate orientation
///    from the stack.
///
///    The next section also saves and restores the screen orientation on the
///    stack. It iterates through the ArrayList of skidOrigins and converts them
///    to the corresponding skidTranslated list. This we the most difficult part
///    of the program and I still haven't gotten it right. Uncomment the push and 
///    pop inside of the loop to see sort of what I was going for. I randomly 
///    commented them out and liked the result better, but left them in for
///    posterity.
///
////////////////////////////////////////////

  void drawBus() {
    pushMatrix();      // SAVE
    translate(x,y);    // MOVE
    rotate(rotation);  // ROTATE
    v[0].set(screenX(0 + (w*2)/3,20),screenY(0 + (w*2)/3,20));
    v[1].set(screenX(0 + (w*2)/3,-20),screenY(0 + (w*2)/3,-20));
    v[2].set(screenX(0 - w/3,-20),screenY(0 - w/3,-20));
    v[3].set(screenX(0 - w/3,20),screenY(0 - w/3,20));
    image(img,0-w/3,0-h/2);
    popMatrix();   // RESTORE
    
    pushMatrix();  // SAVE
    for(int i = skidOrigin.size()-1; i >= 0; i--){
      PVector origin = skidOrigin.get(i);
      PVector translated = skidTranslated.get(i);
      //pushMatrix();
      translate(x-origin.x, y-origin.y);
      translated.set(screenX(origin.x,origin.y),screenY(origin.x, origin.y));
      //popMatrix();
    }
    popMatrix();  // RESTORE
  }
  
////////////////////////////////////////////
///
///    polyPoint() function
///
///    This function is the meat and potatoes of the collision detection.
///    I fully credit: http://www.jeffreythompson.org/collision-detection/poly-point.php
///
///    It's a really great online book that had the exact method of collision detection
///    I needed. It can detect any point inside of a polygon. In my case, the polygon is
///    created using the four verticies, and the points are the little people.
///
////////////////////////////////////////////

  boolean polyPoint(PVector[] vertices, float px, float py) {
  boolean collision = false;

  // go through each of the vertices, plus
  // the next vertex in the list
  int next = 0;
  for (int current=0; current<vertices.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position
    // this makes our if statement a little cleaner
    PVector vc = vertices[current];    // c for "current"
    PVector vn = vertices[next];       // n for "next"

    // compare position, flip 'collision' variable
    // back and forth
    if (((vc.y >= py && vn.y < py) || (vc.y < py && vn.y >= py)) &&
         (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
            collision = !collision;
    }
  }
  return collision;
}
}
