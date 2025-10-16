String backgroundText;
float textX = 0;
float textWidth;

box b = new box();
wall[] walls = new wall[3];
int startTime;
int screen = 0;

void settings() {
  fullScreen();
}

void setup() {
  String[] lines = loadStrings("../memoriasdaterra_1.txt");
  backgroundText = join(lines, "\n");
  startTime = 3600;
  
  for (int i = 0; i < walls.length; i++) {
    walls[i] = new wall();
    walls[i].wallx = width + i * 600;
  }
}

void draw() {
  background(0);
  
  // Animate and draw the background text
  textSize(24);
  textWidth = textWidth(backgroundText);
  fill(255);
  
  text(backgroundText, textX, 20, textWidth, height -20);
  text(backgroundText, textX + textWidth, 20, textWidth, height - 20);
  
  textX -= 2; // Scrolling speed
  
  if (textX < -textWidth) {
    textX = 0;
  }

  if (screen == 0) {
    b.startBox();
    fill(255);
    textSize(70);
    text("Welcome to Flappy Box", width/3.6, height/6);
    fill(0);
    stroke(255);
    rect(width/6.4, height/1.5, 400, 140);
    rect(width/1.5, height/1.5, 400, 140);
    textSize(60);
    fill(255);
    text("Start", width/4.7, height/1.34);
    text("Instructions", width/1.45, height/1.34);
    if (mousePressed && mouseButton == LEFT && mouseX >= width/6.4 && mouseX <= width/6.4 + 400 && mouseY >= height/1.5 && mouseY <= height/1.5 + 140) {
      frameCount = 0; 
      screen = 1;
    }
    if (mousePressed && mouseButton == LEFT && mouseX >= width/1.5 && mouseX <= width/1.5 + 400 && mouseY >= height/1.5 && mouseY <= height/1.5 + 140) {
      screen = 2;
    }
  }
  if (screen == 2) {
    fill(0);
    stroke(255);
    rect(width/2.74, height/2.1, 400, 140);
    fill(255);
    strokeWeight(3);
    line(width/2.56, height/3.9, 880, height/3.9);
    textSize(45);
    text("Instructions", width/2.56, height/4);
    textSize(20);
    text("-Press the spacebar or left mouse button to bounce the ball up \n-Avoid all obsacles \n-Try to get as far as you can in 60 seconds", width/2.56, height/3.6);
    textSize(60);
    text("Start Game", width/2.6, height/1.7);
    if (mousePressed && mouseButton == LEFT && mouseX >= 700 && mouseX <= 1100 && mouseY>= 515 && mouseY <= 655) {
      frameCount = 0;
      screen = 1;
    }
  }
  if (screen == 1) {
    int timer = (startTime-frameCount)/60;
    textSize(50);
    fill(255);
    text(timer, 1850, 40);
    b.createBox();
    b.fall();
    b.jump();
    b.lose();
    for (int i = 0; i < walls.length; i++) {
      walls[i].spawnWall();
      b.checkCollision(walls[i]);
    }
  }
  if (screen == 3) {
    fill(255);
    textSize(60);
    text("GAME OVER", width/2.7, height/2.8);
    textSize(20);
  }
  textSize(20);
  fill(255);
  text("x: "+mouseX+" y: "+mouseY, 10, 15);
}


class box {
  float boxx;
  float boxy;
  float ySpeed;
  box() {
    boxx = 500;
    boxy = 500;
  }
  void startBox() {
    fill(255);
    rect(width/2.4 - 50, height/2.9 - 50, 300, 300);
    strokeWeight(0);
    fill(0);
    rect(width/2.4 - 50, height/2.9- 50, 150, 150);
    fill(255);
    rect(width/2.4 - 50, height/2.9 - 50, 80, 80);
  }
  void createBox() {
    fill(255);
    rect(boxx, boxy, 35, 35);
    strokeWeight(0);
    fill(0);
    rect(boxx, boxy, 20, 20);
    fill(255);
    rect(boxx, boxy, 10, 10);
  }
  void up() {
    ySpeed = -10;
  }
  void fall() {
    ySpeed += 0.4;
  }
  void jump() {
    boxy += ySpeed;
  }
  void lose() {
    if (boxy >= height) {
      screen = 3;
    }
  }

  void checkCollision(wall w) {
    if (boxx + 35 > w.wallx && boxx < w.wallx + 30) {
      if (boxy < w.wally - 125 || boxy + 35 > w.wally + 125) {
        screen = 3;
      }
    }
  }
}

class wall {
  float wallx, wally;
  wall() {
    wallx = 1600;
    wally = random(200, 800);
  }
  void spawnWall() {
    fill(255);
    stroke(0);
    rect(wallx, 0, 30, wally - 125);
    rect(wallx, wally + 125, 30, height); 

    wallx = wallx - 7;
    
    if (wallx < 0) {
      wallx = width;
      wally = random(200, 800);
    }
  }
  void newWall() {

  }
}

void keyPressed() {
  if (keyPressed && key == ' ') {
    b.up();
  }
}

void mousePressed() {
  if (mousePressed && mouseButton == LEFT) {
    b.up();
  }
}