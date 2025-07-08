package Modelo;

import java.sql.*;

public class EstudianteDAO {

    public int insertarEstudiante(Estudiante e) {
        int idGenerado = -1;

        try (Connection con = ConexionDAO.conectar()) {
            CallableStatement cs = con.prepareCall("{ call dbo.InsertarEstudiante(?, ?, ?, ?, ?) }");
            cs.setString(1, e.getNombre());
            cs.setString(2, e.getApellido());
            cs.setString(3, e.getFechaNacimiento());
            cs.setString(4, e.getSexo());
            cs.setString(5, e.getCiclo());

            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                idGenerado = rs.getInt(1);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return idGenerado;
    }
}
