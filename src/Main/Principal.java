package Main;

import Controlador.ControladorPrincipal;
import Vista.FrmPrincipal;

public class Principal {
    public static void main(String[] args) {
        FrmPrincipal vista = new FrmPrincipal();
        ControladorPrincipal controlador = new ControladorPrincipal(vista);
        controlador.iniciar();
    }
}
