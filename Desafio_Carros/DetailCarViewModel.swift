//
//  DetailCarViewModel.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 15/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class DetailCarViewModel: NSObject {

    @IBOutlet weak var apiClient: APIClient!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSale: UILabel!
    @IBOutlet weak var carImage: RectangleImage!
    @IBOutlet weak var labelModel: UILabel!
    @IBOutlet weak var textViewDescription : UITextView!
    @IBOutlet weak var labelQuantity: UILabel!
    
    var carsList = [CarsModel]()
    var client = ClientRealmModel()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Recupera Carro
    func getCar(_ car: CarsModel, complete: @escaping DownloadComplete) {
        
        self.apiClient.downloadDetailCar(car) {
            self.carsList = self.apiClient._carsList
            complete()
        }
    }
    
    //Carrega detalhes do Carro
    func setCarDetails(_ car: [CarsModel]) {
        
        self.labelTitle.text = car.first?.nome
        self.carImage.sd_setImage(with: URL(string: (car.first?.imagem)!))
        self.labelModel.text = car.first?.marca
        self.textViewDescription.text = car.first?.descricao
        self.labelQuantity.text = "Quantidade: \(String(describing: car.first!.quantidade!))"
        
        let cli = client.getClient("jose@gmail.com")
        self.labelSale.text = "\(Help.shared.formatCoin("pt_BR", valor: cli.saldo))"
        
    }
    
    // start loading
    func startloading(_ controller: DetailCarViewController)
    {
        activityIndicator.center = controller.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        controller.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    // stop loading
    func stopLoading()
    {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}
