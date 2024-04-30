abstract class GameObject {
  PVector posicion;
  
  GameObject() {
    posicion = new PVector(0, 0);
  }
  
  GameObject(float x, float y) {
    posicion = new PVector(x, y);
  }
  
  abstract void display();
}

// Dado clase
class Dado extends GameObject {
  int valor;
  PImage[] caras;
  
  Dado() {
    valor = 1;
    caras = new PImage[6];
    for (int i = 0; i < 6; i++) {
      caras[i] = loadImage("cara_dado_" + (i+1) + ".png");
    }
  }
  
  Dado(float x, float y) {
    super(x, y);
    valor = 1;
    caras = new PImage[6];
    for (int i = 0; i < 6; i++) {
      caras[i] = loadImage("cara_dado_" + (i+1) + ".png");
    }
  }
  
  void roll() {
    valor = int(random(1, 7));
  }
  
  void display() {
    image(caras[valor - 1], posicion.x, posicion.y, 300, 300);
  }
}

// definir dado
Dado dado;

// Historial hasta cinco numeros
ArrayList<Integer> historial = new ArrayList<Integer>();

// botones
Button botonTirar, botonFinalizar;

void setup() {
  size(600, 600);
  
  dado = new Dado(width/2 - 150, height/2 - 150);
  botonTirar = new Button(width/2 - 75, height - 100, 150, 50, loadImage("tirar.png"));
  botonFinalizar = new Button(width/2 - 75, height - 50, 150, 50, loadImage("finalizar.png"));
}

void draw() {
  background(200);
  
  // mostrar dado
  dado.display();
  
  // mostrar número que se obtuvo
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(0);
  text("Número obtenido: " + dado.valor, width/2, 50);
  
  // mostrar historial
  textAlign(LEFT, CENTER);
  textSize(16);
  fill(0);
  text("Historial:", 20, 50);
  for (int i = 0; i < historial.size(); i++) {
    text(historial.get(i), 20, 80 + i * 30);
  }
  
  // mostrar los botones
  botonTirar.display();
  botonFinalizar.display();
}

void mousePressed() {
  // presionar tirar
  if (botonTirar.isPressed()) {
    dado.roll();
    // agregar numero al historial y que solo aparezcan hasta 5
    historial.add(dado.valor);
    if (historial.size() > 5) {
      historial.remove(0);
    }
  }
  
  // presionar finalizar
  if (botonFinalizar.isPressed()) {
    exit(); // Salir
  }
}

// Clase Button
class Button {
  PVector posicion;
  float ancho, alto;
  PImage imagen;
  
  Button(float x, float y, float w, float h, PImage img) {
    posicion = new PVector(x, y);
    ancho = w;
    alto = h;
    imagen = img;
  }
  
  void display() {
    image(imagen, posicion.x, posicion.y, ancho, alto);
  }
  
  boolean isPressed() {
    return mouseX > posicion.x && mouseX < posicion.x + ancho &&
           mouseY > posicion.y && mouseY < posicion.y + alto;
  }
}
