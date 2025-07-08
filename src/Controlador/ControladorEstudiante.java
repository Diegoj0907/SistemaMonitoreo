    package Controlador;

import Modelo.*;

public class ControladorEstudiante {
    EstudianteDAO dao = new EstudianteDAO();

    public int registrar(String nombre, String apellido, String fecha, String sexo, String ciclo) {
        Estudiante e = new Estudiante(nombre, apellido, fecha, sexo, ciclo);
        return dao.insertarEstudiante(e);
    }
}