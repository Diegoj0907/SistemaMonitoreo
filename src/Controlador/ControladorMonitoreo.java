package Controlador;

import Modelo.*;
import Vista.FrmMonitoreo;
import Vista.FrmPrincipal;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ControladorMonitoreo {

    private FrmMonitoreo vista;
    private ModeloFrm modeloFrm;
    private EstudianteDAO estudianteDAO;
    private RegistroSaludDAO registroSaludDAO;
    private AlertaDAO alertaDAO;

    public ControladorMonitoreo(FrmMonitoreo vista) {
        this.vista = vista;
        this.modeloFrm = new ModeloFrm();
        this.estudianteDAO = new EstudianteDAO();
        this.registroSaludDAO = new RegistroSaludDAO();
        this.alertaDAO = new AlertaDAO();

        llenarCombosYListas();
        conectarEventos();
        configurarAtajosTeclado();
    }

    public void iniciarVista() {
        vista.setVisible(true);
    }

    private void llenarCombosYListas() {
        vista.cmbCiclo.removeAllItems();
        for (String ciclo : modeloFrm.obtenerCiclos()) {
            vista.cmbCiclo.addItem(ciclo);
        }

        vista.cmbSexo.removeAllItems();
        for (String sexo : modeloFrm.obtenerSexos()) {
            vista.cmbSexo.addItem(sexo);
        }

        vista.cmbUrgencia.removeAllItems();
        for (String urgencia : modeloFrm.obtenerUrgencias()) {
            vista.cmbUrgencia.addItem(urgencia);
        }

        DefaultListModel<String> modeloSintomas = new DefaultListModel<>();
        for (String s : modeloFrm.obtenerSintomas()) {
            modeloSintomas.addElement(s);
        }
        vista.listSintomas.setModel(modeloSintomas);

        DefaultListModel<String> modeloRiesgos = new DefaultListModel<>();
        for (String r : modeloFrm.obtenerRiesgos()) {
            modeloRiesgos.addElement(r);
        }
        vista.listRiesgos.setModel(modeloRiesgos);
    }

    private void conectarEventos() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // REGISTRO DE ESTUDIANTE
        vista.btnContinuar1.addActionListener(e -> {
            try {
                String nombre = vista.txtNombres.getText().trim();
                String apellido = vista.txtApellidos.getText().trim();
                String ciclo = vista.cmbCiclo.getSelectedItem().toString();
                String sexo = vista.cmbSexo.getSelectedItem().toString();
                String fecha = sdf.format(vista.dateNacimiento.getDate());

                if (nombre.isEmpty() || apellido.isEmpty()) {
                    JOptionPane.showMessageDialog(vista, "⚠️ Completa todos los campos del estudiante.");
                    return;
                }

                Estudiante estudiante = new Estudiante(nombre, apellido, fecha, sexo, ciclo);
                int id = estudianteDAO.insertarEstudiante(estudiante);

                if (id != -1) {
                    vista.txtIDEstudiante.setText(String.valueOf(id));
                    vista.tabs.setSelectedIndex(1);
                } else {
                    JOptionPane.showMessageDialog(vista, "❌ No se pudo registrar el estudiante.");
                }

            } catch (Exception ex) {
                JOptionPane.showMessageDialog(vista, "⚠️ Error al registrar estudiante: " + ex.getMessage());
            }
        });

        // REGISTRO DE SALUD Y ALERTA
        vista.btnRegistrarFinal.addActionListener(e -> {
            try {
                int estudianteID = Integer.parseInt(vista.txtIDEstudiante.getText());
                String fechaSalud = sdf.format(vista.dateRegistro.getDate());
                String peso = vista.txtPeso.getText().trim();
                String altura = vista.txtAltura.getText().trim();
                String temperatura = vista.txtTemperatura.getText().trim();
                String presion = vista.txtPresion.getText().trim();

                if (peso.isEmpty() || altura.isEmpty() || temperatura.isEmpty() || presion.isEmpty()) {
                    JOptionPane.showMessageDialog(vista, "⚠️ Completa todos los campos de salud.");
                    return;
                }

                List<Integer> sintomasIDs = new ArrayList<>();
                for (String val : vista.listSintomas.getSelectedValuesList()) {
                    switch (val) {
                        case "Fiebre" -> sintomasIDs.add(1);
                        case "Dolor de cabeza" -> sintomasIDs.add(2);
                        case "Tos" -> sintomasIDs.add(3);
                    }
                }

                RegistroSalud salud = new RegistroSalud(estudianteID, fechaSalud, peso, altura, temperatura, presion, sintomasIDs);
                registroSaludDAO.insertarRegistro(salud);

                String descripcion = vista.txtAlertaDescripcion.getText().trim();
                int urgencia = Integer.parseInt(vista.cmbUrgencia.getSelectedItem().toString());

                if (descripcion.isEmpty()) {
                    JOptionPane.showMessageDialog(vista, "⚠️ Ingresa la descripción de alerta.");
                    return;
                }

                List<Integer> riesgosIDs = new ArrayList<>();
                for (String val : vista.listRiesgos.getSelectedValuesList()) {
                    switch (val) {
                        case "Asma" -> riesgosIDs.add(1);
                        case "Diabetes" -> riesgosIDs.add(2);
                        case "Hipertensión" -> riesgosIDs.add(3);
                    }
                }

                String fechaAlerta = sdf.format(new Date());
                Alerta alerta = new Alerta(estudianteID, fechaAlerta, descripcion, urgencia, riesgosIDs);
                alertaDAO.insertarAlerta(alerta);

                JOptionPane.showMessageDialog(vista, "✅ Datos registrados correctamente en la base de datos.");

                vista.dispose(); // Cierra FrmMonitoreo
                FrmPrincipal principal = new FrmPrincipal();
                new ControladorPrincipal(principal).iniciar();

            } catch (Exception ex) {
                JOptionPane.showMessageDialog(vista, "❌ Error al guardar datos: " + ex.getMessage());
            }
        });

        // BOTÓN AYUDA
        vista.btnAyuda.addActionListener(e -> {
            JOptionPane.showMessageDialog(vista, """
                🆘 Ayuda:
                - Completa los datos del estudiante.
                - En la pestaña SALUD, registra peso, temperatura, etc.
                - En ALERTA, describe la situación y selecciona urgencia.
                - Usa F2 para registrar rápidamente.
                """, "Ayuda", JOptionPane.INFORMATION_MESSAGE);
        });

        // NAVEGACIÓN ENTRE PESTAÑAS
        vista.btnContinuar2.addActionListener(e -> vista.tabs.setSelectedIndex(2));
        vista.btnAtras2.addActionListener(e -> vista.tabs.setSelectedIndex(0));
        vista.btnAtras3.addActionListener(e -> vista.tabs.setSelectedIndex(1));
        vista.btnCancelar1.addActionListener(e -> cancelarYVolver());
        vista.btnCancelar2.addActionListener(e -> cancelarYVolver());
        vista.btnCancelar3.addActionListener(e -> cancelarYVolver());
    }

    private void cancelarYVolver() {
        vista.dispose();
        FrmPrincipal principal = new FrmPrincipal();
        new ControladorPrincipal(principal).iniciar();
    }

    private void configurarAtajosTeclado() {
        vista.getRootPane().getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW)
                .put(KeyStroke.getKeyStroke("F2"), "registrarFinal");
        vista.getRootPane().getActionMap()
                .put("registrarFinal", new AbstractAction() {
                    @Override
                    public void actionPerformed(ActionEvent e) {
                        vista.btnRegistrarFinal.doClick();
                    }
                });

        vista.getRootPane().getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW)
                .put(KeyStroke.getKeyStroke("ESCAPE"), "cerrar");
        vista.getRootPane().getActionMap()
                .put("cerrar", new AbstractAction() {
                    @Override
                    public void actionPerformed(ActionEvent e) {
                        cancelarYVolver();
                    }
                });

        vista.getRootPane().getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW)
                .put(KeyStroke.getKeyStroke("control H"), "mostrarAyuda");
        vista.getRootPane().getActionMap()
                .put("mostrarAyuda", new AbstractAction() {
                    @Override
                    public void actionPerformed(ActionEvent e) {
                        vista.btnAyuda.doClick();
                    }
                });
    }
}