//
//  editarPerfilViewController.swift
//  lab14
//
//  Created by Juan E. M. on 21/06/23.
//

import UIKit

class editarPerfilViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if usuario != nil {
            txtNombreUsuario.text = usuario!.nombre
            txtEmailUsuario.text = usuario!.email
            txtPasswordUsuario.text = usuario!.clave
        }

        // Do any additional setup after loading the view.
    }
    
    var usuario: Users?
    
    
    @IBOutlet weak var txtNombreUsuario: UITextField!
    @IBOutlet weak var txtEmailUsuario: UITextField!
    @IBOutlet weak var txtPasswordUsuario: UITextField!
    
    @IBAction func actualizarPerfil(_ sender: Any) {
        let nombre = txtNombreUsuario.text!
        let email = txtEmailUsuario.text!
        let password = txtPasswordUsuario.text!
        let datos = ["nombre": "\(nombre)", "clave": "\(password)", "email": "\(email)"] as Dictionary<String, Any>
        let ruta = "http://localhost:3000/usuarios/\(usuario!.id)"
        metodoPUT(ruta: ruta, datos: datos)
            let alerta = UIAlertController(title: "Modificado", message: "Usuario modificado", preferredStyle: .alert)
            let btnOK = UIAlertAction(title:
                                        "Aceptar", style: .default, handler: nil); alerta.addAction(btnOK)
            present(alerta, animated: true, completion: nil)
    }
    
    func metodoPUT (ruta: String, datos: [String:Any]) {
        let url: URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        
        let params = datos
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch{
            //catch exception here
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (data != nil) {
                do{
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print(dict);

                } catch {
                    //catch exception here
                }
            }
        })
        task.resume()
    }

}
