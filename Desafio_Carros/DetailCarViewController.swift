//
//  DetailCarViewController.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class DetailCarViewController: UIViewController {

    var carSeleced = [CarsModel]()
    
    @IBOutlet var detailCarViewModel: DetailCarViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(carSeleced.first?.nome ?? "Carro")
        
        self.detailCarViewModel.startloading(self)
        
        self.detailCarViewModel.getCar(carSeleced.first!) {
            
            self.detailCarViewModel.setCarDetails(self.detailCarViewModel.carsList)
            self.detailCarViewModel.stopLoading()
        }
        
    }

    @IBAction func retornar(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
