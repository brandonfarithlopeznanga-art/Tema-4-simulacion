import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class FILA_ESPERA extends JFrame {

    private JTextField txtClientes;
    private JTextField txtLlegada;
    private JTextField txtServicio;

    private JLabel lblEsperaPromedio;
    private JLabel lblEsperaMaxima;
    private JLabel lblColaMaxima;
    private JLabel lblUtilizacion;

    private JTextArea areaResultados;

    private final Random random = new Random();

    public FILA_ESPERA() {

        setTitle("Simulador de Línea de Espera");
        setSize(1200, 750);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        crearInterfaz();
    }

    private void crearInterfaz() {

        JPanel principal = new JPanel(new BorderLayout());
        principal.setBackground(new Color(245, 247, 250));

        // =========================
        // ENCABEZADO
        // =========================

        JPanel encabezado = new JPanel(new BorderLayout());
        encabezado.setBackground(new Color(25, 45, 70));
        encabezado.setBorder(new EmptyBorder(18, 25, 18, 25));

        JLabel titulo = new JLabel("SIMULADOR DE LÍNEA DE ESPERA");
        titulo.setForeground(Color.WHITE);
        titulo.setFont(new Font("Arial", Font.BOLD, 26));

        JLabel subtitulo = new JLabel("Simulación de un sistema de atención con llegadas y servicios aleatorios");
        subtitulo.setForeground(new Color(210, 220, 230));
        subtitulo.setFont(new Font("Arial", Font.PLAIN, 14));

        JPanel textos = new JPanel();
        textos.setLayout(new BoxLayout(textos, BoxLayout.Y_AXIS));
        textos.setOpaque(false);

        textos.add(titulo);
        textos.add(Box.createVerticalStrut(5));
        textos.add(subtitulo);

        encabezado.add(textos, BorderLayout.WEST);

        principal.add(encabezado, BorderLayout.NORTH);

        // =========================
        // PANEL IZQUIERDO
        // =========================

        JPanel panelIzquierdo = new JPanel();
        panelIzquierdo.setPreferredSize(new Dimension(310, 0));
        panelIzquierdo.setBackground(new Color(235, 239, 244));
        panelIzquierdo.setBorder(new EmptyBorder(20, 20, 20, 20));

        panelIzquierdo.setLayout(new BoxLayout(panelIzquierdo, BoxLayout.Y_AXIS));

        JLabel lblParametros = new JLabel("PARÁMETROS");
        lblParametros.setFont(new Font("Arial", Font.BOLD, 18));
        lblParametros.setForeground(new Color(25, 45, 70));

        panelIzquierdo.add(lblParametros);
        panelIzquierdo.add(Box.createVerticalStrut(20));

        txtClientes = crearCampo("Número de clientes:", "30");
        txtLlegada = crearCampo("Media entre llegadas:", "4");
        txtServicio = crearCampo("Media de servicio:", "5");

        panelIzquierdo.add(txtClientes);
        panelIzquierdo.add(Box.createVerticalStrut(15));

        panelIzquierdo.add(txtLlegada);
        panelIzquierdo.add(Box.createVerticalStrut(15));

        panelIzquierdo.add(txtServicio);
        panelIzquierdo.add(Box.createVerticalStrut(25));

        JButton btnSimular = new JButton("▶  EJECUTAR SIMULACIÓN");
        btnSimular.setFont(new Font("Arial", Font.BOLD, 14));
        btnSimular.setForeground(Color.WHITE);
        btnSimular.setBackground(new Color(35, 110, 170));
        btnSimular.setFocusPainted(false);
        btnSimular.setBorderPainted(false);
        btnSimular.setPreferredSize(new Dimension(260, 45));
        btnSimular.setMaximumSize(new Dimension(260, 45));

        btnSimular.addActionListener(e -> ejecutarSimulacion());

        panelIzquierdo.add(btnSimular);
        panelIzquierdo.add(Box.createVerticalStrut(25));

        JLabel instrucciones = new JLabel(
                "<html><div style='width:240px'>" +
                        "<b>Funcionamiento:</b><br><br>" +
                        "Cada cliente llega en un tiempo aleatorio y espera " +
                        "si el servidor está ocupado.<br><br>" +
                        "Los resultados cambian en cada ejecución debido " +
                        "a la generación aleatoria de los tiempos." +
                        "</div></html>"
        );

        instrucciones.setFont(new Font("Arial", Font.PLAIN, 13));
        panelIzquierdo.add(instrucciones);

        principal.add(panelIzquierdo, BorderLayout.WEST);

        // =========================
        // CENTRO
        // =========================

        JPanel centro = new JPanel(new BorderLayout());
        centro.setBackground(new Color(245, 247, 250));
        centro.setBorder(new EmptyBorder(20, 20, 20, 20));

        // TARJETAS

        JPanel tarjetas = new JPanel(new GridLayout(1, 4, 12, 0));
        tarjetas.setOpaque(false);

        lblEsperaPromedio = crearTarjeta(tarjetas, "ESPERA PROMEDIO", "0.00");
        lblEsperaMaxima = crearTarjeta(tarjetas, "ESPERA MÁXIMA", "0.00");
        lblColaMaxima = crearTarjeta(tarjetas, "COLA MÁXIMA", "0");
        lblUtilizacion = crearTarjeta(tarjetas, "UTILIZACIÓN", "0.00%");

        centro.add(tarjetas, BorderLayout.NORTH);

        // RESULTADOS

        areaResultados = new JTextArea();

        areaResultados.setEditable(false);
        areaResultados.setFont(new Font("Consolas", Font.PLAIN, 13));
        areaResultados.setBackground(Color.WHITE);
        areaResultados.setForeground(new Color(35, 35, 35));
        areaResultados.setBorder(new EmptyBorder(15, 15, 15, 15));

        JScrollPane scroll = new JScrollPane(areaResultados);
        scroll.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(new Color(210, 215, 220)),
                "RESULTADOS DE LA SIMULACIÓN"
        ));

        centro.add(scroll, BorderLayout.CENTER);

        principal.add(centro, BorderLayout.CENTER);

        add(principal);
    }

    // ==========================================
    // CREAR CAMPO
    // ==========================================

    private JTextField crearCampo(String texto, String valor) {

        JPanel panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        panel.setOpaque(false);
        panel.setMaximumSize(new Dimension(260, 70));

        JLabel etiqueta = new JLabel(texto);
        etiqueta.setFont(new Font("Arial", Font.BOLD, 13));

        JTextField campo = new JTextField(valor);
        campo.setFont(new Font("Arial", Font.PLAIN, 14));
        campo.setMaximumSize(new Dimension(260, 35));

        panel.add(etiqueta);
        panel.add(Box.createVerticalStrut(5));
        panel.add(campo);

        // Guardamos la referencia según el texto
        if (texto.startsWith("Número")) {
            txtClientes = campo;
        }

        if (texto.startsWith("Media entre")) {
            txtLlegada = campo;
        }

        if (texto.startsWith("Media de servicio")) {
            txtServicio = campo;
        }

        return campo;
    }

    // ==========================================
    // CREAR TARJETA
    // ==========================================

    private JLabel crearTarjeta(
            JPanel contenedor,
            String titulo,
            String valorInicial) {

        JPanel tarjeta = new JPanel();
        tarjeta.setLayout(new BoxLayout(tarjeta, BoxLayout.Y_AXIS));
        tarjeta.setBackground(Color.WHITE);
        tarjeta.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(220, 225, 230)),
                new EmptyBorder(12, 12, 12, 12)
        ));

        JLabel lblTitulo = new JLabel(titulo);
        lblTitulo.setFont(new Font("Arial", Font.BOLD, 11));
        lblTitulo.setForeground(new Color(100, 105, 110));

        JLabel lblValor = new JLabel(valorInicial);
        lblValor.setFont(new Font("Arial", Font.BOLD, 22));
        lblValor.setForeground(new Color(25, 45, 70));

        tarjeta.add(lblTitulo);
        tarjeta.add(Box.createVerticalStrut(8));
        tarjeta.add(lblValor);

        contenedor.add(tarjeta);

        return lblValor;
    }

    // ==========================================
    // EJECUTAR SIMULACIÓN
    // ==========================================

    private void ejecutarSimulacion() {

        try {

            int numeroClientes = Integer.parseInt(txtClientes.getText());
            double mediaLlegada = Double.parseDouble(txtLlegada.getText());
            double mediaServicio = Double.parseDouble(txtServicio.getText());

            if (numeroClientes <= 0 ||
                    mediaLlegada <= 0 ||
                    mediaServicio <= 0) {

                JOptionPane.showMessageDialog(
                        this,
                        "Todos los valores deben ser mayores que cero.",
                        "Datos incorrectos",
                        JOptionPane.WARNING_MESSAGE
                );

                return;
            }

            List<Double> llegada = new ArrayList<>();
            List<Double> inicioServicio = new ArrayList<>();
            List<Double> salida = new ArrayList<>();
            List<Double> espera = new ArrayList<>();
            List<Double> servicio = new ArrayList<>();

            double tiempoLlegadaAcumulado = 0;

            double sumaEspera = 0;
            double esperaMaxima = 0;

            double tiempoOcupado = 0;

            int colaMaxima = 0;

            for (int i = 0; i < numeroClientes; i++) {

                // Tiempo entre llegadas
                double interLlegada = exponencial(mediaLlegada);

                tiempoLlegadaAcumulado += interLlegada;

                llegada.add(tiempoLlegadaAcumulado);

                // Tiempo de servicio
                double tiempoServicio = exponencial(mediaServicio);

                servicio.add(tiempoServicio);

                double inicio;

                if (i == 0) {
                    inicio = tiempoLlegadaAcumulado;
                } else {
                    inicio = Math.max(
                            tiempoLlegadaAcumulado,
                            salida.get(i - 1)
                    );
                }

                inicioServicio.add(inicio);

                double tiempoEspera =
                        inicio - tiempoLlegadaAcumulado;

                espera.add(tiempoEspera);

                sumaEspera += tiempoEspera;

                if (tiempoEspera > esperaMaxima) {
                    esperaMaxima = tiempoEspera;
                }

                double tiempoSalida = inicio + tiempoServicio;

                salida.add(tiempoSalida);

                tiempoOcupado += tiempoServicio;

                // Calcular cola aproximada
                int clientesEnCola = 0;

                for (int j = 0; j < i; j++) {

                    if (llegada.get(j) <= tiempoLlegadaAcumulado &&
                            salida.get(j) > tiempoLlegadaAcumulado) {

                        clientesEnCola++;
                    }
                }

                if (clientesEnCola > colaMaxima) {
                    colaMaxima = clientesEnCola;
                }
            }

            double esperaPromedio =
                    sumaEspera / numeroClientes;

            double tiempoTotal =
                    salida.get(salida.size() - 1);

            double utilizacion =
                    (tiempoOcupado / tiempoTotal) * 100;

            // =========================
            // ACTUALIZAR TARJETAS
            // =========================

            lblEsperaPromedio.setText(
                    String.format("%.2f", esperaPromedio)
            );

            lblEsperaMaxima.setText(
                    String.format("%.2f", esperaMaxima)
            );

            lblColaMaxima.setText(
                    String.valueOf(colaMaxima)
            );

            lblUtilizacion.setText(
                    String.format("%.2f%%", utilizacion)
            );

            // =========================
            // MOSTRAR RESULTADOS
            // =========================

            StringBuilder resultados = new StringBuilder();

            resultados.append(
                    "============================================================\n"
            );

            resultados.append(
                    "             RESULTADOS DE LA SIMULACIÓN\n"
            );

            resultados.append(
                    "============================================================\n\n"
            );

            resultados.append(
                    String.format(
                            "Clientes simulados: %d%n",
                            numeroClientes
                    )
            );

            resultados.append(
                    String.format(
                            "Media entre llegadas: %.2f%n",
                            mediaLlegada
                    )
            );

            resultados.append(
                    String.format(
                            "Media de servicio: %.2f%n%n",
                            mediaServicio
                    )
            );

            resultados.append(
                    "------------------------------------------------------------\n"
            );

            resultados.append(
                    String.format(
                            "%-8s %-12s %-12s %-12s %-12s%n",
                            "Cliente",
                            "Llegada",
                            "Inicio",
                            "Salida",
                            "Espera"
                    )
            );

            resultados.append(
                    "------------------------------------------------------------\n"
            );

            for (int i = 0; i < numeroClientes; i++) {

                resultados.append(
                        String.format(
                                "%-8d %-12.2f %-12.2f %-12.2f %-12.2f%n",
                                i + 1,
                                llegada.get(i),
                                inicioServicio.get(i),
                                salida.get(i),
                                espera.get(i)
                        )
                );
            }

            resultados.append(
                    "\n------------------------------------------------------------\n"
            );

            resultados.append("INDICADORES FINALES\n");

            resultados.append(
                    "------------------------------------------------------------\n"
            );

            resultados.append(
                    String.format(
                            "Espera promedio : %.2f unidades de tiempo%n",
                            esperaPromedio
                    )
            );

            resultados.append(
                    String.format(
                            "Espera máxima   : %.2f unidades de tiempo%n",
                            esperaMaxima
                    )
            );

            resultados.append(
                    String.format(
                            "Cola máxima     : %d clientes%n",
                            colaMaxima
                    )
            );

            resultados.append(
                    String.format(
                            "Utilización     : %.2f%%%n",
                            utilizacion
                    )
            );

            resultados.append(
                    String.format(
                            "Tiempo total    : %.2f unidades%n",
                            tiempoTotal
                    )
            );

            resultados.append(
                    "\n============================================================\n"
            );

            resultados.append(
                    "Los valores cambian en cada ejecución debido\n" +
                            "a la generación aleatoria de los tiempos.\n"
            );

            resultados.append(
                    "============================================================\n"
            );

            areaResultados.setText(resultados.toString());

        } catch (NumberFormatException e) {

            JOptionPane.showMessageDialog(
                    this,
                    "Por favor introduce solamente números válidos.",
                    "Error",
                    JOptionPane.ERROR_MESSAGE
            );
        }
    }

    // ==========================================
    // DISTRIBUCIÓN EXPONENCIAL
    // ==========================================

    private double exponencial(double media) {

        double u = random.nextDouble();

        return -media * Math.log(1 - u);
    }

    // ==========================================
    // MAIN
    // ==========================================

    public static void main(String[] args) {

        SwingUtilities.invokeLater(() -> {

            FILA_ESPERA ventana = new FILA_ESPERA();

            ventana.setVisible(true);
        });
    }
}