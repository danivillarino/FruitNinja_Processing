class Fruit{

  float x,y;
  float vy;
  float vx;

  float size;
  int type;
  color fruitColor;

  Fruit(float x,float y){
    this.x = x;
    this.y = y;

    vy = random(-25,-20);
    vx = random(-1.5,1.5);

    size = 200;

    type = int(random(fruitImgs.length));
    
    switch(type){
      case 0: fruitColor = color(255,0,0); break;
      case 1: fruitColor = color(255,200,0); break;
      case 2: fruitColor = color(0,200,0); break;
      case 3: fruitColor = color(180,255,100); break;
      case 4: fruitColor = color(255,150,0); break;
      case 5: fruitColor = color(255,220,0); break;
    }
  }

  void update(){

    float factor = 60.0 / max(frameRate, 1);

    x += vx * factor;
    y += vy * factor;

    vy += 0.5 * factor;

    if(y < height * 0.25){
      vy = abs(vy);
    }
  }

  void display(){
  
    PImage img = fruitImgs[type];
  
    float maxSize = 350;
  
    float scale = maxSize / max(img.width, img.height);
  
    float w = img.width * scale;
    float h = img.height * scale;
  
    image(img, x, y, w, h);
  }
}
