# ============================================================
# PROGRAMA 2 - SIMULACIÓN DE UN SISTEMA DE INVENTARIOS
# Materia: Simulación
# Lenguaje: R
# Entorno: RStudio
# ============================================================

library(shiny)

# ============================================================
# INTERFAZ
# ============================================================

ui <- fluidPage(
  
  tags$head(
    
    tags$style(HTML("

      body {
        background-color: #eef2f7;
        font-family: Arial, sans-serif;
      }

      .titulo {
        background: linear-gradient(135deg, #14532d, #16a34a);
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
        background-color: white;
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 3px 12px rgba(0,0,0,0.08);
      }

      .tarjeta h3 {
        color: #14532d;
        font-weight: bold;
      }

      .resultado {
        background-color: #f8fafc;
        border-radius: 12px;
        padding: 15px;
        text-align: center;
        border: 1px solid #e2e8f0;
        min-height: 100px;
      }

      .resultado .numero {
        font-size: 27px;
        font-weight: bold;
        color: #16a34a;
      }

      .resultado .texto {
        color: #64748b;
        font-size: 13px;
        margin-top: 5px;
      }

      .btn-simular {
        background-color: #16a34a;
        color: white;
        border: none;
        font-size: 16px;
        font-weight: bold;
        padding: 12px 25px;
        border-radius: 10px;
        width: 100%;
      }

      .btn-simular:hover {
        background-color: #15803d;
        color: white;
      }

      .inventario {
        background-color: #f0fdf4;
        border: 2px solid #86efac;
        border-radius: 15px;
        padding: 25px;
        text-align: center;
      }

      .stock {
        font-size: 48px;
        font-weight: bold;
        color: #16a34a;
      }

      .stock-texto {
        font-size: 15px;
        color: #64748b;
      }

      .alerta {
        background-color: #fef2f2;
        border: 2px solid #fca5a5;
        color: #991b1b;
        border-radius: 12px;
        padding: 15px;
        text-align: center;
        font-weight: bold;
      }

      .correcto {
        background-color: #f0fdf4;
        border: 2px solid #86efac;
        color: #166534;
        border-radius: 12px;
        padding: 15px;
        text-align: center;
        font-weight: bold;
      }

    "))
    
  ),
  
  # ==========================================================
  # ENCABEZADO
  # ==========================================================
  
  div(
    class = "titulo",
    
    h1("SIMULADOR DE SISTEMA DE INVENTARIOS"),
    
    p(
      "Tema 4.3.2 - Problemas con sistemas de inventarios | Lenguaje R"
    )
  ),
  
  fluidRow(
    
    # ========================================================
    # CONFIGURACIÓN
    # ========================================================
    
    column(
      width = 3,
      
      div(
        class = "tarjeta",
        
        h3("⚙️ Parámetros del inventario"),
        
        numericInput(
          "dias",
          "Días a simular:",
          value = 30,
          min = 10,
          max = 365,
          step = 5
        ),
        
        numericInput(
          "inventario_inicial",
          "Inventario inicial:",
          value = 100,
          min = 10,
          max = 1000,
          step = 10
        ),
        
        numericInput(
          "demanda",
          "Demanda promedio diaria:",
          value = 15,
          min = 1,
          max = 100,
          step = 1
        ),
        
        numericInput(
          "punto_reorden",
          "Punto de reorden:",
          value = 30,
          min = 1,
          max = 200,
          step = 1
        ),
        
        numericInput(
          "pedido",
          "Cantidad de reabastecimiento:",
          value = 80,
          min = 1,
          max = 500,
          step = 10
        ),
        
        numericInput(
          "entrega",
          "Tiempo de entrega (días):",
          value = 2,
          min = 0,
          max = 10,
          step = 1
        ),
        
        actionButton(
          "simular",
          "▶ EJECUTAR SIMULACIÓN",
          class = "btn-simular"
        ),
        
        br(),
        br(),
        
        uiOutput("estado")
        
      )
    ),
    
    # ========================================================
    # PANEL PRINCIPAL
    # ========================================================
    
    column(
      width = 9,
      
      # ------------------------------------------------------
      # INDICADORES
      # ------------------------------------------------------
      
      fluidRow(
        
        column(
          width = 3,
          
          div(
            class = "resultado",
            
            div(
              class = "numero",
              textOutput("stock_actual")
            ),
            
            div(
              class = "texto",
              "Inventario final"
            )
          )
        ),
        
        column(
          width = 3,
          
          div(
            class = "resultado",
            
            div(
              class = "numero",
              textOutput("demanda_total")
            ),
            
            div(
              class = "texto",
              "Demanda total"
            )
          )
        ),
        
        column(
          width = 3,
          
          div(
            class = "resultado",
            
            div(
              class = "numero",
              textOutput("pedidos")
            ),
            
            div(
              class = "texto",
              "Reabastecimientos"
            )
          )
        ),
        
        column(
          width = 3,
          
          div(
            class = "resultado",
            
            div(
              class = "numero",
              textOutput("desabasto")
            ),
            
            div(
              class = "texto",
              "Días con desabasto"
            )
          )
        )
      ),
      
      br(),
      
      # ------------------------------------------------------
      # VISUALIZACIÓN DEL INVENTARIO
      # ------------------------------------------------------
      
      div(
        class = "tarjeta",
        
        h3("📦 Estado actual del inventario"),
        
        fluidRow(
          
          column(
            width = 6,
            
            div(
              class = "inventario",
              
              div(
                class = "stock",
                textOutput("stock_visual")
              ),
              
              div(
                class = "stock-texto",
                "Unidades disponibles"
              )
            )
          ),
          
          column(
            width = 6,
            
            uiOutput("alerta_inventario")
          )
        )
      ),
      
      # ------------------------------------------------------
      # GRÁFICA
      # ------------------------------------------------------
      
      div(
        class = "tarjeta",
        
        h3("📊 Comportamiento del inventario"),
        
        plotOutput(
          "grafica",
          height = "350px"
        )
      ),
      
      # ------------------------------------------------------
      # TABLA
      # ------------------------------------------------------
      
      div(
        class = "tarjeta",
        
        h3("📋 Registro de la simulación"),
        
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
  
  # ==========================================================
  # EJECUTAR SIMULACIÓN
  # ==========================================================
  
  observeEvent(input$simular, {
    
    set.seed(as.numeric(Sys.time()))
    
    dias <- input$dias
    
    inventario_inicial <-
      input$inventario_inicial
    
    demanda_promedio <-
      input$demanda
    
    punto_reorden <-
      input$punto_reorden
    
    cantidad_pedido <-
      input$pedido
    
    tiempo_entrega <-
      input$entrega
    
    # --------------------------------------------------------
    # GENERAR DEMANDA ALEATORIA
    # --------------------------------------------------------
    
    demanda_diaria <-
      rpois(
        dias,
        lambda = demanda_promedio
      )
    
    # --------------------------------------------------------
    # VECTORES
    # --------------------------------------------------------
    
    inventario <-
      numeric(dias)
    
    pedidos <-
      numeric(dias)
    
    recibidos <-
      numeric(dias)
    
    desabasto <-
      numeric(dias)
    
    costo_almacenamiento <-
      numeric(dias)
    
    costo_pedido <-
      numeric(dias)
    
    # Inventario disponible al comenzar
    stock <- inventario_inicial
    
    # Pedidos pendientes
    pedidos_pendientes <- data.frame(
      dia_pedido = numeric(0),
      dia_llegada = numeric(0),
      cantidad = numeric(0)
    )
    
    # --------------------------------------------------------
    # SIMULACIÓN DÍA POR DÍA
    # --------------------------------------------------------
    
    for (dia in 1:dias) {
      
      # ------------------------------------------------------
      # RECIBIR PEDIDOS PROGRAMADOS
      # ------------------------------------------------------
      
      if (nrow(pedidos_pendientes) > 0) {
        
        llegan <-
          which(
            pedidos_pendientes$dia_llegada == dia
          )
        
        if (length(llegan) > 0) {
          
          for (indice in llegan) {
            
            stock <-
              stock +
              pedidos_pendientes$cantidad[indice]
            
            recibidos[dia] <-
              recibidos[dia] +
              pedidos_pendientes$cantidad[indice]
          }
          
          pedidos_pendientes <-
            pedidos_pendientes[-llegan, , drop = FALSE]
        }
      }
      
      # ------------------------------------------------------
      # CONSUMO
      # ------------------------------------------------------
      
      demanda_hoy <-
        demanda_diaria[dia]
      
      if (stock >= demanda_hoy) {
        
        stock <-
          stock - demanda_hoy
        
      } else {
        
        desabasto[dia] <-
          demanda_hoy - stock
        
        stock <- 0
      }
      
      # ------------------------------------------------------
      # COSTO DE ALMACENAMIENTO
      # ------------------------------------------------------
      
      costo_almacenamiento[dia] <-
        stock * 2
      
      # ------------------------------------------------------
      # PUNTO DE REORDEN
      # ------------------------------------------------------
      
      pedido_realizado <- 0
      
      if (
        stock <= punto_reorden &&
        nrow(pedidos_pendientes) == 0
      ) {
        
        dia_llegada <-
          dia + tiempo_entrega
        
        if (dia_llegada <= dias) {
          
          nuevo_pedido <-
            data.frame(
              dia_pedido = dia,
              dia_llegada = dia_llegada,
              cantidad = cantidad_pedido
            )
          
          pedidos_pendientes <-
            rbind(
              pedidos_pendientes,
              nuevo_pedido
            )
          
          pedidos[dia] <-
            cantidad_pedido
          
          pedido_realizado <- 1
          
          costo_pedido[dia] <- 50
        }
      }
      
      inventario[dia] <-
        stock
    }
    
    # --------------------------------------------------------
    # CREAR TABLA
    # --------------------------------------------------------
    
    resultados <- data.frame(
      
      Dia = 1:dias,
      
      Demanda = demanda_diaria,
      
      Pedidos = pedidos,
      
      Recibidos = recibidos,
      
      Inventario = inventario,
      
      Desabasto = desabasto,
      
      Costo_Almacenamiento =
        costo_almacenamiento,
      
      Costo_Pedido =
        costo_pedido
    )
    
    # --------------------------------------------------------
    # GUARDAR RESULTADOS
    # --------------------------------------------------------
    
    datos(
      list(
        resultados = resultados
      )
    )
  })
  
  # ==========================================================
  # ESTADO
  # ==========================================================
  
  output$estado <- renderUI({
    
    if (is.null(datos())) {
      
      return(
        div(
          class = "correcto",
          "Listo para simular"
        )
      )
    }
    
    div(
      class = "correcto",
      "✓ Simulación completada"
    )
  })
  
  # ==========================================================
  # INVENTARIO FINAL
  # ==========================================================
  
  output$stock_actual <- renderText({
    
    if (is.null(datos()))
      return("0")
    
    tail(
      datos()$resultados$Inventario,
      1
    )
  })
  
  # ==========================================================
  # DEMANDA TOTAL
  # ==========================================================
  
  output$demanda_total <- renderText({
    
    if (is.null(datos()))
      return("0")
    
    sum(
      datos()$resultados$Demanda
    )
  })
  
  # ==========================================================
  # REABASTECIMIENTOS
  # ==========================================================
  
  output$pedidos <- renderText({
    
    if (is.null(datos()))
      return("0")
    
    sum(
      datos()$resultados$Pedidos > 0
    )
  })
  
  # ==========================================================
  # DESABASTO
  # ==========================================================
  
  output$desabasto <- renderText({
    
    if (is.null(datos()))
      return("0")
    
    sum(
      datos()$resultados$Desabasto > 0
    )
  })
  
  # ==========================================================
  # INVENTARIO VISUAL
  # ==========================================================
  
  output$stock_visual <- renderText({
    
    if (is.null(datos()))
      return("0")
    
    tail(
      datos()$resultados$Inventario,
      1
    )
  })
  
  # ==========================================================
  # ALERTA DEL INVENTARIO
  # ==========================================================
  
  output$alerta_inventario <- renderUI({
    
    if (is.null(datos()))
      return(NULL)
    
    stock <-
      tail(
        datos()$resultados$Inventario,
        1
      )
    
    desabasto_total <-
      sum(
        datos()$resultados$Desabasto
      )
    
    if (desabasto_total > 0) {
      
      div(
        class = "alerta",
        
        "⚠️ Se presentó desabasto",
        
        br(),
        
        paste(
          "Unidades no cubiertas:",
          desabasto_total
        )
      )
      
    } else if (stock <= input$punto_reorden) {
      
      div(
        class = "alerta",
        
        "⚠️ Inventario bajo",
        
        br(),
        
        "Se recomienda revisar el nivel de existencias."
      )
      
    } else {
      
      div(
        class = "correcto",
        
        "✓ Inventario estable",
        
        br(),
        
        "No se presentó desabasto."
      )
    }
  })
  
  # ==========================================================
  # GRÁFICA
  # ==========================================================
  
  output$grafica <- renderPlot({
    
    req(datos())
    
    resultados <-
      datos()$resultados
    
    plot(
      
      resultados$Dia,
      
      resultados$Inventario,
      
      type = "o",
      
      pch = 16,
      
      lwd = 3,
      
      col = "#16a34a",
      
      xlab = "Día",
      
      ylab = "Unidades en inventario",
      
      main =
        "Evolución del nivel de inventario",
      
      las = 1
    )
    
    grid()
    
    abline(
      h = input$punto_reorden,
      col = "#dc2626",
      lwd = 2,
      lty = 2
    )
    
    legend(
      "topright",
      
      legend = c(
        "Inventario",
        "Punto de reorden"
      ),
      
      col = c(
        "#16a34a",
        "#dc2626"
      ),
      
      lwd = 2,
      
      lty = c(1, 2),
      
      bty = "n"
    )
  })
  
  # ==========================================================
  # TABLA
  # ==========================================================
  
  output$tabla <- renderTable({
    
    req(datos())
    
    head(
      datos()$resultados,
      20
    )
    
  },
  striped = TRUE,
  bordered = TRUE,
  hover = TRUE
  )
}

# ============================================================
# EJECUTAR APLICACIÓN
# ============================================================

shinyApp(
  ui = ui,
  server = server
)