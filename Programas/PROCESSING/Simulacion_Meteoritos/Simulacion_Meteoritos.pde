int cantidad = 35;

float[] x = new float[cantidad];
float[] y = new float[cantidad];
float[] velocidad = new float[cantidad];
float[] tamano = new float[cantidad];

void setup() {
  size(1000, 650);

  for (int i = 0; i < cantidad; i++) {
    x[i] = random(width);
    y[i] = random(-650, 0);
    velocidad[i] = random(3, 9);
    tamano[i] = random(8, 22);
  }
}

void draw() {

  // Fondo espacial
  background(5, 8, 20);

  // Estrellas
  randomSeed(10);

  for (int i = 0; i < 120; i++) {
    float estrellaX = random(width);
    float estrellaY = random(height);

    stroke(180, 190, 220);
    point(estrellaX, estrellaY);
  }

  // Titulo
  fill(255);
  textAlign(CENTER);
  textSize(28);
  text("SIMULACION DE LLUVIA DE METEORITOS", width/2, 40);

  textSize(14);
  fill(180);
  text("Objetos descendiendo a diferentes velocidades", width/2, 65);

  // Meteoritos
  for (int i = 0; i < cantidad; i++) {

    y[i] += velocidad[i];

    // Si sale de la pantalla vuelve arriba
    if (y[i] > height + 30) {
      y[i] = random(-300, -20);
      x[i] = random(width);
      velocidad[i] = random(3, 9);
    }

    // Estela
    stroke(180, 190, 255, 120);
    strokeWeight(3);

    line(
      x[i],
      y[i] - tamano[i] * 2,
      x[i],
      y[i]
    );

    // Meteorito
    noStroke();
    fill(220, 150, 70);

    ellipse(
      x[i],
      y[i],
      tamano[i],
      tamano[i]
    );
  }

  // Panel inferior
  fill(15, 20, 35);
  rect(0, height - 45, width, 45);

  fill(255);
  textAlign(LEFT);
  textSize(14);

  text(
    "METEORITOS ACTIVOS: " + cantidad,
    30,
    height - 18
  );

  textAlign(RIGHT);

  text(
    "SIMULACION EN EJECUCION",
    width - 30,
    height - 18
  );
}
