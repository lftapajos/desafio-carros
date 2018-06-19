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
    
    //Download dos dados dos carros no formato Json da API
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
    
    //Download dos dados dos detalhes do carro selecionado no formato Json da API
    func downloadDetailCar(_ car: CarsModel, complete: @escaping DownloadComplete) {
        
        //Carrega a API com os Carros
        let apiCall = self.fetchDetailsCar(car.id!)
        apiCall.then {
            car -> Void in
            
            self._carsList.append(car)
            complete()
        }.catch { error
                -> Void in
        }
    }
    
    
    //Salva os dados do carro
    func addCar(_ car: CarsModel, complete: @escaping AddComplete) {
        
        //Adiciona Carro ao Realm
        let confirm = CarRealmModel().addCar(car)
        
        //Confirma registro
        if (confirm) {
            complete()
        }
        complete()
    }
    
    //Carrega dados dos carros
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
                    //print(responseString)
                    
                    //Conversão necessária devido à formatação do JSON
                    let json = "{\"results\": \(responseString)}"
                    //print(json)
                    let carsResponse = CarResponse(JSONString:"\(json)")!
                    fullfil(carsResponse.carModelList!)
                case .failure(let error):
                    print(error)
                    reject(error)
                }
            }
        }
    }
    
    //Carrega dados de detalhes do Carro selecionado
    func fetchDetailsCar(_ id: Int) -> Promise<CarsModel> {
        let urlString = "\(API_CARROS_URL)\(id)"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return Promise<CarsModel> {
            fullfil,reject -> Void in
            return Alamofire.request(urlString).responseString {
                response in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch (response.result) {
                case .success(let responseString):
                    //print(responseString)
                    
                    //Conversão necessária devido à formatação do JSON
                    let json = "{\"results\": \(responseString)}"
                    //print(json)
                    let carsResponse = CarResponse(JSONString:"\(json)")!
                    fullfil(carsResponse.carModelDetail!)
                case .failure(let error):
                    print(error)
                    reject(error)
                }
            }
        }
    }
    
}
