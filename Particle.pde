class Particle{

  float x,y;
  float vx,vy;
  float life;

  color c;

  Particle(float x,float y,color c){

    this.x = x;
    this.y = y;
    this.c = c;

    vx = random(-3,3);
    vy = random(-3,3);

    life = 255;
  }

  void update(){

    x += vx;
    y += vy;

    life -= 5;
  }

  void display(){

    noStroke();

    //color con ligera variación (más realista)
    fill(
      red(c) + random(-20,20),
      green(c) + random(-20,20),
      blue(c) + random(-20,20),
      life
    );

    ellipse(x,y,6,6);
  }
}
