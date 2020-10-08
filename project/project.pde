//HASSAN WALEED BOOTCAMP PROJECT

int rectW = 50, rectH = 50; //holes size

boolean inGame, checked, moving;//status

//ball position and parameters
int w=50;
float x, y;

int radius=25;//ball radius

//ball velocity
float vx, vy;
float friction = 0.005f;
float minVel = 0.03f;

//countdown
int timer;
int sec=60;
String ssec;

import processing.sound.*;   // Import the library that does the sound handling.
SoundFile table;


PImage img, start;//images

int c;//count points

void setup() {

  size(768, 405);

  //song object
  table  = new SoundFile(this, "table.wav");

  //img loading
  img = loadImage("resize.jpg");
  start = loadImage("start.png");

  //centre
  x = width/2 - w/2; 
  y = height/2 - w/2;

  c = 0;

  table.play();
}

void draw() {
  //snooker table img
  image(img, 0, 0);

  //start img
  image(start, 180, height-350);
  textSize(20);
  fill (255); 
  text("\nPRESS START TO CONTINUE: ", width/2, 240);

  if (moving) {
    vx = lerp(vx, 0, friction);//increment steadily the speed
    vy = lerp(vy, 0, friction);

    if (abs(vx) < minVel && abs(vy) < minVel) {//check if the speed is higher than minVel, if yes the ball will stop moving
      vx = 0;
      vy = 0;

      Restart();
    }
  }

  textSize(20);
  fill (255); 
  textAlign(CENTER);
  text("\n\nRULES: Pocket as many balls as possible in 60 seconds\n Press Z to hit the ball", width/2, 240);

  if (inGame==true) {
    clear(); //clear start screen

    image(img, 0, 0);//table image

    drawBall();
    timer();
    drawAimingLine();

    moveBall();
    bounceOffWalls();
    checkForAngles();

    textSize(32);
    fill (255); 
    text("\nPOINTS: "+c, width/2, 35);
    fill(255, 0, 0);

    textSize(7);
    fill(180);
    text("Sound effects obtained from https://www.zapsplat.com", width-200, height-50);
  }
}

void mouseClicked() {
  //check if mouse is clicked on the start image
  if ( (mouseX > 180 && mouseX < 600) && (mouseY > 55 && mouseY < 285) )
    inGame = true;
}

void keyPressed() {
  if (key == 'z' && !moving && inGame) {
    float dist = sqrt(pow((mouseX-x), 2) + pow((mouseY-y), 2));
    vx = (mouseX - x - w/2) / (30000 / dist); //the velocity will depend from the distance of the mouse and the ball
    vy = (mouseY - y - w/2) / (30000 / dist);
    moving = true;
  }
}

void drawBall() {
  noStroke();
  //draw ball
  ellipseMode(CENTER);
  fill(255);
  ellipse(x+25, y+25, radius, radius);
}

void moveBall() {
  if (inGame == true) {
    x = x + vx;
    y = y + vy;
  }
}

void drawAimingLine() {
  if (!moving) {
    stroke(#C6A020);
    strokeWeight(4);
    line(x+rectW/2, y+rectH/2, width-mouseX, height-mouseY);
  }
}

void checkForAngles() {
  //check if the ball is in the hole

  checked = false;
  //top left angle
  if (x+w/2+15 <= rectW && y+w/2-10 <= rectH) {
    checked = true;
    table.play();
  }
  //top centre angle
  if (x+w/2>= width/2-18 && y+w/2 <= rectH/2 && x+w/2 <= width/2-18 + rectW-10 ) {

    checked = true;
    table.play();
  }
  //top right angle
  if (x+w >= width-rectW/2 && y+w <= rectH) {

    checked = true;
    table.play();
  }

  //bottom left angle
  if (x+w/2 <= rectW && y+w/2 >= height-rectH/2) {
    checked = true;
    table.play();
  }
  //bottom right angle
  if (x+w/2+10 >= width-rectW/2 && y+w/2 >= height-rectH/2) {
    checked = true;
    table.play();
  }
  //bottom centre angle
  if (x+w/2 >= width/2-18 && y+w/2 >= height-rectH/2 && x+w/2 <= width/2-18 + rectW-10) {
    checked = true;
    table.play();
  }

  /*if (x+w >= width/2-rectW/2 && y+w <= rectH) {
   
   checked = true;
   table.play();
   }*/

  if (checked) {
    c++;
    Restart();
  }
}

void timer() {//countdown of 60 seconds
  ssec = nf(sec, 2);
  textSize(32);
  fill(255);

  text(ssec, width-180, 50);

  timer++;

  if (timer%60 == 0) 
    sec--;
  if ( sec == 0)
    end();
}

void bounceOffWalls() {
  if (x<width -55) {
    vx*=-1;
  }
  if (x>=5) {
    vx*=-1;
  }


  if (y<height - w) {
    vy*=-1;
  }
  if (y>=0) {
    vy*=-1;
  }
}


void stopBall() {
  vx = 0;
  vy = 0;
}

void Restart() {
  x = width/2 - w/2;
  y = height/2 - w/2;
  stopBall();
  moving = false;
}

void end() {//game will be closed
  clear();
  exit();
}
