abstract class GameObject {
  PVector posicion;
  PVector velocidad;
  PImage imagen;
  
  GameObject(float x, float y, float vx, float vy, PImage img) {
    posicion = new PVector(x, y);
    velocidad = new PVector(vx, vy);
    imagen = img;
  }
  
  abstract void display();
  abstract void mover();
}

// Shooter
class Shooter extends GameObject {
  int vidas;
  
  Shooter(float x, float y, float vx, float vy, PImage img, int v) {
    super(x, y, vx, vy, img);
    vidas = v;
  }
  
  void display() {
    image(imagen, posicion.x, posicion.y);
    // Dibujar HUD
    fill(255);
    textSize(20);
    text("Vidas: " + vidas, 20, 20);
  }
  
  void mover() {
    // Mover el Shooter con las teclas WASD
    if (keyPressed) {
      if (key == 'a' || key == 'A') {
        posicion.x -= 5;
      } else if (key == 'd' || key == 'D') {
        posicion.x += 5;
      } else if (key == 'w' || key == 'W') {
        posicion.y -= 5;
      } else if (key == 's' || key == 'S') {
        posicion.y += 5;
      }
    }
    
    // Mover del Shooter solamente dentro del lienzo pero que no pase de los bordes
    posicion.x = constrain(posicion.x, 0, width - imagen.width);
    posicion.y = constrain(posicion.y, 0, height - imagen.height);
  }
  
  void perderVida() {
    vidas--;
    if (vidas <= 0) {
      gameOver();
    }
  }
}

// Asteroide
class Asteroide extends GameObject {
  Asteroide(float x, float y, float vx, float vy, PImage img) {
    super(x, y, vx, vy, img);
  }
  
  void display() {
    image(imagen, posicion.x, posicion.y);
  }
  
  void mover() {
    // Que el asteroide caiga
    posicion.y += velocidad.y;
    
    // Reiniciar el asteroide arriba, cuando sale de la pantalla por abajo
    if (posicion.y > height) {
      posicion.y = -imagen.height;
      posicion.x = random(width - imagen.width);
    }
  }
}

// Almacenar objetos
ArrayList<GameObject> objetos;

// Definir Objeto Shooter
Shooter shooter;

// Todas las imagenes usadas
PImage fondoImg; // Variable del fondo, etc etc
PImage gameOverImg; 
PImage shooterImg;
PImage asteroideImg;

void setup() {
  size(800, 600);
  
  // se cargan las imágenes
  fondoImg = loadImage("fondo.png"); // Carga de la imagen de fondo, etc etc etc
  gameOverImg = loadImage("gameover.png"); 
  shooterImg = loadImage("shooter.png");
  asteroideImg = loadImage("asteroide.png");
  
  // Creacion de objetos del juego
  objetos = new ArrayList<GameObject>();
  
  shooter = new Shooter(width/2, height - 100, 0, 0, shooterImg, 3);
  objetos.add(shooter);
  
  for (int i = 0; i < 5; i++) {
    Asteroide asteroide = new Asteroide(random(width - asteroideImg.width), random(-height, 0), 0, random(1, 3), asteroideImg);
    objetos.add(asteroide);
  }
}

void draw() {
  // Dibujar el fondo con la imagen
  image(fondoImg, 0, 0, width, height);
  
  // Mostrar y mover los objetos del juego
  for (GameObject objeto : objetos) {
    objeto.display();
    objeto.mover();
    
    // Colision entre Shooter y Asteroide
    if (objeto instanceof Asteroide) {
      Asteroide asteroide = (Asteroide) objeto;
      if (shooter.posicion.dist(asteroide.posicion) < shooter.imagen.width / 2 + asteroide.imagen.width / 2) {
        
        // Restar una vida al Shooter si hace colision con Asteroide
        shooter.perderVida();
        // Eliminar el Asteroide
        objetos.remove(objeto);
        break; // Salir del bucle 
      }
    }
  }
}

// Terminar game
void gameOver() {
  // poner imagen de fondo para final de juego
  image(gameOverImg, 0, 0, width, height);
  noLoop(); // Frenar loops
}
 
