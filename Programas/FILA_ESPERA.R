# ============================================================
# PROGRAMA 1 - SIMULACIÓN DE UNA LÍNEA DE ESPERA
# Materia: Simulación
# Lenguaje: R
# Entorno: RStudio
# ============================================================

library(shiny)

# ------------------------------------------------------------
# INTERFAZ
# ------------------------------------------------------------

ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      
      body {
        background-color: #eef2f7;
        font-family: Arial, sans-serif;
      }

      .titulo {
        background: linear-gradient(135deg, #172554, #2563eb);
        color: white;
        padding: 25px;
        margin: -15px -15px 20px -15px;
        border-radius: 0 0 18px 18px;
      }

      .titulo h1 {
        margin: 0;
        font-size: 30px;
        font-weight: bold;
      }

      .titulo p {
        margin-top: 8px;
        font-size: 15px;
        opacity: 0.9;
      }

      .tarjeta {
        background: white;
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 3px 12px rgba(0,0,0,0.08);
      }

      .tarjeta h3 {
        color: #172554;
        font-weight: bold;
      }

      .resultado {
        background: #f8fafc;
        border-radius: 12px;
        padding: 15px;
        text-align: center;
        border: 1px solid #e2e8f0;
        min-height: 100px;
      }

      .resultado .numero {
        font-size: 27px;
        font-weight: bold;
        color: #2563eb;
      }

      .resultado .texto {
        color: #64748b;
        font-size: 13px;
        margin-top: 5px;
      }

      .btn-simular {
        background-color: #2563eb;
        color: white;
        border: none;
        font-size: 16px;
        font-weight: bold;
        padding: 12px 25px;
        border-radius: 10px;
        width: 100%;
      }

      .btn-simular:hover {
        background-color: #1d4ed8;
        color: white;
      }

      .fila {
        background-color: #eff6ff;
        border: 2px solid #bfdbfe;
        border-radius: 12px;
        padding: 15px;
        min-height: 80px;
        text-align: center;
      }

      .cliente {
        display: inline-block;
        background-color: #2563eb;
        color: white;
        border-radius: 10px;
        padding: 10px 13px;
        margin: 4px;
        font-weight: bold;
      }

      .servidor {
        background-color: #ecfdf5;
        border: 2px solid #86efac;
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        font-size: 18px;
        font-weight: bold;
        color: #166534;
      }

      .estado {
        padding: 10px;
        border-radius: 10px;
        background-color: #f1f5f9;
        text-align: center;
        font-weight: bold;
      }

    "))
  ),
  
  div(
    class = "titulo",
    h1("SIMULADOR DE LÍNEA DE ESPERA"),
    p("Tema 4.3.1 - Problemas con líneas de espera | Lenguaje R")
  ),
  
  fluidRow(
    
    # --------------------------------------------------------
    # PANEL DE CONFIGURACIÓN
    # --------------------------------------------------------
    
    column(
      width = 3,
      
      div(
        class = "tarjeta",
        
        h3("⚙️ Parámetros"),
        
        numericInput(
          "clientes",
          "Número de clientes:",
          value = 30,
          min = 5,
          max = 200,
          step = 5
        ),
        
        numericInput(
          "llegada",
          "Intervalo promedio de llegada:",
          value = 4,
          min = 1,
          max = 20,
          step = 1
        ),
        
        numericInput(
          "servicio",
          "Tiempo promedio de atención:",
          value = 5,
          min = 1,
          max = 20,
          step = 1
        ),
        
        actionButton(
          "simular",
          "▶ EJECUTAR SIMULACIÓN",
          class = "btn-simular"
        ),
        
        br(),
        br(),
        
        div(
          class = "estado",
          textOutput("estado")
        )
      )
    ),
    
    # --------------------------------------------------------
    # PANEL PRINCIPAL
    # --------------------------------------------------------
    
    column(
      width = 9,
      
      fluidRow(
        
        column(
          width = 3,
          div(
            class = "resultado",
            div(class = "numero", textOutput("r_atendidos")),
            div(class = "texto", "Clientes atendidos")
          )
        ),
        
        column(
          width = 3,
          div(
            class = "resultado",
            div(class = "numero", textOutput("r_espera")),
            div(class = "texto", "Espera promedio")
          )
        ),
        
        column(
          width = 3,
          div(
            class = "resultado",
            div(class = "numero", textOutput("r_maxfila")),
            div(class = "texto", "Máximo en fila")
          )
        ),
        
        column(
          width = 3,
          div(
            class = "resultado",
            div(class = "numero", textOutput("r_utilizacion")),
            div(class = "texto", "Utilización")
          )
        )
      ),
      
      br(),
      
      # ------------------------------------------------------
      # REPRESENTACIÓN VISUAL
      # ------------------------------------------------------
      
      div(
        class = "tarjeta",
        
        h3("👥 Estado de la línea de espera"),
        
        fluidRow(
          
          column(
            width = 8,
            
            h4("Fila de clientes"),
            
            div(
              class = "fila",
              uiOutput("fila_visual")
            )
          ),
          
          column(
            width = 4,
            
            h4("Servidor"),
            
            div(
              class = "servidor",
              "👨‍💼",
              br(),
              "Servidor de atención",
              br(),
              br(),
              textOutput("servidor_estado")
            )
          )
        )
      ),
      
      # ------------------------------------------------------
      # GRÁFICA
      # ------------------------------------------------------
      
      div(
        class = "tarjeta",
        
        h3("📊 Comportamiento de la línea"),
        
        plotOutput(
          "grafica",
          height = "330px"
        )
      ),
      
      # ------------------------------------------------------
      # TABLA
      # ------------------------------------------------------
      
      div(
        class = "tarjeta",
        
        h3("📋 Resultados de la simulación"),
        
        tableOutput("tabla")
      )
    )
  )
)

# ============================================================
# SERVIDOR
# ============================================================

server <- function(input, output, session) {
  
  datos <- reactiveVal(NULL)
  
  observeEvent(input$simular, {
    
    set.seed(as.numeric(Sys.time()))
    
    n <- input$clientes
    
    # Tiempo entre llegadas
    inter_llegada <- rexp(
      n,
      rate = 1 / input$llegada
    )
    
    llegada <- cumsum(inter_llegada)
    
    # Tiempo de servicio
    servicio <- rexp(
      n,
      rate = 1 / input$servicio
    )
    
    inicio <- numeric(n)
    salida <- numeric(n)
    espera <- numeric(n)
    
    for (i in 1:n) {
      
      if (i == 1) {
        
        inicio[i] <- llegada[i]
        
      } else {
        
        inicio[i] <- max(
          llegada[i],
          salida[i - 1]
        )
      }
      
      salida[i] <- inicio[i] + servicio[i]
      
      espera[i] <- inicio[i] - llegada[i]
    }
    
    tiempo_sistema <- salida - llegada
    
    # --------------------------------------------------------
    # CALCULO DE FILA
    # --------------------------------------------------------
    
    tiempos <- sort(unique(c(llegada, salida)))
    
    fila <- numeric(length(tiempos))
    
    for (i in seq_along(tiempos)) {
      
      fila[i] <- sum(
        llegada <= tiempos[i]
      ) -
        sum(
          salida <= tiempos[i]
        )
    }
    
    # --------------------------------------------------------
    # UTILIZACIÓN DEL SERVIDOR
    # --------------------------------------------------------
    
    tiempo_total <- max(salida)
    
    utilizacion <-
      sum(servicio) /
      tiempo_total
    
    resultados <- data.frame(
      
      Cliente = 1:n,
      
      Llegada = round(llegada, 2),
      
      Inicio = round(inicio, 2),
      
      Servicio = round(servicio, 2),
      
      Salida = round(salida, 2),
      
      Espera = round(espera, 2),
      
      Tiempo_Sistema =
        round(tiempo_sistema, 2)
    )
    
    resultados_fila <- data.frame(
      Tiempo = tiempos,
      Clientes = fila
    )
    
    datos(
      list(
        resultados = resultados,
        fila = resultados_fila,
        utilizacion = utilizacion
      )
    )
  })
  
  # ----------------------------------------------------------
  # ESTADO
  # ----------------------------------------------------------
  
  output$estado <- renderText({
    
    if (is.null(datos())) {
      
      "Listo para simular"
      
    } else {
      
      "✓ Simulación completada"
    }
  })
  
  # ----------------------------------------------------------
  # RESULTADOS
  # ----------------------------------------------------------
  
  output$r_atendidos <- renderText({
    
    if (is.null(datos()))
      return("0")
    
    nrow(datos()$resultados)
  })
  
  output$r_espera <- renderText({
    
    if (is.null(datos()))
      return("0.00 min")
    
    paste0(
      round(
        mean(datos()$resultados$Espera),
        2
      ),
      " min"
    )
  })
  
  output$r_maxfila <- renderText({
    
    if (is.null(datos()))
      return("0")
    
    max(datos()$fila$Clientes)
  })
  
  output$r_utilizacion <- renderText({
    
    if (is.null(datos()))
      return("0 %")
    
    paste0(
      round(
        datos()$utilizacion * 100,
        1
      ),
      " %"
    )
  })
  
  # ----------------------------------------------------------
  # FILA VISUAL
  # ----------------------------------------------------------
  
  output$fila_visual <- renderUI({
    
    if (is.null(datos())) {
      
      return(
        tags$p(
          "Ejecuta una simulación para visualizar la fila."
        )
      )
    }
    
    max_fila <-
      max(datos()$fila$Clientes)
    
    if (max_fila == 0) {
      
      return(
        tags$p(
          "✓ No hay clientes esperando"
        )
      )
    }
    
    clientes_mostrar <-
      min(max_fila, 12)
    
    tags$div(
      
      lapply(
        1:clientes_mostrar,
        function(i) {
          
          tags$span(
            class = "cliente",
            paste0("👤 ", i)
          )
        }
      )
    )
  })
  
  # ----------------------------------------------------------
  # ESTADO SERVIDOR
  # ----------------------------------------------------------
  
  output$servidor_estado <- renderText({
    
    if (is.null(datos())) {
      
      "Disponible"
      
    } else {
      
      utilizacion <-
        datos()$utilizacion * 100
      
      if (utilizacion >= 90) {
        
        "Alta ocupación"
        
      } else if (utilizacion >= 60) {
        
        "Ocupación media"
        
      } else {
        
        "Ocupación baja"
      }
    }
  })
  
  # ----------------------------------------------------------
  # GRÁFICA
  # ----------------------------------------------------------
  
  output$grafica <- renderPlot({
    
    req(datos())
    
    plot(
      datos()$fila$Tiempo,
      datos()$fila$Clientes,
      
      type = "s",
      
      lwd = 3,
      
      col = "#2563eb",
      
      xlab = "Tiempo de simulación",
      
      ylab = "Clientes en el sistema",
      
      main = "Comportamiento de la línea de espera",
      
      las = 1
    )
    
    grid()
    
  })
  
  # ----------------------------------------------------------
  # TABLA
  # ----------------------------------------------------------
  
  output$tabla <- renderTable({
    
    req(datos())
    
    head(
      datos()$resultados,
      15
    )
    
  }, striped = TRUE, bordered = TRUE, hover = TRUE)
}

# ============================================================
# EJECUTAR APLICACIÓN
# ============================================================

shinyApp(
  ui = ui,
  server = server
)