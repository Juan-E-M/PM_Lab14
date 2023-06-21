//
//  ViewController.swift
//  lab14
//
//  Created by Juan E. M. on 21/06/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    
    var users = [Users]()
    
    @IBAction func logear(_ sender: Any) {
        let ruta = "http://localhost:3000/usuarios?"
        let usuario = txtUsuario.text!
        let contrasena = txtContrasena.text!
        let url = ruta + "nombre=\(usuario)&clave=\(contrasena)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        validarUsuario(ruta: crearURL) {
            if self.users.count <= 0 {
                print("Nombre de usuario y/o contraseña es incorrecto")
            } else {
                print("Logeo exitoso")
                print(self.users[0])
                self.performSegue(withIdentifier: "segueLogeo", sender: self.users[0])
                for data in self.users {
                    print("id:\(data.id), nombre:\(data.nombre), email:\(data.email)")
                }
            }
        }
    }
    
    
    func validarUsuario (ruta: String, completed: @escaping () -> ()) {
        let url = URL(string:ruta)
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error == nil {
                do{
                    self.users = try JSONDecoder().decode([Users].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print("Error en json")
                }
            }
            
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==
            "segueLogeo" {
            let navigationController = segue.destination as! UINavigationController
            let siguienteVC = navigationController.topViewController as! viewControllerBuscar
            siguienteVC.usuario = sender as? Users
        }
    }


}

