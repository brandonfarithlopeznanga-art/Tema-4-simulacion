import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class SIMULACION_INVENTARIO extends JFrame {

    private JTextField txtDias;
    private JTextField txtInventarioInicial;
    private JTextField txtDemanda;
    private JTextField txtPuntoReorden;
    private JTextField txtCantidadPedido;
    private JTextField txtTiempoEntrega;

    private JLabel lblInventarioFinal;
    private JLabel lblDemandaTotal;
    private JLabel lblPedidos;
    private JLabel lblDesabasto;

    private JTextArea areaResultados;

    private final Random random = new Random();

    public SIMULACION_INVENTARIO() {

        setTitle("Simulador de Sistema de Inventarios");
        setSize(1250, 780);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        crearInterfaz();
    }

    private void crearInterfaz() {

        JPanel principal = new JPanel(new BorderLayout());
        principal.setBackground(new Color(245, 247, 250));

        // =====================================================
        // ENCABEZADO
        // =====================================================

        JPanel encabezado = new JPanel(new BorderLayout());
        encabezado.setBackground(new Color(25, 45, 70));
        encabezado.setBorder(
                new EmptyBorder(18, 25, 18, 25)
        );

        JLabel titulo = new JLabel(
                "SIMULADOR DE SISTEMA DE INVENTARIOS"
        );

        titulo.setForeground(Color.WHITE);
        titulo.setFont(
                new Font("Arial", Font.BOLD, 26)
        );

        JLabel subtitulo = new JLabel(
                "Simulación de demanda, pedidos, reabastecimiento y desabasto"
        );

        subtitulo.setForeground(
                new Color(210, 220, 230)
        );

        subtitulo.setFont(
                new Font("Arial", Font.PLAIN, 14)
        );

        JPanel textos = new JPanel();

        textos.setLayout(
                new BoxLayout(
                        textos,
                        BoxLayout.Y_AXIS
                )
        );

        textos.setOpaque(false);

        textos.add(titulo);

        textos.add(
                Box.createVerticalStrut(5)
        );

        textos.add(subtitulo);

        encabezado.add(
                textos,
                BorderLayout.WEST
        );

        principal.add(
                encabezado,
                BorderLayout.NORTH
        );

        // =====================================================
        // PANEL IZQUIERDO
        // =====================================================

        JPanel panelIzquierdo = new JPanel();

        panelIzquierdo.setPreferredSize(
                new Dimension(315, 0)
        );

        panelIzquierdo.setBackground(
                new Color(235, 239, 244)
        );

        panelIzquierdo.setBorder(
                new EmptyBorder(20, 20, 20, 20)
        );

        panelIzquierdo.setLayout(
                new BoxLayout(
                        panelIzquierdo,
                        BoxLayout.Y_AXIS
                )
        );

        JLabel lblParametros =
                new JLabel("PARÁMETROS DEL SISTEMA");

        lblParametros.setFont(
                new Font(
                        "Arial",
                        Font.BOLD,
                        18
                )
        );

        lblParametros.setForeground(
                new Color(25, 45, 70)
        );

        panelIzquierdo.add(
                lblParametros
        );

        panelIzquierdo.add(
                Box.createVerticalStrut(18)
        );

        txtDias = crearCampo(
                panelIzquierdo,
                "Número de días:",
                "30"
        );

        txtInventarioInicial = crearCampo(
                panelIzquierdo,
                "Inventario inicial:",
                "100"
        );

        txtDemanda = crearCampo(
                panelIzquierdo,
                "Demanda promedio diaria:",
                "15"
        );

        txtPuntoReorden = crearCampo(
                panelIzquierdo,
                "Punto de reorden:",
                "30"
        );

        txtCantidadPedido = crearCampo(
                panelIzquierdo,
                "Cantidad por pedido:",
                "80"
        );

        txtTiempoEntrega = crearCampo(
                panelIzquierdo,
                "Tiempo de entrega:",
                "2"
        );

        panelIzquierdo.add(
                Box.createVerticalStrut(10)
        );

        JButton btnSimular =
                new JButton(
                        "▶  EJECUTAR SIMULACIÓN"
                );

        btnSimular.setFont(
                new Font(
                        "Arial",
                        Font.BOLD,
                        14
                )
        );

        btnSimular.setForeground(
                Color.WHITE
        );

        btnSimular.setBackground(
                new Color(35, 110, 170)
        );

        btnSimular.setFocusPainted(false);
        btnSimular.setBorderPainted(false);

        btnSimular.setMaximumSize(
                new Dimension(275, 45)
        );

        btnSimular.addActionListener(
                e -> ejecutarSimulacion()
        );

        panelIzquierdo.add(
                btnSimular
        );

        panelIzquierdo.add(
                Box.createVerticalStrut(20)
        );

        JLabel instrucciones =
                new JLabel(
                        "<html><div style='width:250px'>" +
                                "<b>Funcionamiento:</b><br><br>" +
                                "El sistema genera una demanda diaria " +
                                "aleatoria. Cuando el inventario alcanza " +
                                "el punto de reorden, se genera un pedido.<br><br>" +
                                "Los resultados cambian en cada ejecución." +
                                "</div></html>"
                );

        instrucciones.setFont(
                new Font(
                        "Arial",
                        Font.PLAIN,
                        13
                )
        );

        panelIzquierdo.add(
                instrucciones
        );

        principal.add(
                panelIzquierdo,
                BorderLayout.WEST
        );

        // =====================================================
        // PANEL CENTRAL
        // =====================================================

        JPanel centro =
                new JPanel(
                        new BorderLayout()
                );

        centro.setBackground(
                new Color(245, 247, 250)
        );

        centro.setBorder(
                new EmptyBorder(20, 20, 20, 20)
        );

        // =====================================================
        // TARJETAS DE RESULTADOS
        // =====================================================

        JPanel tarjetas =
                new JPanel(
                        new GridLayout(
                                1,
                                4,
                                12,
                                0
                        )
                );

        tarjetas.setOpaque(false);

        lblInventarioFinal =
                crearTarjeta(
                        tarjetas,
                        "INVENTARIO FINAL",
                        "0"
                );

        lblDemandaTotal =
                crearTarjeta(
                        tarjetas,
                        "DEMANDA TOTAL",
                        "0"
                );

        lblPedidos =
                crearTarjeta(
                        tarjetas,
                        "PEDIDOS",
                        "0"
                );

        lblDesabasto =
                crearTarjeta(
                        tarjetas,
                        "DÍAS CON DESABASTO",
                        "0"
                );

        centro.add(
                tarjetas,
                BorderLayout.NORTH
        );

        // =====================================================
        // ÁREA DE RESULTADOS
        // =====================================================

        areaResultados =
                new JTextArea();

        areaResultados.setEditable(false);

        areaResultados.setFont(
                new Font(
                        "Consolas",
                        Font.PLAIN,
                        13
                )
        );

        areaResultados.setBackground(
                Color.WHITE
        );

        areaResultados.setForeground(
                new Color(35, 35, 35)
        );

        areaResultados.setBorder(
                new EmptyBorder(
                        15,
                        15,
                        15,
                        15
                )
        );

        JScrollPane scroll =
                new JScrollPane(
                        areaResultados
                );

        scroll.setBorder(
                BorderFactory.createTitledBorder(
                        BorderFactory.createLineBorder(
                                new Color(210, 215, 220)
                        ),
                        "RESULTADOS DE LA SIMULACIÓN"
                )
        );

        centro.add(
                scroll,
                BorderLayout.CENTER
        );

        principal.add(
                centro,
                BorderLayout.CENTER
        );

        add(principal);
    }

    // =====================================================
    // CREAR CAMPOS
    // =====================================================

    private JTextField crearCampo(
            JPanel contenedor,
            String texto,
            String valor
    ) {

        JLabel etiqueta =
                new JLabel(texto);

        etiqueta.setFont(
                new Font(
                        "Arial",
                        Font.BOLD,
                        12
                )
        );

        JTextField campo =
                new JTextField(valor);

        campo.setFont(
                new Font(
                        "Arial",
                        Font.PLAIN,
                        14
                )
        );

        campo.setMaximumSize(
                new Dimension(
                        275,
                        32
                )
        );

        contenedor.add(
                etiqueta
        );

        contenedor.add(
                Box.createVerticalStrut(4)
        );

        contenedor.add(
                campo
        );

        contenedor.add(
                Box.createVerticalStrut(8)
        );

        return campo;
    }

    // =====================================================
    // CREAR TARJETAS
    // =====================================================

    private JLabel crearTarjeta(
            JPanel contenedor,
            String titulo,
            String valor
    ) {

        JPanel tarjeta =
                new JPanel();

        tarjeta.setLayout(
                new BoxLayout(
                        tarjeta,
                        BoxLayout.Y_AXIS
                )
        );

        tarjeta.setBackground(
                Color.WHITE
        );

        tarjeta.setBorder(
                BorderFactory.createCompoundBorder(
                        BorderFactory.createLineBorder(
                                new Color(220, 225, 230)
                        ),
                        new EmptyBorder(
                                12,
                                12,
                                12,
                                12
                        )
                )
        );

        JLabel lblTitulo =
                new JLabel(titulo);

        lblTitulo.setFont(
                new Font(
                        "Arial",
                        Font.BOLD,
                        11
                )
        );

        lblTitulo.setForeground(
                new Color(100, 105, 110)
        );

        JLabel lblValor =
                new JLabel(valor);

        lblValor.setFont(
                new Font(
                        "Arial",
                        Font.BOLD,
                        22
                )
        );

        lblValor.setForeground(
                new Color(25, 45, 70)
        );

        tarjeta.add(
                lblTitulo
        );

        tarjeta.add(
                Box.createVerticalStrut(8)
        );

        tarjeta.add(
                lblValor
        );

        contenedor.add(
                tarjeta
        );

        return lblValor;
    }

    // =====================================================
    // EJECUTAR SIMULACIÓN
    // =====================================================

    private void ejecutarSimulacion() {

        try {

            int dias =
                    Integer.parseInt(
                            txtDias.getText()
                    );

            int inventarioInicial =
                    Integer.parseInt(
                            txtInventarioInicial.getText()
                    );

            double demandaMedia =
                    Double.parseDouble(
                            txtDemanda.getText()
                    );

            int puntoReorden =
                    Integer.parseInt(
                            txtPuntoReorden.getText()
                    );

            int cantidadPedido =
                    Integer.parseInt(
                            txtCantidadPedido.getText()
                    );

            int tiempoEntrega =
                    Integer.parseInt(
                            txtTiempoEntrega.getText()
                    );

            // =================================================
            // VALIDACIÓN
            // =================================================

            if (
                    dias <= 0 ||
                            inventarioInicial < 0 ||
                            demandaMedia <= 0 ||
                            puntoReorden < 0 ||
                            cantidadPedido <= 0 ||
                            tiempoEntrega < 0
            ) {

                JOptionPane.showMessageDialog(
                        this,
                        "Verifica los parámetros introducidos.",
                        "Datos incorrectos",
                        JOptionPane.WARNING_MESSAGE
                );

                return;
            }

            // =================================================
            // LISTAS PARA GUARDAR RESULTADOS
            // =================================================

            List<Integer> inventarios =
                    new ArrayList<>();

            List<Integer> demandas =
                    new ArrayList<>();

            List<Boolean> pedidos =
                    new ArrayList<>();

            List<String> estados =
                    new ArrayList<>();

            List<Integer> diasLlegadaPedido =
                    new ArrayList<>();

            // =================================================
            // VARIABLES
            // =================================================

            int inventario =
                    inventarioInicial;

            int demandaTotal = 0;

            int numeroPedidos = 0;

            int diasDesabasto = 0;

            // =================================================
            // SIMULACIÓN
            // =================================================

            for (
                    int dia = 1;
                    dia <= dias;
                    dia++
            ) {

                // ---------------------------------------------
                // RECIBIR PEDIDOS PENDIENTES
                // ---------------------------------------------

                for (
                        int i = diasLlegadaPedido.size() - 1;
                        i >= 0;
                        i--
                ) {

                    if (
                            diasLlegadaPedido.get(i)
                                    <= dia
                    ) {

                        inventario +=
                                cantidadPedido;

                        diasLlegadaPedido.remove(i);
                    }
                }

                // ---------------------------------------------
                // GENERAR DEMANDA
                // ---------------------------------------------

                int demanda =
                        generarDemanda(
                                demandaMedia
                        );

                demandas.add(
                        demanda
                );

                demandaTotal +=
                        demanda;

                // ---------------------------------------------
                // CONSUMIR INVENTARIO
                // ---------------------------------------------

                inventario -=
                        demanda;

                if (inventario < 0) {

                    diasDesabasto++;

                    inventario = 0;

                    estados.add(
                            "DESABASTO"
                    );

                } else {

                    estados.add(
                            "NORMAL"
                    );
                }

                // ---------------------------------------------
                // REVISAR PUNTO DE REORDEN
                // ---------------------------------------------

                boolean pedidoRealizado =
                        false;

                if (
                        inventario <= puntoReorden &&
                                diasLlegadaPedido.isEmpty()
                ) {

                    pedidoRealizado =
                            true;

                    numeroPedidos++;

                    int diaLlegada =
                            dia + tiempoEntrega;

                    diasLlegadaPedido.add(
                            diaLlegada
                    );
                }

                pedidos.add(
                        pedidoRealizado
                );

                inventarios.add(
                        inventario
                );
            }

            // =================================================
            // ACTUALIZAR TARJETAS
            // =================================================

            lblInventarioFinal.setText(
                    String.valueOf(
                            inventario
                    )
            );

            lblDemandaTotal.setText(
                    String.valueOf(
                            demandaTotal
                    )
            );

            lblPedidos.setText(
                    String.valueOf(
                            numeroPedidos
                    )
            );

            lblDesabasto.setText(
                    String.valueOf(
                            diasDesabasto
                    )
            );

            // =================================================
            // CONSTRUIR REPORTE
            // =================================================

            StringBuilder resultados =
                    new StringBuilder();

            resultados.append(
                    "====================================================================\n"
            );

            resultados.append(
                    "              RESULTADOS DEL SISTEMA DE INVENTARIOS\n"
            );

            resultados.append(
                    "====================================================================\n\n"
            );

            resultados.append(
                    String.format(
                            "Días simulados          : %d%n",
                            dias
                    )
            );

            resultados.append(
                    String.format(
                            "Inventario inicial      : %d unidades%n",
                            inventarioInicial
                    )
            );

            resultados.append(
                    String.format(
                            "Demanda promedio        : %.2f unidades/día%n",
                            demandaMedia
                    )
            );

            resultados.append(
                    String.format(
                            "Punto de reorden        : %d unidades%n",
                            puntoReorden
                    )
            );

            resultados.append(
                    String.format(
                            "Cantidad por pedido     : %d unidades%n",
                            cantidadPedido
                    )
            );

            resultados.append(
                    String.format(
                            "Tiempo de entrega       : %d días%n%n",
                            tiempoEntrega
                    )
            );

            resultados.append(
                    "--------------------------------------------------------------------\n"
            );

            resultados.append(
                    String.format(
                            "%-7s %-10s %-15s %-12s %-15s%n",
                            "Día",
                            "Demanda",
                            "Inventario",
                            "Pedido",
                            "Estado"
                    )
            );

            resultados.append(
                    "--------------------------------------------------------------------\n"
            );

            for (
                    int i = 0;
                    i < dias;
                    i++
            ) {

                resultados.append(
                        String.format(
                                "%-7d %-10d %-15d %-12s %-15s%n",
                                i + 1,
                                demandas.get(i),
                                inventarios.get(i),
                                pedidos.get(i)
                                        ? "SÍ"
                                        : "NO",
                                estados.get(i)
                        )
                );
            }

            resultados.append(
                    "\n--------------------------------------------------------------------\n"
            );

            resultados.append(
                    "INDICADORES FINALES\n"
            );

            resultados.append(
                    "--------------------------------------------------------------------\n"
            );

            resultados.append(
                    String.format(
                            "Inventario final    : %d unidades%n",
                            inventario
                    )
            );

            resultados.append(
                    String.format(
                            "Demanda total       : %d unidades%n",
                            demandaTotal
                    )
            );

            resultados.append(
                    String.format(
                            "Pedidos realizados  : %d%n",
                            numeroPedidos
                    )
            );

            resultados.append(
                    String.format(
                            "Días con desabasto  : %d%n",
                            diasDesabasto
                    )
            );

            resultados.append(
                    "\n====================================================================\n"
            );

            resultados.append(
                    "Los resultados cambian en cada ejecución debido\n"
            );

            resultados.append(
                    "a la generación aleatoria de la demanda diaria.\n"
            );

            resultados.append(
                    "====================================================================\n"
            );

            areaResultados.setText(
                    resultados.toString()
            );

        } catch (NumberFormatException e) {

            JOptionPane.showMessageDialog(
                    this,
                    "Introduce únicamente números válidos.",
                    "Error",
                    JOptionPane.ERROR_MESSAGE
            );
        }
    }

    // =====================================================
    // GENERAR DEMANDA ALEATORIA
    // =====================================================

    private int generarDemanda(
            double media
    ) {

        double desviacion =
                media * 0.20;

        double valor =
                media +
                        random.nextGaussian()
                                * desviacion;

        return Math.max(
                1,
                (int) Math.round(valor)
        );
    }

    // =====================================================
    // MAIN
    // =====================================================

    public static void main(
            String[] args
    ) {

        SwingUtilities.invokeLater(
                () -> {

                    SIMULACION_INVENTARIO ventana =
                            new SIMULACION_INVENTARIO();

                    ventana.setVisible(true);
                }
        );
    }
}