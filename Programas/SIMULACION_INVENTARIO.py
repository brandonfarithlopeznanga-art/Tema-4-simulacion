import tkinter as tk
from tkinter import messagebox
import random
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg


class SimulacionInventario:

    def __init__(self, root):

        self.root = root
        self.root.title("SIMULACIÓN DE INVENTARIO")
        self.root.geometry("1250x750")
        self.root.configure(bg="#eef2f7")

        self.resultados = []

        self.crear_interfaz()

    # ======================================================
    # INTERFAZ PRINCIPAL
    # ======================================================

    def crear_interfaz(self):

        # ENCABEZADO
        encabezado = tk.Frame(
            self.root,
            bg="#14532d",
            height=90
        )
        encabezado.pack(fill="x")

        tk.Label(
            encabezado,
            text="SIMULADOR DE SISTEMA DE INVENTARIOS",
            font=("Arial", 25, "bold"),
            fg="white",
            bg="#14532d"
        ).pack(pady=(18, 2))

        tk.Label(
            encabezado,
            text="Problema de inventarios | Simulación en Python",
            font=("Arial", 11),
            fg="#dcfce7",
            bg="#14532d"
        ).pack()

        # ==================================================
        # PANEL DE PARÁMETROS
        # ==================================================

        panel = tk.Frame(
            self.root,
            bg="white",
            width=285
        )

        panel.pack(
            side="left",
            fill="y",
            padx=15,
            pady=15
        )

        tk.Label(
            panel,
            text="⚙ PARÁMETROS",
            font=("Arial", 16, "bold"),
            fg="#14532d",
            bg="white"
        ).pack(pady=15)

        self.crear_campo(
            panel,
            "Días de simulación",
            "dias",
            30
        )

        self.crear_campo(
            panel,
            "Inventario inicial",
            "inventario",
            100
        )

        self.crear_campo(
            panel,
            "Demanda promedio",
            "demanda",
            15
        )

        self.crear_campo(
            panel,
            "Punto de reorden",
            "reorden",
            30
        )

        self.crear_campo(
            panel,
            "Cantidad de pedido",
            "pedido",
            80
        )

        self.crear_campo(
            panel,
            "Tiempo de entrega",
            "entrega",
            2
        )

        tk.Button(
            panel,
            text="▶ EJECUTAR SIMULACIÓN",
            command=self.simular,
            bg="#16a34a",
            fg="white",
            font=("Arial", 11, "bold"),
            relief="flat",
            padx=10,
            pady=12,
            cursor="hand2"
        ).pack(
            fill="x",
            padx=15,
            pady=25
        )

        self.estado = tk.Label(
            panel,
            text="Listo para simular",
            bg="#f1f5f9",
            fg="#475569",
            font=("Arial", 10, "bold"),
            padx=10,
            pady=10
        )

        self.estado.pack(
            fill="x",
            padx=15
        )

        # ==================================================
        # ÁREA PRINCIPAL
        # ==================================================

        principal = tk.Frame(
            self.root,
            bg="#eef2f7"
        )

        principal.pack(
            side="left",
            fill="both",
            expand=True,
            padx=5,
            pady=15
        )

        # ==================================================
        # TARJETAS
        # ==================================================

        tarjetas = tk.Frame(
            principal,
            bg="#eef2f7"
        )

        tarjetas.pack(fill="x")

        self.crear_tarjeta(
            tarjetas,
            "INVENTARIO FINAL",
            "stock"
        )

        self.crear_tarjeta(
            tarjetas,
            "DEMANDA TOTAL",
            "demanda_total"
        )

        self.crear_tarjeta(
            tarjetas,
            "PEDIDOS",
            "pedidos"
        )

        self.crear_tarjeta(
            tarjetas,
            "DÍAS CON DESABASTO",
            "desabasto"
        )

        # ==================================================
        # ESTADO DEL INVENTARIO
        # ==================================================

        estado_frame = tk.Frame(
            principal,
            bg="white"
        )

        estado_frame.pack(
            fill="x",
            pady=15
        )

        tk.Label(
            estado_frame,
            text="📦 INVENTARIO ACTUAL",
            font=("Arial", 15, "bold"),
            fg="#14532d",
            bg="white"
        ).pack(pady=10)

        self.stock_visual = tk.Label(
            estado_frame,
            text="0 unidades",
            font=("Arial", 38, "bold"),
            fg="#16a34a",
            bg="#f0fdf4"
        )

        self.stock_visual.pack(
            fill="x",
            padx=20,
            pady=(0, 15)
        )

        # ==================================================
        # GRÁFICA
        # ==================================================

        self.grafica_frame = tk.Frame(
            principal,
            bg="white"
        )

        self.grafica_frame.pack(
            fill="both",
            expand=True
        )

    # ======================================================
    # CREAR CAMPOS
    # ======================================================

    def crear_campo(
        self,
        parent,
        texto,
        nombre,
        valor
    ):

        tk.Label(
            parent,
            text=texto,
            bg="white",
            font=("Arial", 10, "bold")
        ).pack(
            pady=(4, 2)
        )

        variable = tk.IntVar(
            value=valor
        )

        tk.Spinbox(
            parent,
            from_=0,
            to=1000,
            textvariable=variable,
            width=15,
            font=("Arial", 11)
        ).pack(pady=3)

        setattr(
            self,
            nombre,
            variable
        )

    # ======================================================
    # CREAR TARJETAS
    # ======================================================

    def crear_tarjeta(
        self,
        parent,
        titulo,
        atributo
    ):

        tarjeta = tk.Frame(
            parent,
            bg="white",
            height=90
        )

        tarjeta.pack(
            side="left",
            fill="both",
            expand=True,
            padx=5
        )

        tk.Label(
            tarjeta,
            text=titulo,
            font=("Arial", 9, "bold"),
            fg="#64748b",
            bg="white"
        ).pack(
            pady=(12, 2)
        )

        etiqueta = tk.Label(
            tarjeta,
            text="0",
            font=("Arial", 22, "bold"),
            fg="#16a34a",
            bg="white"
        )

        etiqueta.pack()

        setattr(
            self,
            atributo + "_label",
            etiqueta
        )

    # ======================================================
    # SIMULACIÓN
    # ======================================================

    def simular(self):

        try:

            dias = self.dias.get()
            stock = self.inventario.get()
            demanda_media = self.demanda.get()
            punto_reorden = self.reorden.get()
            cantidad_pedido = self.pedido.get()
            tiempo_entrega = self.entrega.get()

            if dias <= 0:
                raise ValueError

            if stock < 0:
                raise ValueError

            if demanda_media <= 0:
                raise ValueError

            # ----------------------------------------------
            # LISTAS DE RESULTADOS
            # ----------------------------------------------

            inventarios = []
            demandas = []
            pedidos = []
            recibidos = []
            desabastos = []

            pedidos_pendientes = []

            # ----------------------------------------------
            # SIMULACIÓN DÍA POR DÍA
            # ----------------------------------------------

            for dia in range(1, dias + 1):

                recibido_hoy = 0

                # ------------------------------------------
                # RECIBIR PEDIDOS
                # ------------------------------------------

                pedidos_recibidos = []

                for pedido in pedidos_pendientes:

                    if pedido["llegada"] == dia:

                        stock += pedido["cantidad"]

                        recibido_hoy += pedido["cantidad"]

                        pedidos_recibidos.append(
                            pedido
                        )

                for pedido in pedidos_recibidos:

                    pedidos_pendientes.remove(
                        pedido
                    )

                # ------------------------------------------
                # GENERAR DEMANDA ALEATORIA
                # ------------------------------------------

                demanda_hoy = max(
                    0,
                    int(
                        random.gauss(
                            demanda_media,
                            demanda_media * 0.20
                        )
                    )
                )

                # ------------------------------------------
                # CONSUMO DEL INVENTARIO
                # ------------------------------------------

                if stock >= demanda_hoy:

                    stock -= demanda_hoy

                    desabasto_hoy = 0

                else:

                    desabasto_hoy = (
                        demanda_hoy - stock
                    )

                    stock = 0

                # ------------------------------------------
                # PUNTO DE REORDEN
                # ------------------------------------------

                pedido_hoy = 0

                if (
                    stock <= punto_reorden
                    and len(pedidos_pendientes) == 0
                ):

                    dia_llegada = (
                        dia + tiempo_entrega
                    )

                    if dia_llegada <= dias:

                        pedidos_pendientes.append(
                            {
                                "pedido": dia,
                                "llegada": dia_llegada,
                                "cantidad": cantidad_pedido
                            }
                        )

                        pedido_hoy = cantidad_pedido

                # ------------------------------------------
                # GUARDAR RESULTADOS
                # ------------------------------------------

                inventarios.append(stock)
                demandas.append(demanda_hoy)
                pedidos.append(pedido_hoy)
                recibidos.append(recibido_hoy)
                desabastos.append(desabasto_hoy)

            # ==================================================
            # CREAR RESULTADOS COMPLETOS
            # ==================================================

            self.resultados = []

            for i in range(dias):

                self.resultados.append(
                    {
                        "dia": i + 1,
                        "demanda": demandas[i],
                        "pedido": pedidos[i],
                        "recibido": recibidos[i],
                        "inventario": inventarios[i],
                        "desabasto": desabastos[i]
                    }
                )

            # ==================================================
            # INDICADORES
            # ==================================================

            inventario_final = inventarios[-1]

            demanda_total = sum(
                demandas
            )

            numero_pedidos = sum(
                1 for p in pedidos if p > 0
            )

            dias_desabasto = sum(
                1 for d in desabastos if d > 0
            )

            unidades_desabasto = sum(
                desabastos
            )

            # ==================================================
            # MOSTRAR RESULTADOS
            # ==================================================

            self.stock_label.config(
                text=str(inventario_final)
            )

            self.demanda_total_label.config(
                text=str(demanda_total)
            )

            self.pedidos_label.config(
                text=str(numero_pedidos)
            )

            self.desabasto_label.config(
                text=str(dias_desabasto)
            )

            self.stock_visual.config(
                text=f"{inventario_final} unidades"
            )

            # ==================================================
            # ESTADO
            # ==================================================

            if dias_desabasto > 0:

                self.estado.config(
                    text=f"⚠ Desabasto: {unidades_desabasto} unidades",
                    fg="#991b1b",
                    bg="#fee2e2"
                )

            else:

                self.estado.config(
                    text="✓ Inventario estable",
                    fg="#166534",
                    bg="#dcfce7"
                )

            # ==================================================
            # MOSTRAR GRÁFICA
            # ==================================================

            self.mostrar_grafica()

        except Exception:

            messagebox.showerror(
                "Error",
                "Verifica los parámetros ingresados."
            )

    # ======================================================
    # GRÁFICA
    # ======================================================

    def mostrar_grafica(self):

        for widget in self.grafica_frame.winfo_children():

            widget.destroy()

        dias = [
            r["dia"]
            for r in self.resultados
        ]

        inventarios = [
            r["inventario"]
            for r in self.resultados
        ]

        demandas = [
            r["demanda"]
            for r in self.resultados
        ]

        pedidos = [
            r["pedido"]
            for r in self.resultados
        ]

        figura, eje = plt.subplots(
            figsize=(8.5, 3.3),
            dpi=100
        )

        # INVENTARIO
        eje.plot(
            dias,
            inventarios,
            marker="o",
            linewidth=2.5,
            label="Inventario"
        )

        # DEMANDA
        eje.plot(
            dias,
            demandas,
            linestyle="--",
            linewidth=1.8,
            label="Demanda diaria"
        )

        # PEDIDOS
        dias_pedido = [
            dias[i]
            for i in range(len(pedidos))
            if pedidos[i] > 0
        ]

        valores_pedido = [
            pedidos[i]
            for i in range(len(pedidos))
            if pedidos[i] > 0
        ]

        if dias_pedido:

            eje.scatter(
                dias_pedido,
                valores_pedido,
                s=70,
                marker="^",
                label="Reabastecimiento"
            )

        eje.set_title(
            "Comportamiento del sistema de inventario",
            fontsize=13,
            fontweight="bold"
        )

        eje.set_xlabel(
            "Día"
        )

        eje.set_ylabel(
            "Unidades"
        )

        eje.grid(
            True,
            alpha=0.25
        )

        eje.legend()

        figura.tight_layout()

        canvas = FigureCanvasTkAgg(
            figura,
            master=self.grafica_frame
        )

        canvas.draw()

        canvas.get_tk_widget().pack(
            fill="both",
            expand=True,
            padx=10,
            pady=10
        )


# ==========================================================
# EJECUTAR PROGRAMA
# ==========================================================

if __name__ == "__main__":

    ventana = tk.Tk()

    app = SimulacionInventario(
        ventana
    )

    ventana.mainloop()