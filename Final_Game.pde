/*
Sasha Heye
MAZE GAME

This project is a maze videogame with 4 levels of difficulty. The player must complete each maze
without losing all 5 lives in order to win. Lives are lost when the player touches a wall or doesn't
finish the maze in time. If the player does this, they have to start back at the beginning of their maze.
*/




/*TO-DO:
-GAME OVER BUTTONS NOT WORKING
-PULSATING COLOR WHEN YOU WIN
- zap sound when you touch the wall
- intro and outro theme
*/

import processing.video.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer song;
AudioPlayer gameover;
AudioPlayer zap;
AudioPlayer win;
FFT fftLin;
FFT fftLog;


PImage level1;
PImage level2;
PImage level3;
PImage level4;

PImage hat;

PFont font;


//timer
int time;
int wait = 1000;
int i = 10;
int life = 5;


int direction = 1; //person faces right by default?
int xpos = 10;
int ypos = 100;
int level = 0;

int move = 1; //1 is right, 2 is left, 3 is up, 4 is down
boolean stopped;


void setup() {
   size(800, 1000);
   level1 = loadImage("mazelevel1.png");
   level2 = loadImage("mazelevel2.png");
   level3 = loadImage("mazelevel3-final.png");
   level4 = loadImage("mazelevel4b.png");
   
   hat = loadImage("partyhat.png");
   
   time = millis();//store the current time
   
   font = createFont("upheavtt.ttf", 20);
   textFont(font);
   
  minim = new Minim(this);
  song = minim.loadFile("coconut.mp3", 1024);
  song.loop();
  
  //GAMEOVER
  gameover = minim.loadFile("gameover.wav", 1024);
  zap = minim.loadFile("zap.mp3", 1024);
  win = minim.loadFile("zap.mp3", 1024);
  
}



void draw() {
  background(0); 
      

 

  if(level == 0) {
    push();
    fill(100);
    triangle(width/2-15, height/2-180, width/2+15, height/2-180, width/2, height/2-150); //DOWN
    triangle(width/2-40, height/2-205, width/2-40, height/2-235, width/2-70, height/2-220); //LEFT
    triangle(width/2-15, height/2-260, width/2+15, height/2-260, width/2, height/2-290); //UP
    triangle(width/2+40, height/2-205, width/2+40, height/2-235, width/2+70, height/2-220); //RIGHT
    textSize(30);
    textAlign(CENTER);
    text("DOWN", width/2, height/2-110);
    text("LEFT", width/2-120, height/2-215);
    text("UP", width/2, height/2-310);
    text("RIGHT", width/2+130, height/2-215);
    pop();
    
    textSize(80);
    textAlign(CENTER);
    text("MAZE GAME", width/2, height/2);

    push();
      stroke(250);
      //BEGIN
    if(mouseX > (width/2-70) && mouseX < (width/2-70) + 140 && mouseY > (height/2 + 60) && mouseY < (height/2 + 60 + 60)) {
      if(mousePressed){
        level = 1;
        start();
      }
      fill(100);
    } else {
      noFill();      
    }
    rect(width/2-70, height/2 + 60, 140, 60);
    pop();
    
    textSize(40);
    text("BEGIN", width/2, height/2 + 100);
  }
  
  if (level == 1) {
    image(level1, 0, 0); 

    timer();
    lives();
  }
    if (level == 2) {
    image(level2, 0, 0); 

    timer();
    lives();
  }
    if (level == 3) {
    image(level3, 0, 0); 

    timer();
    lives();
  }
    if (level == 4) {
    image(level4, 0, 0); 

    timer();
    lives();
  }
  
  
  
  if (level == 5) {
    stroke(250);
    
    
    push();
    //PLAY AGAIN
    if(mouseX > (width/2 - 100) && mouseX < (width/2 - 100) + 200 && mouseY > (height/2+ 43) && mouseY < (height/2+ 43 + 40)) {
      if(mousePressed){
        level = 0;
      }
      fill(100);
    } else {
      noFill();      
    }
    rect(width/2-100, height/2+ 43, 200, 40);
    pop();
    
    /*
    push();
    //EXIT
    if(mouseX > (width/2 + 25) && mouseX < (width/2 + 25) + 185 && mouseY > (height/2+ 43) && mouseY < (height/2+ 43 + 40)) {
      if(mousePressed){
        level = 0;
      }
      fill(100);
    } else {
      noFill();      
    }
    rect(width/2 + 25, height/2+ 43, 185, 40);
    pop();
    */

    
    
    push();
    textSize(80);
    textAlign(CENTER);
    text("YOU WIN!", width/2, height/2);
    textSize(30);
    text("PLAY AGAIN", width/2, height/2 + 70);
    //text("EXIT GAME", width/2 + 120, height/2+70);
    
    pop();

    }

  
  //CONTROLLER FOR KEYS, RUNNING INTO WALLS, ZAP SOUND, LIFE DECREMENT
  
  if(keyPressed && keyCode == RIGHT) {
    if(level == 0){
      push();
      textSize(30);
      text("RIGHT", width/2+130, height/2-215);
      triangle(width/2+40, height/2-205, width/2+40, height/2-235, width/2+70, height/2-220); //RIGHT
      pop();
    }
    if(get(xpos + 2, ypos) != -15138817) {
      xpos += 2;
    } else {
       start();
       zap();
       life--;
    }
   }   
   
   if(keyPressed && keyCode == LEFT) {
    if(level == 0){
      push();
      textSize(30);
      text("LEFT", width/2-120, height/2-215);
      triangle(width/2-40, height/2-205, width/2-40, height/2-235, width/2-70, height/2-220); //LEFT
      pop();
    }
    if(get(xpos - 2, ypos) != -15138817) {
      xpos += -2;
    } else {
       start();
       zap();
       life--;
    }
   } 
   
   if(keyPressed && keyCode == UP) {
     if(level == 0){
      push();
      textSize(30);
      text("UP", width/2, height/2-310);
      triangle(width/2-15, height/2-260, width/2+15, height/2-260, width/2, height/2-290); //UP
      pop();
    }
    if(get(xpos, ypos - 2) != -15138817) {
      ypos += -2;
    } else {
       start();
       zap();
       life--;
    }
   } 
   
   if(keyPressed && keyCode == DOWN) {
     if(level == 0){
      push();
      triangle(width/2-15, height/2-180, width/2+15, height/2-180, width/2, height/2-150);
      textSize(30);
      textAlign(CENTER);
      text("DOWN", width/2, height/2-110);
      pop();
    }
    if(get(xpos, ypos + 2) != -15138817) {
      ypos += 2;
    } else {
       start();
       zap();
       life--;
    }
   } 

  //MAZE COMPLETED, TIMER RESTARTS, GO TO NEW LEVEL
  if(xpos > width) {
    start();
    level += 1; 
    i = 0;
    timer();
  }
  
 //OUR MOVING ELLIPSE ---------------
  push();
  if(level == 5){
    push();
    hat.resize(25, 25);
    translate(xpos, ypos);
    image(hat, -12, -28); //PARTY HAT
    pop();
    fill((frameCount * 1000) + 100, 10, (frameCount * 1000) - 100);
  } else {
    fill(255);
  }
  translate(xpos, ypos);
  ellipse(0, 0, 10, 10);    
  pop();
//-------------------------------------  


//GAME OVER WHEN YOU LOSE ALL LIVES
  if(life < 0){
    push();
    fill(0);
    noStroke();
    rect(0, 0, 800, 1000);
    pop();
    
    textAlign(CENTER);
    textSize(50);
    text("GAME OVER, YOU LOSE", width/2, height/2);

    
    push();
    //PLAY AGAIN
    if(mouseX > (width/2 - 210) && mouseX < (width/2 - 210) + 200 && mouseY > (height/2+ 43) && mouseY < (height/2+ 43 + 40)) {
      if(mousePressed){
        level = 0;
      }
      fill(100);
    } else {
      noFill();      
    }
    rect(width/2- 210, height/2+ 43, 200, 40);
    pop();
    
    
    push();
    //EXIT
    if(mouseX > (width/2 + 25) && mouseX < (width/2 + 25) + 185 && mouseY > (height/2+ 43) && mouseY < (height/2+ 43 + 40)) {
      if(mousePressed){
        level = 0;
      }
      fill(100);
    } else {
      noFill();      
    }
    rect(width/2 + 25, height/2+ 43, 185, 40);
    pop();
    
    textSize(30);
    text("PLAY AGAIN", width/2 - 110, height/2 + 70);
    text("EXIT GAME", width/2 + 120, height/2+70);
    
  }


  println(life);

 }
 
 
//------------------------------------------------------------

void start() {
  xpos = 10;
  ypos = 150;
}
 
 
void zap() {
  
}


//RECTANGLES THAT REPRESENT LIVES 
void lives(){
  push();
  rectMode(CENTER);
  if(life == 5){
    push();
    fill(250);
    rect(80, 930, 70, 70);
    rect(width/2-160, 930, 70, 70);
    rect(width/2, 930, 70, 70);
    rect(width/2 + 160, 930, 70, 70);
    rect(width-80, 930, 70, 70);
    pop();
  }
  if(life == 4){
    push();
    fill(250);
    rect(80, 930, 70, 70);
    rect(width/2-160, 930, 70, 70);
    rect(width/2, 930, 70, 70);
    rect(width/2 + 160, 930, 70, 70);
    fill(100);
    rect(width-80, 930, 70, 70);
    pop();

  }
  if(life == 3){
    push();
    fill(250);
    rect(80, 930, 70, 70);
    rect(width/2-160, 930, 70, 70);
    rect(width/2, 930, 70, 70);
    fill(100);
    rect(width/2 + 160, 930, 70, 70);
    rect(width-80, 930, 70, 70);
    pop();
  }
  if(life == 2){
    push();
    fill(250);
    rect(80, 930, 70, 70);
    rect(width/2-160, 930, 70, 70);
    fill(100);
    rect(width/2, 930, 70, 70);
    rect(width/2 + 160, 930, 70, 70);
    rect(width-80, 930, 70, 70);
    pop();
  }
  if(life == 1){
    push();
    fill(250);
    rect(80, 930, 70, 70);
    fill(100);
    rect(width/2-160, 930, 70, 70);
    rect(width/2, 930, 70, 70);
    rect(width/2 + 160, 930, 70, 70);
    rect(width-80, 930, 70, 70);
    pop();
  }
  if(life == 0){
    push();
    fill(100);
    rect(80, 930, 70, 70);
    rect(width/2-160, 930, 70, 70);
    rect(width/2, 930, 70, 70);
    rect(width/2 + 160, 930, 70, 70);
    rect(width-80, 930, 70, 70);
    pop();
  }
  pop();
}


//TIMER
void timer(){
  if(millis() - time >= wait){
      //println("tick");//if it is, do something
      time = millis();//also update the stored time
      i += 15;
  }
  rect(45, 840, 700-i, 20); 
  push();
  noFill();
  stroke(250);
  rect(41, 837, 707, 27);
  pop();
  
  if(i >= 700){
    life--;
    start();
    i = 0;
  }
 
}

  
