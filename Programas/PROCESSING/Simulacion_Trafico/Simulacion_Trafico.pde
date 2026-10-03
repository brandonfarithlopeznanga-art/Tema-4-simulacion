int cantidadAutos = 12;

float[] x = new float[cantidadAutos];
float[] velocidad = new float[cantidadAutos];
float[] tamano = new float[cantidadAutos];

boolean semaforoVerde = true;
int contadorSemaforo = 0;

void setup() {

  size(1000, 650);

  for (int i = 0; i < cantidadAutos; i++) {

    x[i] = -i * 130;
    velocidad[i] = random(2, 4);
    tamano[i] = random(35, 50);
  }
}

void draw() {

  // Fondo
  background(35, 120, 70);

  // ==========================
  // CIELO
  // ==========================

  fill(100, 180, 230);
  noStroke();
  rect(0, 0, width, 180);

  // Sol
  fill(255, 220, 80);
  ellipse(850, 80, 70, 70);

  // ==========================
  // CARRETERA
  // ==========================

  fill(55);
  rect(0, 220, width, 250);

  // Líneas de la carretera
  stroke(255);
  strokeWeight(5);

  for (int i = 0; i < width; i += 80) {
    line(i, 345, i + 40, 345);
  }

  // Bordes
  stroke(240);
  strokeWeight(4);
  line(0, 225, width, 225);
  line(0, 465, width, 465);

  // ==========================
  // SEMÁFORO
  // ==========================

  dibujarSemaforo();

  // ==========================
  // CONTROL DEL SEMÁFORO
  // ==========================

  contadorSemaforo++;

  if (contadorSemaforo > 300) {

    semaforoVerde = !semaforoVerde;
    contadorSemaforo = 0;
  }

  // ==========================
  // AUTOS
  // ==========================

  for (int i = 0; i < cantidadAutos; i++) {

    // Si el semáforo está verde
    if (semaforoVerde) {

      x[i] += velocidad[i];

    } else {

      // Los autos se detienen cerca del semáforo
      if (x[i] < 690) {
        x[i] += velocidad[i] * 0.1;
      } else {
        x[i] += velocidad[i];
      }
    }

    // Cuando salen de la pantalla regresan
    if (x[i] > width + 80) {

      x[i] = -100;
      velocidad[i] = random(2, 4);
    }

    dibujarAuto(x[i], 310, tamano[i], i);
  }

  // ==========================
  // TITULO
  // ==========================

  fill(255);
  textAlign(CENTER);

  textSize(28);
  text("SIMULACIÓN DE TRÁFICO", width / 2, 40);

  textSize(15);
  fill(230);
  text(
    "Movimiento de vehículos controlado por un semáforo",
    width / 2,
    65
  );

  // ==========================
  // PANEL INFERIOR
  // ==========================

  fill(20, 25, 40);
  noStroke();
  rect(0, 570, width, 80);

  fill(255);
  textAlign(LEFT);
  textSize(15);

  text(
    "VEHÍCULOS ACTIVOS: " + cantidadAutos,
    30,
    600
  );

  text(
    "ESTADO DEL SEMÁFORO:",
    30,
    625
  );

  if (semaforoVerde) {

    fill(80, 255, 100);
    text(" VERDE - AVANZANDO", 205, 625);

  } else {

    fill(255, 80, 80);
    text(" ROJO - DETENIENDO", 205, 625);
  }

  fill(255);
  textAlign(RIGHT);

  text(
    "SIMULACIÓN ACTIVA",
    width - 30,
    610
  );
}


// ======================================================
// FUNCIÓN PARA DIBUJAR EL SEMÁFORO
// ======================================================

void dibujarSemaforo() {

  // Poste
  stroke(30);
  strokeWeight(8);
  line(760, 225, 760, 150);

  // Caja
  fill(25);
  noStroke();
  rect(725, 90, 70, 140, 15);

  // Luz roja
  fill(255, 60, 60, 100);

  if (!semaforoVerde) {
    fill(255, 0, 0);
  }

  ellipse(760, 120, 40, 40);

  // Luz amarilla
  fill(255, 220, 0);
  ellipse(760, 155, 40, 40);

  // Luz verde
  fill(80, 255, 100, 100);

  if (semaforoVerde) {
    fill(0, 255, 70);
  }

  ellipse(760, 195, 40, 40);
}


// ======================================================
// FUNCIÓN PARA DIBUJAR LOS AUTOS
// ======================================================

void dibujarAuto(float posX, float posY, float tamaño, int numero) {

  // Carrocería
  noStroke();

  if (numero % 4 == 0) {
    fill(220, 60, 60);
  } 
  else if (numero % 4 == 1) {
    fill(60, 130, 230);
  } 
  else if (numero % 4 == 2) {
    fill(240, 190, 50);
  } 
  else {
    fill(70, 200, 120);
  }

  rect(
    posX,
    posY,
    tamaño,
    tamaño * 0.45,
    8
  );

  // Parte superior
  fill(180);

  rect(
    posX + tamaño * 0.20,
    posY - tamaño * 0.18,
    tamaño * 0.55,
    tamaño * 0.25,
    5
  );

  // Ventanas
  fill(120, 200, 230);

  rect(
    posX + tamaño * 0.25,
    posY - tamaño * 0.14,
    tamaño * 0.20,
    tamaño * 0.15
  );

  rect(
    posX + tamaño * 0.50,
    posY - tamaño * 0.14,
    tamaño * 0.20,
    tamaño * 0.15
  );

  // Llantas
  fill(20);

  ellipse(
    posX + tamaño * 0.20,
    posY + tamaño * 0.43,
    tamaño * 0.22,
    tamaño * 0.22
  );

  ellipse(
    posX + tamaño * 0.78,
    posY + tamaño * 0.43,
    tamaño * 0.22,
    tamaño * 0.22
  );

  // Luces delanteras
  fill(255, 240, 150);

  ellipse(
    posX + tamaño,
    posY + tamaño * 0.20,
    6,
    6
  );
}
