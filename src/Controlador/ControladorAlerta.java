package Controlador;

import Modelo.*;
import java.util.List;

public class ControladorAlerta {
    AlertaDAO dao = new AlertaDAO();

    public void registrar(int estudianteID, String fecha, String descripcion, int urgencia, List<Integer> riesgos) {
        Alerta a = new Alerta(estudianteID, fecha, descripcion, urgencia, riesgos);
        dao.insertarAlerta(a);
    }
}