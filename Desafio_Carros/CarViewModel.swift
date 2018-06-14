//
//  CarViewModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class CarViewModel: NSObject {

    @IBOutlet weak var apiClient: APIClient!
    
    var carsList = [CarsModel]()
    func getCars(complete: @escaping DownloadComplete) {
        
        self.apiClient.downloadCar {
            self.carsList = self.apiClient._carsList
            complete()
        }
    }
    
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return carsList.count
    }
    
    
}
