package Modelo;

import java.util.List;

public class Alerta {
    private int estudianteID;
    private String fecha, descripcion;
    private int urgencia;
    private List<Integer> riesgos;

    public Alerta(int estudianteID, String fecha, String descripcion, int urgencia, List<Integer> riesgos) {
        this.estudianteID = estudianteID;
        this.fecha = fecha;
        this.descripcion = descripcion;
        this.urgencia = urgencia;
        this.riesgos = riesgos;
    }

    public int getEstudianteID() { return estudianteID; }
    public String getFecha() { return fecha; }
    public String getDescripcion() { return descripcion; }
    public int getUrgencia() { return urgencia; }
    public List<Integer> getRiesgos() { return riesgos; }
}
