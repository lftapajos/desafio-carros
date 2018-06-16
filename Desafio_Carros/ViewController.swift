//
//  ViewController.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var carsModel = [CarsModel]()
    var clientsModel = [ClientsModel]()
    
    @IBOutlet weak var carsTableView: UITableView!
    @IBOutlet var carViewModel: CarViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //print("App Path: \(dirPaths)")
        
        self.carViewModel.startloading(self)
        carsTableView.delegate = self
        carsTableView.dataSource = self
        
        //Download dos carros
        downloadCars()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Mostra botão de carrinho de compras
        self.carViewModel.showBucket()
        
        //Adiciona cliente
        self.carViewModel.addClient() {
            
            //Mostra mensagem de cliente inserido
            Alert(controller: self).show(message: "Client add with success!", handler : { action in
                self.navigationController?.popViewController(animated: true)
            })
            
        }
    }
    
    func downloadCars(){
        self.carViewModel.getCars {
            self.carsModel = Array(self.carViewModel.carsList)
            
            self.carViewModel.stopLoading()
            self.carsTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let carCell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: indexPath) as! CarTableViewCell
        carCell.confiqureCarCell(item: self.carsModel[indexPath.row])
        return carCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailCarViewController") as! DetailCarViewController
        
        let car = carsModel[indexPath.row]
        
        controller.carSeleced = [car]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
