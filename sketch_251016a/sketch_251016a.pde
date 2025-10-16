import processing.sound.*;

String backgroundText;
float textX = 0;
float textWidth;

AudioIn in;
Amplitude amp;
int clapCooldown;

box b = new box();
wall[] walls = new wall[3];
int startTime;
int screen = 0;
int gameOverTime;

void settings() {
  fullScreen();
}

void setup() {
  String[] lines = loadStrings("../memoriasdaterra_1.txt");
  backgroundText = join(lines, "");
  startTime = 3600;
  
  // Audio setup
  in = new AudioIn(this, 0);
  amp = new Amplitude(this);
  in.start();
  amp.input(in);
  
  resetGame();
}

void draw() {
  background(0);
  
  // Animate and draw the background text
  textSize(50);
  float scrollingTextWidth = width * 2; // Make it wrap
  fill(255, 50);
  
  text(backgroundText, textX, 0, scrollingTextWidth, height);
  text(backgroundText, textX + scrollingTextWidth, 0, scrollingTextWidth, height);
  
  textX -= 2; // Scrolling speed
  
  if (textX < -scrollingTextWidth) {
    textX = 0;
  }

  float volume = amp.analyze();
  float threshold = 0.1; // This may need tuning

  if (clapCooldown > 0) {
    clapCooldown--;
  }

  if (volume > threshold && clapCooldown == 0) {
    if (screen == 0) { // If in Ready state, start the game
      screen = 1;
      frameCount = 0; // Reset timer
    }
    b.up(); // Jump regardless of the state
    clapCooldown = 30; // Apply cooldown
  }

  if (screen == 0) { // Ready state
    b.createBox();
    fill(255);
    textSize(60);
   // text("Clap or Tap to start", width/3.5, height/2);
  } else if (screen == 1) { // Playing state
    int timer = (startTime - frameCount) / 60;
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
  } else if (screen == 3) { // Game Over state
    fill(255);
    textSize(60);
    text("GAME OVER", width / 2.7, height / 2.8);

    if (frameCount > gameOverTime + 120) { // Wait for 2 seconds (60fps * 2)
      resetGame();
    }
  }

  textSize(20);
  fill(255);
  text("x: "+(int)b.boxx+" y: "+(int)b.boxy, 10, 15);
}

void resetGame() {
  b.boxx = 500;
  b.boxy = 500;
  b.ySpeed = 0;
  for (int i = 0; i < walls.length; i++) {
    walls[i] = new wall();
    walls[i].wallx = width + i * 600;
  }
  frameCount = 0;
  screen = 0;
  textX = random(0, -width * 2);
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
      gameOverTime = frameCount;
    }
  }

  void checkCollision(wall w) {
    if (boxx + 35 > w.wallx && boxx < w.wallx + 30) {
      if (boxy < w.wally - 125 || boxy + 35 > w.wally + 125) {
        screen = 3;
        gameOverTime = frameCount;
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
  if (key == ' ') {
    if (screen == 0) {
      screen = 1;
      frameCount = 0; // Reset timer
    }
    b.up();
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    if (screen == 0) {
      screen = 1;
      frameCount = 0; // Reset timer
    }
    b.up();
  }
}
