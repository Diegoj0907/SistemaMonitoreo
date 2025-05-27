package BS;

import java.sql.Connection;
import java.sql.DriverManager;
import javax.swing.JOptionPane;

public class conexionbase {

    public Connection conectar() {
        Connection con = null;
        try {
            // Cargar el driver JDBC de SQL Server
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Cadena de conexión con autenticación SQL Server
            String url = "jdbc:sqlserver://localhost:1433;"
                       + "databaseName=SistemaMonitoreo;"
                       + "user=juan;"
                       + "password=juan456;"
                       + "encrypt=true;"
                       + "trustServerCertificate=true;";

            // Establecer conexión
            con = DriverManager.getConnection(url);

            // Mostrar mensaje emergente
            JOptionPane.showMessageDialog(null, "✅ Conexión exitosa a la base de datos.");
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,
                    "❌ Error de conexión a la base de datos:\n" + e.getMessage(),
                    "Error", JOptionPane.ERROR_MESSAGE);
        }
        return con;
    }
}