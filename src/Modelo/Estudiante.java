package Modelo;

public class Estudiante {
    private String nombre;
    private String apellido;
    private String fechaNacimiento;
    private String sexo;
    private String ciclo;

    public Estudiante(String nombre, String apellido, String fechaNacimiento, String sexo, String ciclo) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.fechaNacimiento = fechaNacimiento;
        this.sexo = sexo;
        this.ciclo = ciclo;
    }

    public String getNombre() { return nombre; }
    public String getApellido() { return apellido; }
    public String getFechaNacimiento() { return fechaNacimiento; }
    public String getSexo() { return sexo; }
    public String getCiclo() { return ciclo; }
}
