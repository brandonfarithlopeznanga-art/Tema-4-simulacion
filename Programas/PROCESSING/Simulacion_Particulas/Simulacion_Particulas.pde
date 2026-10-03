int cantidad = 50;

float[] x = new float[cantidad];
float[] y = new float[cantidad];
float[] vx = new float[cantidad];
float[] vy = new float[cantidad];
float[] tamano = new float[cantidad];

void setup() {
  size(1000, 650);

  for (int i = 0; i < cantidad; i++) {
    x[i] = random(40, width - 40);
    y[i] = random(100, height - 40);

    vx[i] = random(-4, 4);
    vy[i] = random(-4, 4);

    tamano[i] = random(8, 20);
  }
}

void draw() {

  background(12, 15, 25);

  // Titulo
  fill(255);
  textAlign(CENTER);
  textSize(26);
  text("SIMULACION DE PARTICULAS", width / 2, 40);

  textSize(14);
  fill(180);
  text("Movimiento aleatorio y rebote", width / 2, 65);

  // Area de simulacion
  noFill();
  stroke(70, 80, 110);
  strokeWeight(2);
  rect(25, 85, width - 50, height - 115);

  // Particulas
  for (int i = 0; i < cantidad; i++) {

    x[i] += vx[i];
    y[i] += vy[i];

    // Rebote horizontal
    if (x[i] < 35 || x[i] > width - 35) {
      vx[i] *= -1;
    }

    // Rebote vertical
    if (y[i] < 95 || y[i] > height - 35) {
      vy[i] *= -1;
    }

    // Particula
    noStroke();
    fill(80, 190, 255);
    ellipse(x[i], y[i], tamano[i], tamano[i]);
  }

  // Informacion
  fill(255);
  textAlign(LEFT);
  textSize(14);

  text("Particulas: " + cantidad, 40, height - 15);
  text("ESTADO: SIMULACION ACTIVA", 190, height - 15);
}
