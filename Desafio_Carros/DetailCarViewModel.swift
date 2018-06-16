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
    @IBOutlet weak var buttonAddCar: UIButton!
    
    var carsList = [CarsModel]()
    var client = ClientRealmModel()
    var bucket = BucketRealmModel()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Recupera Carro
    func getCar(_ car: CarsModel, complete: @escaping DownloadComplete) {
        
        self.apiClient.downloadDetailCar(car) {
            self.carsList = self.apiClient._carsList
            complete()
        }
    }
    
    //Verifica se cliente possui itens na cesta de compras
    func getBucket() -> Bool {
        let actualBucket = bucket.getBucket()
        
        let cli = client.getClient(EMAIL_CLIENT)
        let newSale = (cli.saldo - actualBucket.valor!)
        self.labelSale.text = "\(Help.shared.formatCoin("pt_BR", valor: newSale))"
        
        return actualBucket.isBucket!
        
    }
    
    //Carrega detalhes do Carro
    func setCarDetails(_ car: [CarsModel]) {
        
        self.carsList = car
        
        //Carrega os detalhes do carro seleciondo
        self.labelTitle.text = car.first?.nome
        
        if (car.first?.imagem != nil) {
            self.carImage.sd_setImage(with: URL(string: (car.first?.imagem)!))
        }
        
        self.labelModel.text = car.first?.marca
        self.textViewDescription.text = car.first?.descricao

        if (car.first?.quantidade != nil) {
            self.labelQuantity.text = "Quantidade: \(String(describing: car.first!.quantidade!))"
        }
        
        if (!getBucket()) {
            //Recupera detalhes do cliente, formata e carrega o saldo atual
            let cli = client.getClient(EMAIL_CLIENT)
            self.labelSale.text = "\(Help.shared.formatCoin("pt_BR", valor: cli.saldo))"
        }
    }
    
    @IBAction func addCarInBucket(_ sender: Any) {
        
        let bucket = Bucket()
        bucket.id = UUID().uuidString
        bucket.status = true
        
        var carQuantity = 0
        var carPrice = 0.0
        
        //Cria e carrega o id do Bucket
        let bucketId = BucketRealmModel().createBucket(bucket)
        //print("bucketId =====> \(bucketId)")
        
        //Quantidade atual no estoque do carro selecionado
        let actualQuantity = self.carsList.first!.quantidade!
        
        //Recupera dados do Cliente
        let client = ClientRealmModel().getClient(EMAIL_CLIENT)
        
        //Saldo atual do cliente
        let actualSale = client.saldo
        
        //Verifica se o saldo é maior que zero
        if (actualSale > 0) {
            
            //Recupera o preço de compra do carro
            carPrice = self.carsList.first!.preco!
            
            //Salva os dados do carro para o cliente no carrinho de compras
            let clientCars = ClientCarsModel()
            clientCars.idBucket = bucketId
            clientCars.idClient = client.id
            clientCars.idCar = "\(String(describing: self.carsList.first!.id!))"
            clientCars.quantidade = 1
            clientCars.valor = carPrice
            
            //Se foi possível adicionar o alterar os dados de compro do carro
            if (BucketRealmModel().addClientCars(clientCar: clientCars)) {
                
                //Subtrai a quantidadeatual
                carQuantity = (actualQuantity - 1)
                
                //Carrega nova quantidade
                self.carsList.first!.quantidade! = carQuantity
                
                //Verifica se possui um carrinho ciado
                if (getBucket()) {
                    
                    //Recupera detalhes do cliente, formata e carrega o saldo atual
                    //self.labelSale.text = "\(Help.shared.formatCoin("pt_BR", valor: client.saldo))"
                    
                    self.labelQuantity.text = "Quantidade: \(String(describing: carQuantity))"
                }
                
            }
            
        } else {
            print("Saldo insuficiente!")
        }
        
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
