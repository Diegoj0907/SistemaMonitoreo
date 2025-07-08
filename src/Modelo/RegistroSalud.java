package Modelo;

import java.util.List;

public class RegistroSalud {
    private int idEstudiante;
    private String fechaRegistro;
    private String peso;
    private String altura;
    private String temperatura;
    private String presion;
    private List<Integer> sintomasIDs;

    public RegistroSalud(int idEstudiante, String fechaRegistro, String peso, String altura,
                         String temperatura, String presion, List<Integer> sintomasIDs) {
        this.idEstudiante = idEstudiante;
        this.fechaRegistro = fechaRegistro;
        this.peso = peso;
        this.altura = altura;
        this.temperatura = temperatura;
        this.presion = presion;
        this.sintomasIDs = sintomasIDs;
    }

    public int getIdEstudiante() { return idEstudiante; }
    public String getFechaRegistro() { return fechaRegistro; }
    public String getPeso() { return peso; }
    public String getAltura() { return altura; }
    public String getTemperatura() { return temperatura; }
    public String getPresion() { return presion; }
    public List<Integer> getSintomasIDs() { return sintomasIDs; }
}
