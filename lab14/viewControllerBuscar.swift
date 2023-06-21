//
//  viewControllerBuscar.swift
//  lab14
//
//  Created by Juan E. M. on 21/06/23.
//

import UIKit

class viewControllerBuscar: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPeliculas.delegate = self
        tablaPeliculas.dataSource = self

        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tablaPeliculas.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tablaPeliculas.reloadData()
        }

    }
    
    var peliculas = [Peliculas]()
    var usuario: Users?
    
    @IBOutlet weak var txtBuscar: UITextField!
    @IBOutlet weak var tablaPeliculas: UITableView!
    
    @IBAction func btnBuscar(_ sender: Any) {
        let ruta = "http://localhost:3000/peliculas?"
        let nombre = txtBuscar.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        
        if nombre.isEmpty {
            let ruta = "http://localhost:3000/peliculas/"
            self.cargarPeliculas(ruta: ruta) {
                self.tablaPeliculas.reloadData()
            }
        } else {
            cargarPeliculas(ruta: crearURL) {
                if self.peliculas.count <= 0 {
                    self.mostrarAlerta (titulo: "Error", mensaje: "No se encontraron coincidencias para: \(nombre)", accion: "cancel")
                }else {
                    self.tablaPeliculas.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //PETICIONES URL
    func cargarPeliculas(ruta: String, completed: @escaping () -> ()) {
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.peliculas = try JSONDecoder().decode([Peliculas].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("Error en JSON")
                }
            }
        }.resume()
    }
    
    @IBAction func editarUser(_ sender: Any) {
        performSegue(withIdentifier: "segueEditarPerfil", sender: self.usuario)
    }
    
    
    func eliminarPelicula(pelicula: Peliculas, completed: @escaping () -> ()) {
        guard let url = URL(string: "http://localhost:3000/peliculas/\(pelicula.id)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error al eliminar la película: \(error)")
            } else {
                completed()
            }
        }.resume()
    }

    //FUNCIONES TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(peliculas[indexPath.row].nombre)"
        cell.detailTextLabel?.text = "Genero:\(peliculas[indexPath.row].genero) Duracion:\(peliculas[indexPath.row].duracion)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula = peliculas[indexPath.row]
        performSegue(withIdentifier: "segueEditar", sender: pelicula)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let alerta = UIAlertController(title: "Confirmación de eliminación", message: "¿Desea eliminar la película?", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler:     {(UIAlertAction) in
                let pelicula = self.peliculas[indexPath.row]
                self.eliminarPelicula(pelicula: pelicula) {
                    self.peliculas.remove(at: indexPath.row)
                    let ruta = "http://localhost:3000/peliculas/"
                    self.cargarPeliculas(ruta: ruta) {
                        self.tablaPeliculas.reloadData()
                    }
                }
                });
            alerta.addAction(btnOK)
            let btnCANCEL = UIAlertAction(title: "Cancelar", style: .default, handler: nil);
            alerta.addAction(btnCANCEL)
            present(alerta, animated: true, completion: nil)
        }
    }


    
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil); alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==
            "segueEditar" {
            let siguienteVC = segue.destination as! viewControllerAgregar
            siguienteVC.pelicula = sender as? Peliculas
        }
        if segue.identifier ==
            "segueEditarPerfil" {
            let siguienteVC = segue.destination as! editarPerfilViewController
            siguienteVC.usuario = sender as? Users
        }
    }



}
