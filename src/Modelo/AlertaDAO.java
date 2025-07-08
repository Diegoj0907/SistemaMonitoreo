package Modelo;

import java.sql.*;
import javax.swing.*;

public class AlertaDAO {

    public void insertarAlerta(Alerta a) {
        try (Connection con = ConexionDAO.conectar()) {
            // 1. Insertar alerta
            CallableStatement cs = con.prepareCall("{ call dbo.InsertarAlertaSalud(?, ?, ?, ?) }");
            cs.setInt(1, a.getEstudianteID());
            cs.setString(2, a.getFecha());
            cs.setString(3, a.getDescripcion());
            cs.setInt(4, a.getUrgencia());
            cs.execute(); // No se espera un resultado, solo se ejecuta

            // 2. Insertar factores de riesgo del estudiante (relación EstudianteID - RiesgoID)
            for (int riesgoID : a.getRiesgos()) {
                CallableStatement csR = con.prepareCall("{ call dbo.InsertarFactorRiesgoEstudiante(?, ?) }");
                csR.setInt(1, a.getEstudianteID()); // ✅ EstudianteID correcto
                csR.setInt(2, riesgoID);
                csR.execute();
                csR.close();
            }

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "❌ Error al registrar alerta: " + e.getMessage());
        }
    }
}
