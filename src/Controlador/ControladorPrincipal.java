package Controlador;

import Vista.*;
import Modelo.ConexionDAO;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellRenderer;
import java.awt.Component;
import java.sql.*;

public class ControladorPrincipal {
    private FrmPrincipal vista;

    private final String[] vistasSQL = {
        "vw_ConteoAlertasPorUrgencia",
        "vw_PromedioTempPresion",
        "vw_EstudiantesConTempAlta",
        "vw_RankingTemperatura"
    };
    public ControladorPrincipal(FrmPrincipal vista) {
        this.vista = vista;
        configurarComboBoxVistas();
        conectarEventos();
    }
    public void iniciar() {
        vista.setVisible(true);
    }
    private void configurarComboBoxVistas() {
        vista.cmbVistas.removeAllItems();
        vista.cmbVistas.addItem("SELECCIONAR UNA VISTA");  // opción por defecto
        vista.cmbVistas.addItem("1. Contar el número de alertas de salud por nivel de urgencia");
        vista.cmbVistas.addItem("2. Obtener el promedio de temperatura y presión por estudiante");
        vista.cmbVistas.addItem("3. Filtrar estudiantes cuya temperatura promedio supera los 37.5 °C");
        vista.cmbVistas.addItem("4. Asignar un ranking a los estudiantes según su temperatura promedio (descendente)");
        vista.cmbVistas.setSelectedIndex(0);
    }
    private void conectarEventos() {
        vista.btnMonitoreo.addActionListener(e -> {
            FrmMonitoreo monitoreo = new FrmMonitoreo();
            ControladorMonitoreo c = new ControladorMonitoreo(monitoreo);
            c.iniciarVista();
            vista.dispose();
        });
        vista.cmbVistas.addActionListener(e -> {
            int index = vista.cmbVistas.getSelectedIndex();

            if (index > 0 && index <= vistasSQL.length) {
                String vistaSQL = vistasSQL[index - 1];
                mostrarDatos("SELECT * FROM " + vistaSQL);
            } else {
                vista.tablaDatos.setModel(new DefaultTableModel());
            }
        });
        vista.btnVerTodo.addActionListener(e -> {
            mostrarDatos("""
                SELECT 
                    e.EstudianteID,
                    e.Nombre,
                    e.Apellido,
                    e.FechaNacimiento,
                    e.Sexo,
                    e.Ciclo,
                    r.Fecha AS FechaRegistroSalud,
                    r.Peso,
                    r.Altura,
                    r.Temperatura,
                    r.PresionArterial,
                    a.Fecha AS FechaAlerta,
                    a.Descripcion AS AlertaDescripcion,
                    a.NivelUrgencia
                FROM Estudiantes e
                LEFT JOIN RegistrosSalud r ON e.EstudianteID = r.EstudianteID
                LEFT JOIN AlertasSalud a ON e.EstudianteID = a.EstudianteID
            """);
        });
        vista.btnSalir.addActionListener(e -> System.exit(0));
    }
    private void mostrarDatos(String consulta) {
        try (Connection con = ConexionDAO.conectar();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(consulta)) {

            ResultSetMetaData meta = rs.getMetaData();
            DefaultTableModel modelo = new DefaultTableModel();
            int col = meta.getColumnCount();
            // Agregar columnas
            for (int i = 1; i <= col; i++) {
                modelo.addColumn(meta.getColumnLabel(i));
            }
            // Agregar filas
            while (rs.next()) {
                Object[] fila = new Object[col];
                for (int i = 0; i < col; i++) {
                    fila[i] = rs.getObject(i + 1);
                }
                modelo.addRow(fila);
            }
            vista.tablaDatos.setModel(modelo);
            ajustarColumnas();

            vista.pack();
            vista.setLocationRelativeTo(null);

        } catch (Exception e) {
            JOptionPane.showMessageDialog(vista, "❌ Error al cargar datos: " + e.getMessage());
        }
    }
    private void ajustarColumnas() {
        JTable tabla = vista.tablaDatos;
        tabla.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);

        for (int col = 0; col < tabla.getColumnCount(); col++) {
            int ancho = 100;
            for (int row = 0; row < tabla.getRowCount(); row++) {
                TableCellRenderer renderer = tabla.getCellRenderer(row, col);
                Component comp = tabla.prepareRenderer(renderer, row, col);
                ancho = Math.max(comp.getPreferredSize().width + 10, ancho);
            }
            tabla.getColumnModel().getColumn(col).setPreferredWidth(ancho);
        }
    }
}