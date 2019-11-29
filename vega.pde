static final int SCREEN_SIZE_X = 1200, SCREEN_SIZE_Y = 800;
final int BOT_SIZE = 50, BULLET_SIZE = 4;
int scoreLeftTeam=0, scoreRightTeam=0;
ArrayList<HD_Bot> leftTeam = new ArrayList<HD_Bot>();
ArrayList<HD_Bot> rightTeam = new ArrayList<HD_Bot>();
ArrayList<HD_Bullet> bullets = new ArrayList<HD_Bullet>();
boolean isPlaying = true;
 
void setup() {
  size(1200, 800);
 
  leftTeam.add(new HD_Bot(0));
  rightTeam.add(new HD_Bot(1));
}
 
void draw() {
  background(200, 200, 200);
 
  // Render bullets
  renderBullets();
 
  // Render left team
  for (HD_Bot bot : leftTeam) {
    bot.step();
    bot.update();
  }
 
  // Render right team
  for (HD_Bot bot : rightTeam) {
    bot.step();
    bot.update();
  }
 
  checkHits();
  // println("score: ", scoreLeftTeam, " - " , scoreRightTeam);
  updateHUD();
}
 
void mousePressed() {
 
    for (HD_Bot bot : leftTeam) {
      bot.speed_vel = random(1);
      bot.speed_ang = 0.01 - random(0.02);
      bot.shoot();
    }
 
    // Render right team
    for (HD_Bot bot : rightTeam) {
      bot.speed_vel = random(1);
      bot.speed_ang = 0.01 - random(0.02);      
      bot.shoot();
    }
 
}
 
 
void updateHUD() {
  line(600, 0, 600, 800);

  text(scoreLeftTeam, 580, 20);
  text(scoreRightTeam, 620, 20);
}
 
void renderBullets() {
 
  ArrayList<HD_Bullet> bulletToRemove = new ArrayList<HD_Bullet>();
 
  for (HD_Bullet b: bullets) {
    b.step();
    if(b.isOutOfScreen()) {
      bulletToRemove.add(b);
    } else {
      b.update();
    }
  }
 
  // Remove out of screen bullets
  for(HD_Bullet b: bulletToRemove) {
    bullets.remove(b);
  }
}
 
void checkHits() {
  ArrayList<HD_Bullet> bulletToRemove = new ArrayList<HD_Bullet>();
 
  for(HD_Bullet bullet: bullets) {
    boolean didHit = false;
    for(HD_Bot bot: (bullet.team == 0) ? rightTeam : leftTeam ) {
      didHit = sqrt(pow(bullet.pos_x - bot.pos_x ,2) + pow(bullet.pos_y - bot.pos_y,2)) < (BOT_SIZE + BULLET_SIZE) / 2;
      if(didHit) {
        // HIT !
        bulletToRemove.add(bullet);
        if(bullet.team == 0) {
          scoreLeftTeam++;
        } else {
          scoreRightTeam++;
        }
        break;
      }
    }
  }
 
  // Remove successful bullets
  for(HD_Bullet b: bulletToRemove) {
    bullets.remove(b);
  }
}
 
 
/*
  HD_Bot
*/
class HD_Bot {
  int team = 0;
  float pos_x, pos_y;
  float angle = 0;
  float speed_vel = 1, speed_ang = 0.005;
  boolean bCollide = false;
 
 
  HD_Bot (int t) {
    team = t;
   
    pos_y = SCREEN_SIZE_Y / 2;
    if(team == 0) {
      pos_x = SCREEN_SIZE_X / 4;
    } else if(team == 1) {
      pos_x = 3 * (SCREEN_SIZE_X / 4);
    } else {
      pos_x = SCREEN_SIZE_Y / 2;
    }
     
  }
 
  void update() {
    pushMatrix();
    translate(pos_x, pos_y);
    rotate(angle);
   
    // Draw ray
    stroke(0,0,255);
    line(0,0, 5000, 0);
    stroke(0);
   
    // Draw canon
    fill(0);
    rect((BOT_SIZE/2 - 10), -5, 20, 10);
    popMatrix();
   
   
    if(team == 0) { fill(255,0,0); }
    else if(team == 1) { fill(0, 255, 255); }
    else { fill(255); }
   
    ellipse(pos_x, pos_y, BOT_SIZE, BOT_SIZE);
  }
 
  void step() {
    float tmp_x = pos_x, tmp_y = pos_y;
    angle += speed_ang;
    pos_x += speed_vel * cos(angle);
    pos_y += speed_vel * sin(angle);
   
    bCollide = isColliding();
    if(bCollide) {
      pos_x = tmp_x;
      pos_y = tmp_y;
    }
  }
 
  boolean isColliding() {
    float ref_width = SCREEN_SIZE_X / 2;
    float ref_height = SCREEN_SIZE_Y;
    float ref_x = (team == 0) ? 0 : ref_width;
    float ref_y = 0;
    if((pos_x-ref_x < (BOT_SIZE/2)) || (pos_x-ref_x > ref_width-(BOT_SIZE/2))) {
      return true;
    }
   
    if((pos_y-ref_y < (BOT_SIZE/2)) || (pos_y-ref_y > ref_height-(BOT_SIZE/2))) {
      return true;
    }
   
    return false;
  }
 
  void shoot() {
    bullets.add(new HD_Bullet(pos_x, pos_y, angle, team));
  }
}
 
 
/*
  HD_Bullet
*/
class HD_Bullet {
  static final float speed = 5;
 
  int team;
  float pos_x = 0, pos_y = 0;
  float angle = 0;
 
  HD_Bullet(float x, float y, float angle, int team) {
    this.pos_x = x;
    this.pos_y = y;
    this.angle = angle;
    this.team = team;
  }
 
  void step() {
    pos_x += speed * cos(angle);
    pos_y += speed * sin(angle);
  }
 
  void update() {
    if(team == 0) { fill(255,0,0); }
    else if(team == 1) { fill(0, 255, 255); }
    else { fill(255); }
    ellipse(pos_x, pos_y, BULLET_SIZE, BULLET_SIZE);
  }
 
  boolean isOutOfScreen() {
    if((pos_x+2 < 0) || (pos_x-2 > SCREEN_SIZE_X)) {
      return true;
    }
   
    if((pos_y+2 < 0) || (pos_y-2 > SCREEN_SIZE_Y)) {
      return true;
    }
   
    return false;
  }
}
