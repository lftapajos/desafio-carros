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
    
    var carsList = [CarsModel]()
    var clientRealm = ClientRealmModel()
    var carsRealm = CarRealmModel()
    var bucketRealm = BucketRealmModel()
    
    var carActualQuantity = 0;
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Recupera Carro
    func getCar(_ car: CarsModel, controller: DetailCarViewController, complete: @escaping DownloadComplete) {
        
        self.apiClient.downloadDetailCar(car) {
            self.carsList = self.apiClient._carsList
            print(self.carsList)
            
            //Se não baixar os dados, esconde botões de adicionar e subtrair
            if (self.carsList.first?.quantidade == nil) {
                controller.buttonAddCar.isHidden = true
                controller.buttonRemoveCar.isHidden = true
                controller.buttonShowBucket.isHidden = true
            }
            complete()
        }
    }
    
    //Verifica se cliente possui itens na cesta de compras
    func getBucket(_ controller: DetailCarViewController, initial: Bool) -> Bool {
        
        //Calcula saldo do cliente por possível cesta de compras
        let actualBucket = bucketRealm.getBucket()
        
        //Saldo atual do cliente
        let cli = clientRealm.getClient(EMAIL_CLIENT)
        let newSale = cli.saldo //- actualBucket.valor!)
        controller.labelSale.text = "\(Help.shared.formatCoin("pt_BR", valor: newSale))"
        
        //Se os dados do carro forem encontrados
        if (self.carsList.first?.id != nil) {
            
            //Recupera saldo substraido da cesta de compas
            let actualCarBucket = bucketRealm.getCarBucket("\((self.carsList.first?.id)!)")
            
            //Se o carro selecionado está na cesta de compras, mostra botão de remover
            if (actualCarBucket > 0) {
                
                //Nova quantidade em estoque subtraindo a quantidade da cesta de compras
                if (initial) {
                    self.carActualQuantity = actualCarBucket
                    let newQuantity = ((self.carsList.first?.quantidade)! - actualCarBucket)
                    controller.labelQuantity.text = "Quantidade: \(newQuantity)"
                } else {
                    let newQuantity = ((self.carsList.first?.quantidade)! - 1)
                    controller.labelQuantity.text = "Quantidade: \(newQuantity)"
                }
                
                controller.buttonRemoveCar.isHidden = false
                controller.buttonShowBucket.isHidden = false
            } else {
                controller.buttonRemoveCar.isHidden = true
                controller.buttonShowBucket.isHidden = true
            }
            
        }
        
        //Retorna se existe uma cesta de compras ativa
        return actualBucket.isBucket!
        
    }
    
    //Carrega detalhes do Carro
    func setCarDetails(_ car: [CarsModel], controller: DetailCarViewController) {
        
        self.carsList = car
        
        //Carrega os detalhes do carro seleciondo
        controller.labelTitle.text = car.first?.nome
        
        //Mostra a imagem do carro, caso exista
        if (car.first?.imagem != nil) {
            controller.carImage.sd_setImage(with: URL(string: (car.first?.imagem)!))
        }
        
        controller.labelModel.text = car.first?.marca
        controller.textViewDescription.text = car.first?.descricao

        //Mostra a quantidade em estoque do carro, caso exista
        if (car.first?.quantidade != nil) {
            controller.labelQuantity.text = "Quantidade: \(String(describing: car.first!.quantidade!))"
        }
        
        if (!getBucket(controller, initial: true)) {
            
            //Recupera detalhes do cliente, formata e carrega o saldo atual
            let cli = clientRealm.getClient(EMAIL_CLIENT)
            controller.labelSale.text = "\(Help.shared.formatCoin("pt_BR", valor: cli.saldo))"
        }
    }
    
    //Adiciona carro na cesta de compras
    func addCarInBucket(_ controller: DetailCarViewController, initial: Bool) {
        
        let bucket = Bucket()
        bucket.id = UUID().uuidString
        bucket.status = true
        
        var carQuantity = 0
        var carPrice = 0.0
        
        //Cria e carrega o id do Bucket
        let bucketId = bucketRealm.createBucket(bucket)
        
        //Quantidade atual no estoque do carro selecionado
        let actualQuantity = self.carsList.first!.quantidade!
        
        //Recupera dados do Cliente
        let client = clientRealm.getClient(EMAIL_CLIENT)
        
        //Saldo atual do cliente
        let actualSale = client.saldo
        
        //Verifica se o saldo é maior que zero
        if (actualSale > 0) {
            
            //Recupera o preço de compra do carro
            carPrice = self.carsList.first!.preco!
            
            //Salva os dados do carro para o cliente na cesta de compras
            let clientCars = ClientCarsModel()
            clientCars.idBucket = bucketId
            clientCars.idClient = client.id
            clientCars.idCar = "\(String(describing: self.carsList.first!.id!))"
            clientCars.quantidade = 1
            clientCars.valor = carPrice
            
            //Se foi possível adicionar ou alterar os dados de compra do carro
            if (bucketRealm.addClientCars(clientCar: clientCars, car: self.carsList)) {
                
                //Subtrai a quantidade atual
                carQuantity = (actualQuantity - 1)
                
                //Verifica se possui uma cesta de compras criada
                if (getBucket(controller, initial: initial)) {
                
                    //Carrega nova quantidade
                    self.carsList.first!.quantidade! = carQuantity
                
                } else {
                    
                    //Carrega nova quantidade
                    self.carsList.first!.quantidade! = carQuantity
                    
                    //Recupera detalhes do cliente, formata e carrega o saldo atual
                    controller.labelQuantity.text = "Quantidade: \(String(describing: carQuantity))"
                }
            } else {
                self.showAlert(controller, message: MESSAGE_INSUFFICIENT_FUNDS, returnPage: false)
            }
            
        } else {
            //print("Saldo insuficiente!")
            self.showAlert(controller, message: MESSAGE_INSUFFICIENT_FUNDS, returnPage: false)
        }
        
    }
    
    //Remove carro da cesta de compras
    func deleteCarInBucket(_ controller: DetailCarViewController) {
        
        var carPrice = 0.0
        
        //Recupera o ID do Bucket
        let bucketId = bucketRealm.verifyBucketExists()
        
        //Quantidade atual no estoque do carro selecionado
        let actualQuantity = self.carsList.first!.quantidade!
        
        //Recupera dados do Cliente
        let client = clientRealm.getClient(EMAIL_CLIENT)
        
        //Saldo atual do cliente
        let actualSale = client.saldo //bucketRealm.getBucketSale()
        
        //Verifica se o saldo é menor que saldo incial do cliente
        if (actualSale < SALE_CLIENT) {
            
            //Recupera o preço de compra do carro
            carPrice = self.carsList.first!.preco!
            
            //Salva os dados do carro para o cliente na cesta de compras
            let clientCars = ClientCarsModel()
            clientCars.idBucket = bucketId
            clientCars.idClient = client.id
            clientCars.idCar = "\(String(describing: self.carsList.first!.id!))"
            clientCars.quantidade = 1
            clientCars.valor = carPrice
            
            //Se foi possível deletar os dados de compra do carro
            if (bucketRealm.deleteClientCars(clientCar: clientCars, car: self.carsList)) {
                
                //Adiciona a quantidade nova
                let carQuantity = (actualQuantity + 1)
                
                //Carrega nova quantidade
                self.carsList.first!.quantidade! = actualQuantity

                //Verifica se possui uma cesta de compras criada
                if (getBucket(controller, initial: false)) {
                    
                    //Recupera detalhes do cliente, formata e carrega a quantidade atual
                    controller.labelQuantity.text = "Quantidade: \(String(describing: actualQuantity))"
                    
                } else {
                    //Recupera detalhes do cliente, formata e carrega aquantidade atual
                    controller.labelQuantity.text = "Quantidade: \(String(describing: carQuantity))"
                }
            }
        } else {
            //print("Saldo insuficiente!")
            self.showAlert(controller, message: MESSAGE_INSUFFICIENT_FUNDS, returnPage: false)
        }
        
    }
    
    //Função para verificar se o carro já foi adicionado na cesta de compras
    func getCarInBucket(car: CarsModel) -> Bool {
        
        let carRetorno = bucketRealm.getCarInBucket(car: car)
        
        return carRetorno
    }
    
    //Função para Retornar para a View de lista de carros
    func callReturnViewController(_ controller: DetailCarViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    
    //Função para chamar a View de carrinho
    func callBucketViewController(_ controller: DetailCarViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bucketViewController = storyboard.instantiateViewController(withIdentifier: "BucketViewController") as! BucketViewController
        controller.navigationController?.pushViewController(bucketViewController, animated: true)
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
    
    //Mostra mensagem
    func showAlert(_ controller: DetailCarViewController, message: String, returnPage: Bool) {
        Alert(controller: controller).show(message: message, handler : { action in
            if (returnPage) {
                controller.navigationController?.popViewController(animated: true)
            }
        })
    }
    
}
