package Modelo;

import java.util.List;
import java.util.Arrays;

public class ModeloFrm {

    public List<String> obtenerCiclos() {
        return Arrays.asList("I", "II", "III", "IV", "V");
    }

    public List<String> obtenerSexos() {
        return Arrays.asList("M", "F");
    }

    public List<String> obtenerUrgencias() {
        return Arrays.asList("1", "2", "3");
    }

    public List<String> obtenerSintomas() {
        return Arrays.asList("Dolor de cabeza", "Fiebre", "Tos");
    }

    public List<String> obtenerRiesgos() {
        return Arrays.asList("Asma", "Diabetes", "Hipertensión");
    }
}
