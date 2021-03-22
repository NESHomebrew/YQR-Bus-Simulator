////////////////////////////////////////////
///
///    Skid class - blood trails...
///
///    opacity - trails fade over time
///    colour - BLOOD
///    trail - ArrayList of type PVector(x,y,opacity). 
///            Abused the z coordinate to store opacity.
///
////////////////////////////////////////////

public class Skid {
  float opacity = 255.0;
  color colour = color(#8B0303);
  ArrayList<PVector> trail = new ArrayList<PVector>();

////////////////////////////////////////////
///
///    update() Function
///
///    Takes an integer index for selecting the translated coordinates.
///    Decrements opacity. If not completely transparent, extend
///    the blood trail. Otherwise, start fading all the blood in the
///    trail. If the whole trail is invisible, remove it.
///
////////////////////////////////////////////

  void update(int index) {
    opacity -= 10;    // As crayons run out of juice, trail fades
    if(opacity >0){   // If still juice, extend trail
      PVector newSkid = bus.skidTranslated.get(index);     
      trail.add(new PVector(newSkid.x,newSkid.y,opacity));
    } else {
      for(PVector t: trail){  // Fade whole list
        t.z -= 0.2;
      }
      if(trail.size() > 0){            // If first element invisible then
        PVector first = trail.get(0);  // then delete the whole list
        if(first.z < 0){
          trail.remove(0);
        }
      }
    }
  }
  
////////////////////////////////////////////
///
///    drawSkid() Function
///
///    Draws a single blood trail
///
////////////////////////////////////////////

  void drawSkid(){
    for(PVector point : trail){
      noStroke();
      fill(colour, point.z);
      circle(point.x, point.y,BLOOD_SIZE);
      stroke(0);
    }
  }
}

////////////////////////////////////////////
///
///    drawSkids() Function
///
///    Takes an ArrayList of type Skid. Iterates through the
///    list, updates and draws each.
///
////////////////////////////////////////////

void drawSkids(ArrayList<Skid> skids) {
    int i = 0;
    for(Skid skid : skids){
      skid.update(i);  // Index passed because the translated list
      skid.drawSkid(); // belongs to the bus class
      i++;
    }
}
