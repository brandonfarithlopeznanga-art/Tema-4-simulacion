import tkinter as tk
from tkinter import ttk, messagebox
import random
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg


# ============================================================
# SIMULACIÓN DE LÍNEA DE ESPERA
# Lenguaje: Python
# ============================================================

class FilaEspera:

    def __init__(self, root):

        self.root = root
        self.root.title("Simulador de Línea de Espera")
        self.root.geometry("1250x750")
        self.root.configure(bg="#eef2f7")

        self.resultados = []
        self.fila_tiempos = []
        self.fila_clientes = []

        self.crear_interfaz()

    # ========================================================
    # INTERFAZ
    # ========================================================

    def crear_interfaz(self):

        encabezado = tk.Frame(
            self.root,
            bg="#172554",
            height=90
        )
        encabezado.pack(fill="x")

        tk.Label(
            encabezado,
            text="SIMULADOR DE LÍNEA DE ESPERA",
            font=("Arial", 25, "bold"),
            fg="white",
            bg="#172554"
        ).pack(pady=(18, 2))

        tk.Label(
            encabezado,
            text="Problemas con líneas de espera | Simulación en Python",
            font=("Arial", 11),
            fg="#dbeafe",
            bg="#172554"
        ).pack()

        # ----------------------------------------------------
        # PANEL IZQUIERDO
        # ----------------------------------------------------

        panel = tk.Frame(
            self.root,
            bg="white",
            width=280
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
            fg="#172554",
            bg="white"
        ).pack(pady=15)

        tk.Label(
            panel,
            text="Número de clientes",
            bg="white",
            font=("Arial", 10, "bold")
        ).pack()

        self.clientes = tk.IntVar(value=30)

        tk.Spinbox(
            panel,
            from_=5,
            to=200,
            textvariable=self.clientes,
            width=15,
            font=("Arial", 11)
        ).pack(pady=5)

        tk.Label(
            panel,
            text="Llegada promedio",
            bg="white",
            font=("Arial", 10, "bold")
        ).pack(pady=(15, 0))

        self.llegada = tk.IntVar(value=4)

        tk.Spinbox(
            panel,
            from_=1,
            to=20,
            textvariable=self.llegada,
            width=15,
            font=("Arial", 11)
        ).pack(pady=5)

        tk.Label(
            panel,
            text="Servicio promedio",
            bg="white",
            font=("Arial", 10, "bold")
        ).pack(pady=(15, 0))

        self.servicio = tk.IntVar(value=5)

        tk.Spinbox(
            panel,
            from_=1,
            to=20,
            textvariable=self.servicio,
            width=15,
            font=("Arial", 11)
        ).pack(pady=5)

        tk.Button(
            panel,
            text="▶ EJECUTAR SIMULACIÓN",
            command=self.simular,
            bg="#2563eb",
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

        # ----------------------------------------------------
        # ÁREA PRINCIPAL
        # ----------------------------------------------------

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

        # ----------------------------------------------------
        # TARJETAS DE RESULTADOS
        # ----------------------------------------------------

        tarjetas = tk.Frame(
            principal,
            bg="#eef2f7"
        )
        tarjetas.pack(fill="x")

        self.crear_tarjeta(
            tarjetas,
            "CLIENTES ATENDIDOS",
            "atendidos"
        )

        self.crear_tarjeta(
            tarjetas,
            "ESPERA PROMEDIO",
            "espera"
        )

        self.crear_tarjeta(
            tarjetas,
            "MÁXIMO EN FILA",
            "maxfila"
        )

        self.crear_tarjeta(
            tarjetas,
            "UTILIZACIÓN",
            "utilizacion"
        )

        # ----------------------------------------------------
        # VISUALIZACIÓN DE FILA
        # ----------------------------------------------------

        visual = tk.Frame(
            principal,
            bg="white"
        )
        visual.pack(
            fill="x",
            pady=15
        )

        tk.Label(
            visual,
            text="👥 ESTADO DE LA LÍNEA",
            font=("Arial", 15, "bold"),
            fg="#172554",
            bg="white"
        ).pack(pady=10)

        self.fila_visual = tk.Frame(
            visual,
            bg="#eff6ff",
            height=100
        )

        self.fila_visual.pack(
            fill="x",
            padx=15,
            pady=(0, 15)
        )

        # ----------------------------------------------------
        # GRÁFICA
        # ----------------------------------------------------

        self.grafica_frame = tk.Frame(
            principal,
            bg="white"
        )

        self.grafica_frame.pack(
            fill="both",
            expand=True
        )

    # ========================================================
    # TARJETAS
    # ========================================================

    def crear_tarjeta(self, parent, titulo, atributo):

        tarjeta = tk.Frame(
            parent,
            bg="white",
            width=190,
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
        ).pack(pady=(12, 2))

        etiqueta = tk.Label(
            tarjeta,
            text="0",
            font=("Arial", 22, "bold"),
            fg="#2563eb",
            bg="white"
        )

        etiqueta.pack()

        setattr(
            self,
            atributo + "_label",
            etiqueta
        )

    # ========================================================
    # SIMULACIÓN
    # ========================================================

    def simular(self):

        try:

            n = self.clientes.get()
            media_llegada = self.llegada.get()
            media_servicio = self.servicio.get()

            if n <= 0:
                raise ValueError

            # -----------------------------------------------
            # GENERACIÓN ALEATORIA
            # -----------------------------------------------

            tiempos_llegada = []

            tiempo = 0

            for _ in range(n):

                intervalo = random.expovariate(
                    1 / media_llegada
                )

                tiempo += intervalo

                tiempos_llegada.append(tiempo)

            # -----------------------------------------------
            # TIEMPOS DE SERVICIO
            # -----------------------------------------------

            tiempos_servicio = [
                random.expovariate(
                    1 / media_servicio
                )
                for _ in range(n)
            ]

            inicio = []
            salida = []
            espera = []

            servidor_libre = 0

            for i in range(n):

                inicio_cliente = max(
                    tiempos_llegada[i],
                    servidor_libre
                )

                salida_cliente = (
                    inicio_cliente +
                    tiempos_servicio[i]
                )

                espera_cliente = (
                    inicio_cliente -
                    tiempos_llegada[i]
                )

                inicio.append(inicio_cliente)
                salida.append(salida_cliente)
                espera.append(espera_cliente)

                servidor_libre = salida_cliente

            # -----------------------------------------------
            # RESULTADOS
            # -----------------------------------------------

            self.resultados = []

            for i in range(n):

                self.resultados.append({
                    "cliente": i + 1,
                    "llegada": tiempos_llegada[i],
                    "inicio": inicio[i],
                    "servicio": tiempos_servicio[i],
                    "salida": salida[i],
                    "espera": espera[i]
                })

            # -----------------------------------------------
            # FILA EN EL TIEMPO
            # -----------------------------------------------

            tiempos = sorted(
                set(
                    tiempos_llegada +
                    salida
                )
            )

            clientes_fila = []

            for t in tiempos:

                en_sistema = sum(
                    1
                    for i in range(n)
                    if tiempos_llegada[i] <= t
                    and salida[i] > t
                )

                clientes_fila.append(
                    en_sistema
                )

            self.fila_tiempos = tiempos
            self.fila_clientes = clientes_fila

            # -----------------------------------------------
            # INDICADORES
            # -----------------------------------------------

            espera_promedio = sum(espera) / n

            max_fila = max(
                clientes_fila
            ) if clientes_fila else 0

            tiempo_total = max(salida)

            utilizacion = (
                sum(tiempos_servicio)
                / tiempo_total
            ) * 100

            # -----------------------------------------------
            # MOSTRAR RESULTADOS
            # -----------------------------------------------

            self.atendidos_label.config(
                text=str(n)
            )

            self.espera_label.config(
                text=f"{espera_promedio:.2f} min"
            )

            self.maxfila_label.config(
                text=str(max_fila)
            )

            self.utilizacion_label.config(
                text=f"{utilizacion:.1f}%"
            )

            self.estado.config(
                text="✓ Simulación completada",
                fg="#166534",
                bg="#dcfce7"
            )

            self.mostrar_fila(
                max_fila
            )

            self.mostrar_grafica()

        except Exception:

            messagebox.showerror(
                "Error",
                "Verifica los parámetros ingresados."
            )

    # ========================================================
    # VISUALIZAR FILA
    # ========================================================

    def mostrar_fila(self, cantidad):

        for widget in self.fila_visual.winfo_children():
            widget.destroy()

        if cantidad == 0:

            tk.Label(
                self.fila_visual,
                text="✓ No hay clientes esperando",
                bg="#eff6ff",
                fg="#166534",
                font=("Arial", 12, "bold")
            ).pack(
                pady=30
            )

            return

        mostrar = min(
            cantidad,
            12
        )

        for i in range(mostrar):

            tk.Label(
                self.fila_visual,
                text=f"👤 {i + 1}",
                bg="#2563eb",
                fg="white",
                font=("Arial", 10, "bold"),
                padx=10,
                pady=8
            ).pack(
                side="left",
                padx=4,
                pady=25
            )

        if cantidad > 12:

            tk.Label(
                self.fila_visual,
                text=f"+ {cantidad - 12} clientes",
                bg="#f59e0b",
                fg="white",
                font=("Arial", 10, "bold"),
                padx=10,
                pady=8
            ).pack(
                side="left",
                padx=4,
                pady=25
            )

    # ========================================================
    # GRÁFICA
    # ========================================================

    def mostrar_grafica(self):

        for widget in self.grafica_frame.winfo_children():
            widget.destroy()

        figura, eje = plt.subplots(
            figsize=(8, 3.2),
            dpi=100
        )

        eje.step(
            self.fila_tiempos,
            self.fila_clientes,
            where="post",
            linewidth=2.5
        )

        eje.set_title(
            "Comportamiento de la línea de espera",
            fontsize=13,
            fontweight="bold"
        )

        eje.set_xlabel(
            "Tiempo de simulación"
        )

        eje.set_ylabel(
            "Clientes en el sistema"
        )

        eje.grid(
            True,
            alpha=0.25
        )

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


# ============================================================
# EJECUTAR
# ============================================================

if __name__ == "__main__":

    ventana = tk.Tk()

    app = FilaEspera(
        ventana
    )

    ventana.mainloop()