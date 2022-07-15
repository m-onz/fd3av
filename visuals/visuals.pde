
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int pulse = 0;

void setup() {
  size(400,400);
  frameRate (20);
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

void draw() {
  background(0);
  text(""+pulse, width/2, height/2);  
}

void oscEvent(OscMessage theOscMessage) {  
  if(theOscMessage.checkAddrPattern("/pulse")==true) {
    println("pulse received");
    pulse++;
  } 
}
