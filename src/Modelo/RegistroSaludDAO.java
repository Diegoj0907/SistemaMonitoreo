package Modelo;

import java.sql.*;
import java.math.BigDecimal;
import javax.swing.*;

public class RegistroSaludDAO {

    public void insertarRegistro(RegistroSalud r) {
        try (Connection con = ConexionDAO.conectar()) {
            CallableStatement cs = con.prepareCall("{ call dbo.InsertarRegistroSalud(?, ?, ?, ?, ?, ?) }");
            cs.setInt(1, r.getIdEstudiante());
            cs.setString(2, r.getFechaRegistro());
            cs.setBigDecimal(3, new BigDecimal(r.getPeso()));
            cs.setBigDecimal(4, new BigDecimal(r.getAltura()));
            cs.setBigDecimal(5, new BigDecimal(r.getTemperatura()));
            cs.setString(6, r.getPresion());

            ResultSet rs = cs.executeQuery();
            int registroID = -1;
            if (rs.next()) registroID = rs.getInt(1);

            if (registroID != -1) {
                for (int sintomaID : r.getSintomasIDs()) {
                    CallableStatement csSint = con.prepareCall("{ call dbo.InsertarSintomaEstudiante(?, ?) }");
                    csSint.setInt(1, registroID);
                    csSint.setInt(2, sintomaID);
                    csSint.execute();
                    csSint.close();
                }
            }

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error al registrar salud: " + e.getMessage());
        }
    }
}
