package Modelo;

import java.sql.*;

public class ConexionDAO {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=SistemaMonitoreo;";
    private static final String USER = "juan";
    private static final String PASS = "juan456";

    public static Connection conectar() throws SQLException {
        return DriverManager.getConnection(URL + "encrypt=true;trustServerCertificate=true;", USER, PASS);
    }

    public static CallableStatement prepararProcedimiento(Connection con, String procedimiento, int parametros) throws SQLException {
        StringBuilder sb = new StringBuilder("{ call " + procedimiento + "(");
        for (int i = 0; i < parametros; i++) sb.append(i == 0 ? "?" : ",?");
        sb.append(") }");
        return con.prepareCall(sb.toString());
    }
}