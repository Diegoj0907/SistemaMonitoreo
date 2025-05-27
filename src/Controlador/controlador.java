package Controlador;

import Modelo.modelo;
import java.util.List;

public class controlador {

    modelo modeloDatos = new modelo();

    public int registrarDatosEstudiante(String nombre, String apellido, String fechaNacimiento, String sexo, String ciclo) {
        return modeloDatos.insertarEstudiante(nombre, apellido, fechaNacimiento, sexo, ciclo);
    }

    public void registrarDatosSalud(int estudianteID, String fecha, String peso, String altura, String temperatura, String presion, List<Integer> sintomasSeleccionados) {
        modeloDatos.insertarRegistroSalud(estudianteID, fecha, peso, altura, temperatura, presion, sintomasSeleccionados);
    }

    public void registrarDatosAlerta(int estudianteID, String fecha, String descripcion, int urgencia, List<Integer> riesgosSeleccionados) {
        modeloDatos.insertarAlertaSalud(estudianteID, fecha, descripcion, urgencia, riesgosSeleccionados);
    }
}
