//
//  APIClient.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class APIClient: NSObject {

    var _carsList = [CarsModel] ()
    
    var carsList: [CarsModel] {
        return _carsList
    }
    
    // to download users data Json from the API
    func downloadCar(complete: @escaping DownloadComplete) {
        
        //Carrega a API com os Carros
        let apiCall = self.fetchCars()
        apiCall.then {
            cars -> Void in
            
            if (cars.count != 0) {
                for car in cars {
                    self._carsList.append(car)
                }
                complete()
            }
        }.catch { error
                -> Void in
        }
    }
    
    //Carrega dados da Cotação do Bitcoin para o dia
    func fetchCars() -> Promise<[CarsModel]> {
        
        let urlString = "\(API_CARROS_URL)"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return Promise<[CarsModel]> {
            fullfil,reject -> Void in
            return Alamofire.request(urlString).responseString {
                response in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch (response.result) {
                case .success(let responseString):
                    print(responseString)
                    
                    //Conversão necessária devido à formatação do JSON
                    let json = "{\"results\": \(responseString)}"
                    print(json)
                    let carsResponse = CarResponse(JSONString:"\(json)")!
                    
                    //let carsResponse = CarResponse(JSONString:"\(responseString)")!
                    fullfil(carsResponse.carModelList!)
                case .failure(let error):
                    print(error)
                    reject(error)
                }
            }
        }
    }
    
}
