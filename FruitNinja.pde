import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;
ArrayList<SkeletonData> bodies;

//objetos del juego
ArrayList<Fruit> fruits = new ArrayList<Fruit>();
ArrayList<HalfFruit> halves = new ArrayList<HalfFruit>();
ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<PVector> trail = new ArrayList<PVector>();

String state = "menu";

int score = 0;
int missed = 0;

//mano
float handX, handY;
float targetX, targetY;
float prevHandX, prevHandY;

//imágenes frutas
PImage[] fruitImgs;
PImage[] fruitLeft;
PImage[] fruitRight;

//UI
PImage startButton;
PImage restartButton;
PImage logo;
PImage gameOverImg;

//fondos
PImage fondoMenu;
PImage fondoJuego;

float startTimer = 0;
float restartTimer = 0;

// --- Spawn sistema ---
float spawnTimer = 0;
float spawnInterval = 0.8;

void setup(){

  fullScreen();
  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER);

  //Kinect
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData>();

  //FRUTAS
  fruitImgs = new PImage[]{
    loadImage("manzana.png"),
    loadImage("mango.png"),
    loadImage("sandia.png"),
    loadImage("pera.png"),
    loadImage("naranja.png"),
    loadImage("pina.png")
  };

  fruitLeft = new PImage[]{
    loadImage("manzana_left.png"),
    loadImage("mango_left.png"),
    loadImage("sandia_left.png"),
    loadImage("pera_left.png"),
    loadImage("naranja_left.png"),
    loadImage("pina_left.png")
  };

  fruitRight = new PImage[]{
    loadImage("manzana_right.png"),
    loadImage("mango_right.png"),
    loadImage("sandia_right.png"),
    loadImage("pera_right.png"),
    loadImage("naranja_right.png"),
    loadImage("pina_right.png")
  };

  //UI
  startButton = loadImage("start.png");
  restartButton = loadImage("restart.png");
  logo = loadImage("logo.png");
  gameOverImg = loadImage("gameover.png");

  //fondos
  fondoMenu = loadImage("fondomenu.jpg");
  fondoJuego = loadImage("fondojuego.jpg");
}

void draw(){

  updateHand();

  if(state.equals("menu")){
    drawMenu();
  }
  else if(state.equals("game")){
    runGame();
  }
  else if(state.equals("gameover")){
    drawGameOver();
  }

  prevHandX = handX;
  prevHandY = handY;
}

void updateHand(){

  if(bodies.size() > 0){

    SkeletonData s = bodies.get(0);

    if(s.skeletonPositionTrackingState[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT] 
       != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED){

      targetX = s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x * width;
      targetY = s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y * height;

      //suavizado
      handX = lerp(handX,targetX,0.25);
      handY = lerp(handY,targetY,0.25);
    }
  }
}

void drawMenu(){

  image(fondoMenu, width/2, height/2, width, height);


  image(logo,width/2,height*0.3,500,250);
  image(startButton,width/2,height*0.65,300,150);

  fill(255);
  textSize(40);
  text("Posiciona tu mano encima del botón de START",width/2,height*0.85);

  if(dist(handX,handY,width/2,height*0.65) < 120){

    startTimer += 1.0/frameRate;

    fill(0,255,0);
    text("Iniciando...",width/2,height*0.75);

    if(startTimer >= 2){
      startGame();
      startTimer = 0;
    }

  } else {
    startTimer = 0;
  }

  drawSword();
}

void drawGameOver(){

  image(fondoJuego, width/2, height/2, width, height);

  image(gameOverImg,width/2,height*0.3,500,250);
  
  float maxSize = 300;
  float scale = maxSize / max(restartButton.width, restartButton.height);
  float w = restartButton.width * scale;
  float h = restartButton.height * scale;
  
  image(restartButton, width/2, height*0.65, w, h);

  fill(255);
  textSize(40);
  text("Score: "+score,width/2,height*0.5);

  if(dist(handX,handY,width/2,height*0.65) < 120){
  
    restartTimer += 1.0/frameRate;
  
    float cx = width/2;
    float cy = height*0.65;
    float radius = 100;
  
    float progress = map(restartTimer, 0, 3, 0, TWO_PI);
  
    noFill();
  
    //círculo base
    stroke(200);
    strokeWeight(8);
    ellipse(cx, cy, radius*2, radius*2);
  
    //progreso
    stroke(0,255,0);
    strokeWeight(10);
    arc(cx, cy, radius*2, radius*2, -HALF_PI, -HALF_PI + progress);
  
    if(restartTimer >= 3){
      startGame();
      restartTimer = 0;
    }
  
  } else {
  
    restartTimer = 0;
  
  }

  drawSword();
}

void startGame(){

  fruits.clear();
  halves.clear();
  particles.clear();
  trail.clear();

  score = 0;
  missed = 0;

  state="game";
}

// --- Run Game ---
void runGame(){
  image(fondoJuego, width/2, height/2, width, height);
  drawSword();

  // Spawn frutas
  spawnTimer += 1.0 / max(frameRate,1);
  if(spawnTimer >= spawnInterval){
    spawnTimer = 0;
    int amount = int(random(1, 3));
    for(int i=0;i<amount;i++){
      float x = random(width*0.2, width*0.8);
      fruits.add(new Fruit(x, height-20));
    }
    spawnInterval = random(0.6,1.2);
  }

  // Update frutas
  for(int i=fruits.size()-1;i>=0;i--){
    Fruit f = fruits.get(i);
    f.update();
    f.display();
    if(checkSlice(f)){
      fruits.remove(i);
      score += (f.type==2)?2:1;
      halves.add(new HalfFruit(f.x,f.y,-4,fruitLeft[f.type]));
      halves.add(new HalfFruit(f.x,f.y,4,fruitRight[f.type]));
      for(int j=0;j<20;j++) particles.add(new Particle(f.x,f.y,f.fruitColor));
    }
    if(f.y>height+100){
      fruits.remove(i);
      missed++;
      if(missed>=15) state="gameover";
    }
  }

  // Update mitades
  for(int i=halves.size()-1;i>=0;i--){
    HalfFruit h = halves.get(i);
    h.update();
    h.display();
    if(h.y>height+100) halves.remove(i);
  }

  // Update partículas
  for(int i=particles.size()-1;i>=0;i--){
    Particle p = particles.get(i);
    p.update();
    p.display();
    if(p.life <= 0) particles.remove(i);
  }

  // UI
  fill(255);
  textAlign(LEFT);
  textSize(40);
  text("Score: "+score, 30,50);
  text("Missed: "+missed, 30,90);
}

void drawSword(){

  trail.add(new PVector(handX,handY));

  if(trail.size()>15){
    trail.remove(0);
  }

  stroke(255);
  strokeWeight(6);

  for(int i=1;i<trail.size();i++){

    PVector p1 = trail.get(i-1);
    PVector p2 = trail.get(i);

    line(p1.x,p1.y,p2.x,p2.y);
  }
}

boolean checkSlice(Fruit f){

  float speed = dist(handX,handY,prevHandX,prevHandY);

  if(speed < 10) return false;

  float d = dist(handX,handY,f.x,f.y);

  return d < 100;
}

//EVENTOS KINECT

void appearEvent(SkeletonData s){
  synchronized(bodies){
    bodies.add(s);
  }
}

void disappearEvent(SkeletonData s){
  synchronized(bodies){
    for(int i=bodies.size()-1;i>=0;i--){
      if(s.dwTrackingID == bodies.get(i).dwTrackingID){
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData before, SkeletonData after){
  synchronized(bodies){
    for(int i=bodies.size()-1;i>=0;i--){
      if(before.dwTrackingID == bodies.get(i).dwTrackingID){
        bodies.get(i).copy(after);
        break;
      }
    }
  }
}
