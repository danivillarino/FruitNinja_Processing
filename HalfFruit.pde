class HalfFruit{

  float x,y;
  float vx;
  float vy;

  PImage img;

  HalfFruit(float x,float y,float vx,PImage img){

    this.x = x;
    this.y = y;
    this.vx = vx;
    this.img = img;

    vy = random(-14,-10);
  }

  void update(){

    float factor = 60.0 / max(frameRate,1);

    x += vx * factor;
    y += vy * factor;

    vy += 0.35 * factor;
  }

  void display(){

    float maxSize = 175;
    float scale = maxSize / max(img.width, img.height);

    image(img, x, y, img.width*scale, img.height*scale);
  }
}
