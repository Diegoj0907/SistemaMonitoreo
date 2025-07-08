package Controlador;

import Modelo.*;
import java.util.List;

public class ControladorRegistroSalud {
    RegistroSaludDAO dao = new RegistroSaludDAO();

    public void registrar(int estudianteID, String fecha, String peso, String altura, String temperatura, String presion, List<Integer> sintomas) {
        RegistroSalud r = new RegistroSalud(estudianteID, fecha, peso, altura, temperatura, presion, sintomas);
        dao.insertarRegistro(r);
    }
}
