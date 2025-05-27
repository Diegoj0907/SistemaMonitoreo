package Modelo;

import BS.conexionbase;
import java.math.BigDecimal;
import java.sql.*;
import java.util.List;
import javax.swing.JOptionPane;

public class modelo {

    public int insertarEstudiante(String nombre, String apellido, String fechaNacimiento, String sexo, String ciclo) {
        int idGenerado = -1;
        try {
            Connection con = new conexionbase().conectar();
            String sql = "INSERT INTO Estudiantes (Nombre, Apellido, FechaNacimiento, Sexo, Ciclo) OUTPUT INSERTED.EstudianteID VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, apellido);
            ps.setString(3, fechaNacimiento);
            ps.setString(4, sexo);
            ps.setString(5, ciclo);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                idGenerado = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,
                "❌ Error al insertar estudiante:\n" + e.getMessage(),
                "Error", JOptionPane.ERROR_MESSAGE);
        }
        return idGenerado;
    }

    public void insertarRegistroSalud(int estudianteID, String fecha, String peso, String altura, String temperatura, String presion, List<Integer> sintomas) {
        try {
            Connection con = new conexionbase().conectar();
            String sql = "INSERT INTO RegistrosSalud (EstudianteID, Fecha, Peso, Altura, Temperatura, PresionArterial) OUTPUT INSERTED.RegistroID VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, estudianteID);
            ps.setString(2, fecha);
            ps.setBigDecimal(3, new BigDecimal(peso));
            ps.setBigDecimal(4, new BigDecimal(altura));
            ps.setBigDecimal(5, new BigDecimal(temperatura));
            ps.setString(6, presion);

            ResultSet rs = ps.executeQuery();
            int registroID = -1;
            if (rs.next()) {
                registroID = rs.getInt(1);
            }

            // Insertar síntomas relacionados
            if (registroID != -1) {
                for (int sintomaID : sintomas) {
                    String sqlSintoma = "INSERT INTO SintomasEstudiantes (RegistroID, SintomaID) VALUES (?, ?)";
                    PreparedStatement psSintoma = con.prepareStatement(sqlSintoma);
                    psSintoma.setInt(1, registroID);
                    psSintoma.setInt(2, sintomaID);
                    psSintoma.executeUpdate();
                }
            }

            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,
                "❌ Error al insertar registro de salud:\n" + e.getMessage(),
                "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    public void insertarAlertaSalud(int estudianteID, String fecha, String descripcion, int urgencia, List<Integer> riesgos) {
        try {
            Connection con = new conexionbase().conectar();
            String sql = "INSERT INTO AlertasSalud (EstudianteID, Fecha, Descripcion, NivelUrgencia) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, estudianteID);
            ps.setString(2, fecha);
            ps.setString(3, descripcion);
            ps.setInt(4, urgencia);
            ps.executeUpdate();

            // Insertar factores de riesgo
            for (int riesgoID : riesgos) {
                String sqlRiesgo = "INSERT INTO FactoresRiesgoEstudiantes (EstudianteID, RiesgoID) VALUES (?, ?)";
                PreparedStatement psRiesgo = con.prepareStatement(sqlRiesgo);
                psRiesgo.setInt(1, estudianteID);
                psRiesgo.setInt(2, riesgoID);
                psRiesgo.executeUpdate();
            }
            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,
                "❌ Error al insertar alerta de salud:\n" + e.getMessage(),
                "Error", JOptionPane.ERROR_MESSAGE);
        }
    }
}