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
    @IBOutlet weak var buttonRemoveCar: UIButton!
    
    var carsList = [CarsModel]()
    var client = ClientRealmModel()
    var cars = CarRealmModel()
    var bucket = BucketRealmModel()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Recupera Carro
    func getCar(_ car: CarsModel, complete: @escaping DownloadComplete) {
        
        self.apiClient.downloadDetailCar(car) {
            self.carsList = self.apiClient._carsList
            
            //Se não baixar os dados, esconde botões de adicionar e subtrair
            if (self.carsList.first?.quantidade == nil) {
                self.buttonAddCar.isHidden = true
                self.buttonRemoveCar.isHidden = true
            }
            complete()
        }
        
    }
    
    //Verifica se cliente possui itens na cesta de compras
    func getBucket() -> Bool {
        
        //Calcula saldo do cliente por possível cesta de compras
        let actualBucket = bucket.getBucket()
        
        //Saldo atual do cliente
        let cli = client.getClient(EMAIL_CLIENT)
        let newSale = (cli.saldo - actualBucket.valor!)
        self.labelSale.text = "\(Help.shared.formatCoin("pt_BR", valor: newSale))"
        
        //Se os dados do carro forem encontrados
        if (self.carsList.first?.id != nil) {
            
            //Recupera saldo substraido da cesta de compas
            let actualCarBucket = bucket.getCarBucket("\((self.carsList.first?.id)!)")
            
            //Atualiza lista de dados do carro selecionado, com a nova quantidade
            //self.carsList.first!.quantidade! = newQuantity
            
            //Se o carro selecionado está na cesta de compras, mostra botão de remover
            if (actualCarBucket > 0) {
                
                //Nova quantidade em estoque subtraindo a quantidade da cesta de compras
                let newQuantity = ((self.carsList.first?.quantidade)! - actualCarBucket)
                self.labelQuantity.text = "Quantidade: \(newQuantity)"
                
                self.buttonRemoveCar.isHidden = false
            } else {
                self.buttonRemoveCar.isHidden = true
            }
            
        }
        
        //Retorna se existe um carrinho de compras ativo
        return actualBucket.isBucket!
        
    }
    
    //Carrega detalhes do Carro
    func setCarDetails(_ car: [CarsModel]) {
        
        self.carsList = car
        
        //Carrega os detalhes do carro seleciondo
        self.labelTitle.text = car.first?.nome
        
        //Mostra a imagem do carro, caso exista
        if (car.first?.imagem != nil) {
            self.carImage.sd_setImage(with: URL(string: (car.first?.imagem)!))
        }
        
        self.labelModel.text = car.first?.marca
        self.textViewDescription.text = car.first?.descricao

        //Mostra a quantidade em estoque do carro, caso exista
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
            
            //Se foi possível adicionar ou alterar os dados de compro do carro
            if (BucketRealmModel().addClientCars(clientCar: clientCars)) {
                
                //Subtrai a quantidade atual
                carQuantity = (actualQuantity - 1)
                
                //Carrega nova quantidade
                self.carsList.first!.quantidade! = carQuantity
                
                //Verifica se possui um carrinho criado
                if (getBucket()) {
                    
                    //Recupera detalhes do cliente, formata e carrega o saldo atual
                    self.labelQuantity.text = "Quantidade: \(String(describing: carQuantity))"
                    
                }
            }
            
        } else {
            print("Saldo insuficiente!")
        }
        
    }
    
    @IBAction func deleteCarInBucket(_ sender: Any) {
        
        //var carQuantity = 0
        var carPrice = 0.0
        
        //Recupera o ID do Bucket
        let bucketId = BucketRealmModel().verifyBucketExists()
        
        //Quantidade atual no estoque do carro selecionado
        let actualQuantity = self.carsList.first!.quantidade!
        
        //Recupera dados do Cliente
        let client = ClientRealmModel().getClient(EMAIL_CLIENT)
        
        //Saldo atual do cliente
        let actualSale = BucketRealmModel().getBucketSale()
        
        //Verifica se o saldo é menor que saldo inciial do cliente
        if (actualSale < SALE_CLIENT) {
            
            //Recupera o preço de compra do carro
            carPrice = self.carsList.first!.preco!
            
            //Salva os dados do carro para o cliente no carrinho de compras
            let clientCars = ClientCarsModel()
            clientCars.idBucket = bucketId
            clientCars.idClient = client.id
            clientCars.idCar = "\(String(describing: self.carsList.first!.id!))"
            clientCars.quantidade = 1
            clientCars.valor = carPrice
            
            //Se foi possível deletar os dados de compra do carro
            if (BucketRealmModel().deleteClientCars(clientCar: clientCars)) {
                
                //Adiciona a quantidade nova
                let carQuantity = (actualQuantity + 1)
                
                //Carrega nova quantidade
                self.carsList.first!.quantidade! = actualQuantity

                //Verifica se possui um carrinho criado
                if (getBucket()) {
                    
                    //Recupera detalhes do cliente, formata e carrega o saldo atual
                    self.labelQuantity.text = "Quantidade: \(String(describing: actualQuantity))"
                    
                } else {
                    //Recupera detalhes do cliente, formata e carrega o saldo atual
                    self.labelQuantity.text = "Quantidade: \(String(describing: carQuantity))"
                }
            }
        } else {
            print("Saldo insuficiente!")
        }
        
    }
    
    //Mostra loading
    func startloading(_ controller: DetailCarViewController)
    {
        activityIndicator.center = controller.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        controller.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    //Remove loading
    func stopLoading()
    {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}
