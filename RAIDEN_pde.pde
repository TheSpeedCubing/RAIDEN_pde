//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//========================================================================================================================================================================================================                             
//                                                                                    ╔═══╦═══╦══╦═══╦═══╦═╗─╔╗
//                                                                                    ║╔═╗║╔═╗╠╣╠╩╗╔╗║╔══╣║╚╗║║
//                                                                                    ║╚═╝║║─║║║║─║║║║╚══╣╔╗╚╝║
//                                                                                    ║╔╗╔╣╚═╝║║║─║║║║╔══╣║╚╗║║
//                                                                                    ║║║╚╣╔═╗╠╣╠╦╝╚╝║╚══╣║─║║║
//                                                                                    ╚╝╚═╩╝─╚╩══╩═══╩═══╩╝─╚═╝                                                                    processing game project
//========================================================================================================================================================================================================
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//========================================================================================================================================================================================================
//Global Variables
//========================================================================================================================================================================================================
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


import processing.sound.*;

//player sprite
PImage img_player_full_HP;
PImage img_player_slight_damage;
PImage img_player_damaged;
PImage img_player_very_damaged;
PImage img_engine;
PImage img_guns;
PImage back;

//enemy
PImage img_enemy;

//animations
Animation engine;
Animation bullet;
Animation guns;
Animation bullet_e;
Animation nuke_projectile;


//audio effects
SoundFile music;
SoundFile audio_shoot;
SoundFile audio_shoot_e; 
SoundFile audio_scatter_shot; 
SoundFile audio_death;
SoundFile audio_death_e; 
SoundFile audio_nuke; 
SoundFile audio_nuke_explosion; 
SoundFile audio_damage;

//font
PFont font;

//wave counter
int wave = 0;
int top_wave = 0;

//score
int score = 0;
int top_score = 0;

//stores all bullet objects
ArrayList<Bullet> bullet_data = new ArrayList<Bullet>();
ArrayList<Bullet> bullet_data_e = new ArrayList<Bullet>();
ArrayList<Nuke> nuke_data = new ArrayList<Nuke>();

//stores all enemy objects
ArrayList<Basic_Enemy> enemy_data = new ArrayList<Basic_Enemy>();
float multiplier = 1;

//events
int phase0 = 1, phase1 = 0, phase2 = 0, phase3 = 0, phase4 = 0;
int phase1_in = 1, phase2_in = 1, phase1_flag = 0;

//not in use, event time maneger, phase4 to phase0 cd, phase1 to phase2 time, player invuln timer,
float FPS = 30, frame_time = 0;
float[] time_manager = {0, 0, 0, 0, 0, 0};

//w, a, s, d, space
boolean[] keys_pressed = {false, false, false, false, false, false};


Player player = new Player(0, 0, 10, 10, 10, 0);


//x top, y top, x bottom, y bottom
int[] barrier = {0, 0, 0, 0};
int[] barrier_e = {0, 0, 0, 0};

float x = 0;
float v = 0;
float y = 1;
float speed = 1;


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//========================================================================================================================================================================================================
//Main function
//========================================================================================================================================================================================================
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


//setup 
void setup(){
  img_player_full_HP = loadImage("1.png");
  img_player_slight_damage = loadImage("2.png");
  img_player_damaged = loadImage("3.png");
  img_player_very_damaged = loadImage("4.png");
  img_engine = loadImage("5.png");
  img_guns = loadImage("6.png");
  back = loadImage("7.png");
  
  img_enemy = loadImage("enemy.png");

  engine = new Animation("engine", 4, 75, 75);
  bullet = new Animation("bullet", 4, 40, 40);
  guns = new Animation("guns", 7, 80, 80);
  bullet_e = new Animation("bullet_e", 10, 60, 60);
  nuke_projectile = new Animation("nuke", 16, 40, 40);
  
  music = new SoundFile(this, "music.wav");
  audio_shoot = new SoundFile(this, "shoot.aiff");
  audio_shoot_e = new SoundFile(this, "shoot_e.wav");
  audio_scatter_shot = new SoundFile(this, "scatter_shot.wav");
  audio_death = new SoundFile(this, "death.wav");
  audio_death_e = new SoundFile(this, "death_e.wav");
  audio_nuke = new SoundFile(this, "nuke.wav");
  audio_nuke_explosion = new SoundFile(this, "nuke_explosion.mp3");
  audio_damage = new SoundFile(this, "damage.wav");
  
  font = createFont("big-shot.ttf", 40);
  textFont(font);
  textSize(50);

  size(600, 800);
  
  barrier[0] = 20;
  barrier[2] = width-20;
  barrier[3] = height-20;
  barrier_e[0] = 50;
  barrier_e[2] = width-50;
  barrier_e[3] = height/5*4;
  barrier_e[1] = 20;
  player.x_cord = width/2;
  player.y_cord = height*3/4;
  
  noStroke();
  colorMode(HSB, 70);
}


void draw(){
  trigger_event();
  update();
  manage_player();
  if(millis() - frame_time > 1000/FPS){
    render();
    frame_time = millis();
  }
}




//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//========================================================================================================================================================================================================
//Other Functions
//========================================================================================================================================================================================================
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


//deals with events
void trigger_event(){
  if(phase0 == 1){
    if(millis() - time_manager[2] > 1000){
      for(int i = 0; i < 5; i++){
        if(keys_pressed[i] == true){
          phase0 = 0;
          phase1 = 1;
          break;
        }
      }
    }
  }
  //phase 1
  if(phase1 == 1){
    if(phase1_in == 1){
      wave++;
      for(int i = 0; i < wave*2; i++){
        enemy_data.add(new Basic_Enemy(int(random(0, width)), 0, 10, 2, 1, 0, 4, 0, 0, 0));
      }
      phase1_in = 0;
    }
    phase1_flag = 1;
    for(int i = 0; i < enemy_data.size(); i++){
      if(enemy_data.get(i).get_health() > 0){
        phase1_flag = 0;
      }
    }
    if(phase1_flag == 1){
      time_manager[3] = millis();  
      multiplier += 0.5;
      enemy_data.clear();
      phase1_in = 1;
      phase2 = 1;
      phase1 = 0;
    }
  }
  else if(phase2 == 1){
    if(millis() - time_manager[3] > 2000){
      phase2 = 0;
      phase1 = 1;
    }
  }
  else if(phase4 == 1){
      for(int i = 0; i < 5; i++){
        if(keys_pressed[i] == true){
          phase4 = 0;
          phase0 = 1;   
          score = 0;
          wave = 0;
          time_manager[2] = millis();
          break;
        }
      }
  }
}


//runs every time draw() runs
void update(){
  if(music.isPlaying() == false){
    music.play();
  }
  if(phase1 == 1 || phase2 == 1){
    if(player.health <= 0){
      audio_death.play();
      reset();
    }
    player.check();
    if(millis() - player.get_last_charge_time() > player.get_nuke_recharge() && player.get_charges() < 4){
      player.charges++;  
      player.last_charge_time = millis();
    }
    
    for(int i = 0; i < bullet_data.size(); i++){
        bullet_data.get(i).move();
    }
    for(int i = 0; i < bullet_data_e.size(); i++){
        bullet_data_e.get(i).move();
    }
    for(int i = 0; i < nuke_data.size(); i++){
        nuke_data.get(i).move();  
    }
    
    for(int i = 0; i < enemy_data.size(); i++){
      if(enemy_data.get(i).get_health() > 0){
        if(random(0, 10) < 0.05*(1+wave/100)){
          enemy_data.get(i).shoot();
          audio_shoot_e.play();
        }
        if(wave > 10 && random(0, 10) < 0.003*(1+wave/100)){
          enemy_data.get(i).scatter_shot();  
          audio_scatter_shot.play();
        }
        if(millis() - enemy_data.get(i).get_move_cd() > 800 ){
           enemy_data.get(i).moving = int(random(1,9));
           enemy_data.get(i).move_cd = millis();
        }
        if(enemy_data.get(i).get_moving() > 0){
          enemy_data.get(i).move(enemy_data.get(i).get_moving());
          enemy_data.get(i).check_bullet();
        }
      }
      else{
        if(enemy_data.get(i).get_killed() == 0){
            enemy_data.get(i).killed = 1;
            enemy_data.get(i).time_of_death = millis();
            score += 20;
        }
      }
    }
  }
}


//deals with input and player interactions
void manage_player(){
  player.move(get_direction()); 
  if(keys_pressed[4] == true){
    player.shoot();  
  }
  if(keys_pressed[5] == true){
    player.nuke(); 
  }
}


//deals with graphics 
void render(){
  background(0);
  y+=speed;
  y%=height*2;
  image(back, 0, int(y));
  image(back.get(0, back.height-int(y), back.width, int(y)), 0, 0);
  
  
  //start screen
  if(phase0 == 1){
    text("PRESS TO START", 78, 100);
    text("TOP SCORE:", width/2 - 155, height/2 - 175);
    text(str(top_score), width/2 - 155, height/2 - 100);
    text("MOVE: W,A,S,D", width/2 - 155, height/2 + 100);
    text("FIRE: SPACE", width/2 - 155, height/2 + 175);
    text("NUKE: X", width/2 - 155, height/2 +250);
  }
  
  //ingame
  else if(phase1 == 1 || phase2 == 1 || phase3 == 1){
    //player sprite
    image(img_engine, player.get_x_cord()-40, player.get_y_cord()-30, 80, 80);
    engine.display(player.get_x_cord()-37.7, player.get_y_cord()-27);
    if(player.get_firing() == true){
      guns.display(player.get_x_cord()-40, player.get_y_cord()-50);
      if(audio_shoot.isPlaying() == false){
        audio_shoot.play();  
      }
    }
    else{
      image(img_guns, player.get_x_cord()-40, player.get_y_cord()-50, 80, 80);
    }
    if(player.get_health() > 7){
      image(img_player_full_HP, player.get_x_cord()-40, player.get_y_cord()-40, 80, 80);
    }
    else if(player.get_health() > 4){
      image(img_player_slight_damage, player.get_x_cord()-40, player.get_y_cord()-40, 80, 80);
    }
    else if(player.get_health() > 1){
      image(img_player_damaged, player.get_x_cord()-40, player.get_y_cord()-40, 80, 80);
    }
    else{
      image(img_player_very_damaged, player.get_x_cord()-40, player.get_y_cord()-40, 80, 80);
    }
    
    
    //bullets
    for(int i = 0; i < bullet_data.size(); i++){  
        bullet.display(bullet_data.get(i).get_x_cord()-20, bullet_data.get(i).get_y_cord()-20); 
    }
    for(int i = 0; i < bullet_data_e.size(); i++){
        bullet_e.display(bullet_data_e.get(i).get_x_cord()-30, bullet_data_e.get(i).get_y_cord()-30);
    }
    for(int i = 0; i <nuke_data.size(); i++){
        if(nuke_data.get(i).get_flag() == 0){
            nuke_projectile.display(nuke_data.get(i).get_x_cord()-30, nuke_data.get(i).get_y_cord()-30);
            if(audio_nuke.isPlaying() == false && nuke_data.get(i).get_is_pellet() == false){
              audio_nuke.play();  
            }
        }
        else if(nuke_data.get(i).get_flag() == 1){
            nuke_data.get(i).get_explosion().display(nuke_data.get(i).get_x_cord() - nuke_data.get(i).get_explosion().x/2, nuke_data.get(i).get_y_cord() - nuke_data.get(i).get_explosion().y/2);
            if(nuke_data.get(i).get_is_pellet() == false){
              audio_nuke_explosion.play();
            }
        }  
    }
    
    //enemies
    for(int i = 0; i < enemy_data.size(); i++){
      if(enemy_data.get(i).get_health() > 0){
        image(img_enemy, enemy_data.get(i).get_x_cord()-60, enemy_data.get(i).get_y_cord()-60, 120, 120);
      }  
      else if(millis() - enemy_data.get(i).get_time_of_death() < 300){
        enemy_data.get(i).get_death().display(enemy_data.get(i).get_x_cord()-60, enemy_data.get(i).get_y_cord()-60);
      }
      else{
        enemy_data.get(i).destroy();  
      }
    }
    
    
    //UI
    v = x;
    fill(0,0,100);
    textSize(30);
    text("HP", 20, 50);
    text("SCORE:", width - 150, 50);
    text(str(score), width - 150, 90);
    text("WAVE:", width/2 - 50, 50);
    text(str(wave), width/2 - 50, 90);
    text("NUKES:", 20, height - 20);
    text(str(player.get_charges()), 135, height - 20);
    
    fill(player.get_health() * 3 - x * 0.5, 100 ,100);
    rect(65, 30, player.get_health() * 10 - x, 20);
    
    
    textSize(50);
  }
  
  //game over 
  else if(phase4 == 1){
    text("SCORE:", width/2 - 100, height/2 - 175);
    text(str(score), width/2 - 100, height/2 - 100);
    text("WAVE:", width/2 - 100, height/2 + 50);
    text(str(wave), width/2 - 100, height/2 + 125);
  }
}


//resets game
void reset(){
 player.x_cord = width/2;
 player.y_cord = height*3/4;
 player.health = 10;
 player.charges = 0;
 player.last_time_fired = 0;
 player.last_time_nuke = 0;
 player.last_charge_time = 0;
 
 
 bullet_data.clear();
 bullet_data_e.clear();
 enemy_data.clear();
 nuke_data.clear();
 
 for(int i = 0; i < 5; i ++){
   time_manager[i] = 0;
 }  
 phase0 = 0;
 phase1 = 0;
 phase2 = 0; 
 phase3 = 0;
 phase4 = 1;
 phase1_in = 1; 
 time_manager[2] = millis();
 fill(0,0,100);
 if(score > top_score){
   top_score = score;  
 }
 if(wave > top_wave){
   top_wave = wave;  
 }
}

//gets direction player is moving
int get_direction(){
  int direction = 0;
  if(keys_pressed[0] == true && keys_pressed[1] == false && keys_pressed[2] == false && keys_pressed[3] == false){
    direction = 1;
  }
  if(keys_pressed[0] == true && keys_pressed[1] == true && keys_pressed[2] == false && keys_pressed[3] == false){
    direction = 2;
  }
  if(keys_pressed[0] == false && keys_pressed[1] == true && keys_pressed[2] == false && keys_pressed[3] == false){
    direction = 3;
  }
  if(keys_pressed[0] == false && keys_pressed[1] == true && keys_pressed[2] == true && keys_pressed[3] == false){
    direction = 4;
  }
  if(keys_pressed[0] == false && keys_pressed[1] == false && keys_pressed[2] == true && keys_pressed[3] == false){
    direction = 5;
  }
  if(keys_pressed[0] == false && keys_pressed[1] == false && keys_pressed[2] == true && keys_pressed[3] == true){
    direction = 6;
  }
  if(keys_pressed[0] == false && keys_pressed[1] == false && keys_pressed[2] == false && keys_pressed[3] == true){
    direction = 7;
  }
  if(keys_pressed[0] == true && keys_pressed[1] == false && keys_pressed[2] == false && keys_pressed[3] == true){
    direction = 8;
  }
  return(direction);
}




//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//========================================================================================================================================================================================================
//Input Management
//========================================================================================================================================================================================================
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


void keyPressed(){
  switch(key){
    case 'w':
      keys_pressed[0] = true;
      break;
    case 'a':
      keys_pressed[3] = true;
      break;
    case 's':
      keys_pressed[2] = true;
      break;
    case 'd':
      keys_pressed[1] = true;
      break;
    case ' ':
      keys_pressed[4] = true;
      player.firing = true;
      break;
    case 'x':
      keys_pressed[5] = true;
      break;
  }
}
void keyReleased(){
  switch(key){
    case 'w':
      keys_pressed[0] = false;
      break;
    case 'a':
      keys_pressed[3] = false;
      break;
    case 's':
      keys_pressed[2] = false;
      break;
    case 'd':
      keys_pressed[1] = false;
      break;
    case ' ':
      keys_pressed[4] = false;
      player.firing = false;
      break;
    case 'x':
      keys_pressed[5] = false;
      break;
  }
}




//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//========================================================================================================================================================================================================
//Classes
//========================================================================================================================================================================================================
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


//basic object class
class object {
 int x_cord;
 int y_cord;
 int health;
 float move_speed;
 object(int num1, int num2, int num3, float num4){
   x_cord = num1;
   y_cord = num2;
   health = num3;
   move_speed = num4;
 }
 int get_x_cord(){
   return(x_cord);
 }
 int get_y_cord(){
   return(y_cord);
 }
 int get_health(){
   return(health);
 }
 float get_move_speed(){
   return(move_speed); 
 } 
  
}



//player class
class Player extends object{
 int fire_rate;
 float last_time_fired;
 float last_time_nuke = 0;
 boolean firing = false;
 int charges = 0;
 float nuke_recharge = 10000;
 float last_charge_time = 0;
 Player(int num1, int num2, int num3, float num4, int num5, float num6){
   super(num1, num2, num3, num4);
   fire_rate = num5;
   last_time_fired = num6;
 }
 int get_fire_rate(){
   return(fire_rate); 
 }
 float get_last_time_fired(){
   return(last_time_fired);  
 }
 boolean get_firing(){
   return(firing);  
 }
 int get_charges(){
    return(charges); 
 }
 float get_nuke_recharge(){
   return(nuke_recharge);  
 }
 float get_last_charge_time(){
   return(last_charge_time);  
 }
 
 //eight directional movement
 void move(int direction){
  float angle_move_amount = move_speed/sqrt(2);
  switch (direction){
    case 1:
      y_cord -= move_speed;
      break;
    case 2:
      y_cord -= angle_move_amount;
      x_cord += angle_move_amount;
      break;
    case 3:
      x_cord += move_speed;
      break;
    case 4:
      y_cord += angle_move_amount;
      x_cord += angle_move_amount;
      break;
    case 5:
      y_cord += move_speed;
      break;
    case 6:
      y_cord += angle_move_amount;
      x_cord -= angle_move_amount;
      break;
    case 7:
      x_cord -= move_speed;
      break;
    case 8:
      y_cord -= angle_move_amount;
      x_cord -= angle_move_amount;
      break;
  }
  //barrier check
  if(x_cord >= barrier[2])
    x_cord = barrier[2];
  if(x_cord <= barrier[0])
    x_cord = barrier[0];
  if(y_cord >= barrier[3])
    y_cord = barrier[3];
  if(y_cord <= barrier[1])
    y_cord = barrier[1];
 }
 
 //basic firing sequence
 void shoot(){
    if(millis() - last_time_fired > 1000/fire_rate){                                                
      bullet_data.add(new Bullet(player.get_x_cord()-15, player.get_y_cord()-30, 10, 20, PI/2));
      bullet_data.add(new Bullet(player.get_x_cord()+15, player.get_y_cord()-30, 10, 20, PI/2));
      last_time_fired = millis();
    }
 }
 
 //nuke
 void nuke(){
   if(charges > 0 && millis() - last_time_nuke > 1000){       
      nuke_data.add(new Nuke(player.get_x_cord(), player.get_y_cord()-30, 10, 3, PI/2, millis(), 1500, false, 250));
      charges--;
      last_time_nuke = millis();
    }
 }
  
 void check(){
    for(int i = 0; i < enemy_data.size(); i++){
      if(abs(enemy_data.get(i).get_x_cord() - x_cord) < 30 && abs(enemy_data.get(i).get_y_cord() - y_cord) < 30 && enemy_data.get(i).get_health() > 0 && millis() - time_manager[4] > 300){
        audio_damage.play();
        health -= 2;  
        time_manager[4] = millis();
      }
    }
    for(int i = 0; i < bullet_data_e.size(); i++){
      if(abs(bullet_data_e.get(i).get_x_cord() - x_cord) < 30 && abs(bullet_data_e.get(i).get_y_cord() - y_cord) < 30 && bullet_data_e.get(i).get_health() > 0 && millis() - time_manager[4] > 300){
        bullet_data_e.get(i).destroy();
        audio_damage.play();
        health -= 2;  
        time_manager[4] = millis();
      }
    }
  }
}


//bullet class
class Bullet extends object{
  float direction = 0;
  Bullet(int num1, int num2, int num3, int num4, float num5){
    super(num1, num2, num3, num4);
    direction = num5;
  }
  float get_direction(){
    return(direction);
  }
  void move(){
    //calculate x and y vectors
    float vector_y = (-1)*move_speed*sin(direction);
    float vector_x = move_speed*cos(direction);
    x_cord += vector_x;
    y_cord += vector_y;
    if(x_cord >= width || x_cord <= 0 || y_cord >= height || y_cord <= 0){
      this.destroy();
    }
  } 
  void destroy(){
    bullet_data.remove(this);
  }
}


//nuke class
class Nuke extends Bullet{
  Animation explosion = new Animation("frame", 42, 400, 400);
  int flag = 0;
  float spawn_time;
  float expire_time;
  boolean is_pellet;
  int blast_radius;
  Nuke(int num1, int num2, int num3, int num4, float num5, float num6, float num7, boolean num8, int num9){
    super(num1, num2, num3, num4, num5);  
    spawn_time = num6;
    expire_time = num7;
    is_pellet = num8;
    blast_radius = num9;
  }
  int get_flag(){
    return(flag);  
  }
  float get_spawn_time(){
    return(spawn_time);  
  }
  float get_expire_time(){
    return(expire_time);
  }
  boolean get_is_pellet(){
    return(is_pellet);  
  }
  int get_blast_radius(){
    return(blast_radius);  
  }
  Animation get_explosion(){
    return(explosion); 
  }
  
  void detonate(){
    move_speed = 0;
    if(flag == 0){
      for(int i = 0; i < bullet_data_e.size(); i++){
        if(dist(x_cord, y_cord, bullet_data_e.get(i).get_x_cord(), bullet_data_e.get(i).get_y_cord()) < blast_radius){
          bullet_data_e.get(i).destroy(); 
        }
      }
      for(int i = 0; i < enemy_data.size(); i++){
        if(dist(x_cord, y_cord, enemy_data.get(i).get_x_cord(), enemy_data.get(i).get_y_cord()) < blast_radius){
          enemy_data.get(i).health -= 8; 
        }
      }
      for(int i = 0; i < 5; i++){
        if(is_pellet == false || random(0,10) < 0.5){
          nuke_data.add(new Nuke(x_cord, y_cord, 10, int(random(3, 8)), 2*PI*i/5, millis(), 500, true, 175));  
        }
      }
      if(is_pellet == true){
        explosion.x = 250;
        explosion.y = 250;
      }
      flag = 1;
    }
    if(flag == 1){
      if(millis() - (spawn_time + expire_time) > 42/FPS*1000){
        this.destroy();
      } 
    }
  }
  @Override
  void move(){
    //calculate x and y vectors
    float vector_y = (-1)*move_speed*sin(direction);
    float vector_x = move_speed*cos(direction);
    x_cord += vector_x;
    y_cord += vector_y;
    if(x_cord >= width || x_cord <= 0 || y_cord >= height || y_cord <= 0 || millis() - spawn_time > expire_time){
      this.detonate();
    }
  }
  @Override
  void destroy(){
    nuke_data.remove(this);
  }
}


//enemy_bullet_class
class Enemy_Bullet extends Bullet{
  float spawn_time;
  float expire_time;
   Enemy_Bullet(int num1, int num2, int num3, int num4, float num5, float num6, float num7){
    super(num1, num2, num3, num4, num5);
    spawn_time = num6;
    expire_time = num7;
  }
  float get_spawn_time(){
    return(spawn_time);
  }
  float get_expire_time(){
    return(expire_time); 
  }
  @Override
  void destroy(){
    bullet_data_e.remove(this);  
  }
}


//basic enemy class
class Basic_Enemy extends Player{
  int moving;
  int killed;
  float time_of_death;
  float move_cd;
  Animation death = new Animation("death", 9, 120, 120);
  
  Basic_Enemy(int num1, int num2, int num3, float num4, int num5, float num6, int num7, int num8, float num9, float num10){
    super(num1, num2, num3, num4, num5, num6);
    moving = num7;
    killed = num8;
    time_of_death = num9;
    move_cd = num10;
  }
  int get_moving(){
    return(moving);  
  }
  int get_killed(){
    return(killed);  
  }    
  float get_time_of_death(){
    return(time_of_death);  
  }
  float get_move_cd(){
    return(move_cd);  
  }
  Animation get_death(){
    return(death); 
  }
  
  //shoots in players direction
  @Override
  void shoot(){
    PVector v2 = new PVector(player.get_x_cord() - x_cord, -(player.get_y_cord() - y_cord));
    float angle = v2.heading();
    //println(degrees(angle));
    if(millis() - last_time_fired > 1000/fire_rate){                                                
      bullet_data_e.add(new Enemy_Bullet(x_cord, y_cord, 10, 3, angle, millis(), 4000));
      last_time_fired = millis();
    }      
  }
  
  void scatter_shot(){
    if(millis() - last_time_fired > 1000/fire_rate){      
      for(int i = 0; i < 20; i++){
        bullet_data_e.add(new Enemy_Bullet(x_cord, y_cord, 10, 15, TWO_PI/20*i, millis(), 4000));
        last_time_fired = millis();
      }
      
    }      
  }
  
  void check_bullet(){
    for(int i = 0; i < bullet_data.size(); i++){
      if(abs(bullet_data.get(i).get_x_cord() - x_cord) < 30 && abs(bullet_data.get(i).get_y_cord() - y_cord) < 30 && bullet_data.get(i).get_health() > 0){
        health -= 2;  
        bullet_data.get(i).destroy();
      }
    }
  }
  
  void destroy(){
    audio_death_e.play();
    enemy_data.remove(this);  
  }
  
  @Override
  void move(int direction){
    float angle_move_amount = move_speed/sqrt(2);
    switch (direction){
      case 1:
        y_cord -= move_speed;
        break;
      case 2:
        y_cord -= angle_move_amount;
        x_cord += angle_move_amount;
        break;
      case 3:
        x_cord += move_speed;
        break;
      case 4:
        y_cord += angle_move_amount;
        x_cord += angle_move_amount;
        break;
      case 5:
        y_cord += move_speed;
        break;
      case 6:
        y_cord += angle_move_amount;
        x_cord -= angle_move_amount;
        break;
      case 7:
        x_cord -= move_speed;
        break;
      case 8:
        y_cord -= angle_move_amount;
        x_cord -= angle_move_amount;
        break;
    }
    //barrier check
    if(x_cord >= barrier_e[2])
      x_cord = barrier_e[2];
    if(x_cord <= barrier_e[0])
      x_cord = barrier_e[0];
    if(y_cord >= barrier_e[3])
      y_cord = barrier_e[3];
    if(y_cord <= barrier_e[1])
      y_cord = barrier_e[1];
   }
}


//animation
// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  int x, y;
  
  Animation(String imagePrefix, int count, int num1, int num2) {
    imageCount = count;
    images = new PImage[imageCount];
    x = num1;
    y = num2;

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".png";
      images[i] = loadImage(filename);
    }
  }

  void reset(){
    frame = 0;  
  }
  
  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, x, y);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
