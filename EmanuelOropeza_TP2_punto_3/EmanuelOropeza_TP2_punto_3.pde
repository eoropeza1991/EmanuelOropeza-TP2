Frogger[] ranas;
SpawnerVehiculos spawnerVehiculos;
Rio rio;
boolean juegoTerminado = false;
int ranasLlegadas = 0;
int ranasRestantes = 4;
PImage fondo;

void setup() {
  size(800, 600);
  fondo = loadImage("fondo.png");
  ranas = new Frogger[4]; // solo hasta 4 ranas
  ranas[0] = new Frogger(width/2 - 32, height - 62); // Centrar rana abajo
  spawnerVehiculos = new SpawnerVehiculos();
  spawnerVehiculos.agregarVehiculo(new Auto(width, height - 150, -2)); // comenzar recorrido del auto afuera de pantalla desde derecha
  spawnerVehiculos.agregarVehiculo(new Camion(-150, height - 250, 2)); // comenzar recorrido del camion afuera de pantalla desde izquierda
  rio = new Rio();
  rio.agregarTronco(width, height - 500, -1); // comenzar recorrido del tronco1 afuera de pantalla desde derecha
  rio.agregarTronco(-191, height - 400, 1); // comenzar recorrido del tronco2 afuera de pantalla desde izquierda
}

void draw() {
  background(fondo);
  
  if (!juegoTerminado) {
    // contador de ranas
    textSize(32);
    fill(255);
    textAlign(LEFT, TOP);
    text("Ranas restantes: " + ranasRestantes, 10, 10);
    
    // movimiento obstaculos calle
    spawnerVehiculos.display();
    
    // movimiento obstaculos agua
    rio.display();
    
    // movimiento rana
    for (int i = 0; i < ranas.length; i++) {
      if (ranas[i] != null) {
        ranas[i].display();
        ranas[i].mover(); //vacio
        // rana llega a la piedra superior
        if (ranas[i].posicion.y < 25 && ranas[i].posicion.x >= width/2 - 32 && ranas[i].posicion.x <= width/2 + 32) {
          ranasLlegadas++;
          if (ranasLlegadas >= 4) {
            juegoTerminado = true;
            break;
          } else {
            ranasRestantes--;
            if (ranasRestantes > 0) {
              ranas[i] = new Frogger(width/2 - 32, height - 62); // generar nueva rana al llegar
            } else {
              ranas[i] = null; // borrar rana que llega
            }
          }
        }
      }
    }
  } else {
    textSize(32);
    textAlign(CENTER, CENTER);
    text("¡Juego terminado!", width/2, height/2);
  }
}

void keyPressed() {
  if (!juegoTerminado) {
    for (int i = 0; i < ranas.length; i++) {
      if (ranas[i] != null) {
        if (keyCode == UP) {
          ranas[i].mover(0, -50); // Mover hacia arriba 50 píxeles
        } else if (keyCode == DOWN) {
          ranas[i].mover(0, 50);
        } else if (keyCode == LEFT) {
          ranas[i].mover(-50, 0);
        } else if (keyCode == RIGHT) {
          ranas[i].mover(50, 0);
        }
      }
    }
  }
}

// Clase Frogger
class Frogger {
  PVector posicion;
  PImage imagen;
  
  Frogger(float x, float y) {
    posicion = new PVector(x, y);
    imagen = loadImage("frog.png");
  }
  
  void display() {
    image(imagen, posicion.x, posicion.y);
  }
  
  // modificar mover() para que deje de estar vacio y tenga movimientos
  void mover(float dx, float dy) {
    float nuevaX = constrain(posicion.x + dx, 0, width - 65);
    float nuevaY = constrain(posicion.y + dy, 0, height - 62);
    posicion.set(nuevaX, nuevaY);
  }
  
  // permitir que se llame mover() vacio, sin argumentos
  void mover() {
    mover(0, 0); // llamar a mover() con valores predeterminados
  }
}

// Clase Vehiculo
abstract class Vehiculo {
  PVector posicion;
  PVector velocidad;
  PImage imagen;
  float velocidadBase;
  
  Vehiculo(float x, float y, float velBase) {
    posicion = new PVector(x, y);
    velocidad = new PVector(velBase, 0);
    velocidadBase = velBase;
  }
  
  abstract void display();
  
  void mover() {
    posicion.x += velocidad.x;
    if (posicion.x > width) {
      posicion.x = -width;
    } else if (posicion.x < -width) {
      posicion.x = width;
    }
  }
}

// Clase Auto
class Auto extends Vehiculo {
  Auto(float x, float y, float velBase) {
    super(x, y, velBase);
    imagen = loadImage("auto.png");
  }
  
  void display() {
    image(imagen, posicion.x, posicion.y, 90, 40);
  }
  
  // cambiar la función mover() para que el auto vuelva a salir
  void mover() {
    posicion.x += velocidad.x;
    if (posicion.x > width) {
      posicion.x = -90; // ubicar auto fuera del lienzo a la izquierda
    } else if (posicion.x < -90) {
      posicion.x = width; // ubicar auto fuera del lienzo a la derecha
    }
  }
}

// Clase Camion
class Camion extends Vehiculo {
  Camion(float x, float y, float velBase) {
    super(x, y, velBase);
    imagen = loadImage("camion.png");
  }
  
  void display() {
    image(imagen, posicion.x, posicion.y, 150, 70);
  }
  
  // cambiar mover() para que el camión vuelva a salir
  void mover() {
    posicion.x += velocidad.x;
    if (posicion.x > width) {
      posicion.x = -150; // poner camión fuera del lienzo a la izquierda
    } else if (posicion.x < -150) {
      posicion.x = width; // poner camión fuera del lienzo a la derecha
    }
  }
}

// Clase Tronco
class Tronco {
  PVector posicion;
  PVector velocidad;
  PImage imagen;
  float velocidadBase;
  
  Tronco(float x, float y, float velBase) {
    posicion = new PVector(x, y);
    velocidad = new PVector(velBase, 0);
    velocidadBase = velBase;
    imagen = loadImage("tronco.png");
  }
  
  void display() {
    image(imagen, posicion.x, posicion.y, 191, 65);
  }
  
  void mover() {
    posicion.x += velocidad.x;
    if (posicion.x > width) {
      posicion.x = -191;
    } else if (posicion.x < -191) {
      posicion.x = width;
    }
  }
}

// Clase Rio
class Rio {
  ArrayList<Tronco> troncos;
  
  Rio() {
    troncos = new ArrayList<Tronco>();
  }
  
  void agregarTronco(float x, float y, float velBase) {
    troncos.add(new Tronco(x, y, velBase));
  }
  
  void display() {
    for (Tronco tronco : troncos) {
      tronco.display();
      tronco.mover();
    }
  }
}

// Clase SpawnerVehiculos
class SpawnerVehiculos {
  ArrayList<Vehiculo> vehiculos;
  
  SpawnerVehiculos() {
    vehiculos = new ArrayList<Vehiculo>();
  }
  
  void agregarVehiculo(Vehiculo vehiculo) {
    vehiculos.add(vehiculo);
  }
  
  void display() {
    for (Vehiculo vehiculo : vehiculos) {
      vehiculo.display();
      vehiculo.mover();
    }
  }
}
