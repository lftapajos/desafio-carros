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
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSale: UILabel!
    @IBOutlet weak var carImage: RectangleImage!
    @IBOutlet weak var labelModel: UILabel!
    @IBOutlet weak var textViewDescription : UITextView!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var buttonAddCar: UIButton!
    @IBOutlet weak var buttonRemoveCar: UIButton!
    @IBOutlet weak var buttonShowBucket: UIButton!
    
    var carExists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //Mostra loading
        self.detailCarViewModel.startloading(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Verifica se o carro já foi salvo
        let carExists = self.detailCarViewModel.getCarInBucket(car: carSeleced.first!)
        
        if (carExists) {
            self.carExists = true
            
            //Carrega detalhes do carro já existente
            self.detailCarViewModel.setCarDetails(self.carSeleced, controller: self)
                
            //Remove loading
            self.detailCarViewModel.stopLoading()

        } else {
            
            //Recupera e carrega detalhes do carro selecionado
            self.detailCarViewModel.getCar(carSeleced.first!, controller: self) {
                
                //Carrega detalhes do carro baixado
                self.detailCarViewModel.setCarDetails(self.detailCarViewModel.carsList, controller: self)
                
                //Remove loading
                self.detailCarViewModel.stopLoading()
            }
        }
        
       
    }

    //Função para Mostrar cesta de compras
    @IBAction func showBucket(_ sender: Any) {
        self.detailCarViewModel.callBucketViewController(self)
    }
    
    //Função para Adicionar carro na cesta de compras
    @IBAction func addCarBucket(_ sender: Any) {
        self.detailCarViewModel.addCarInBucket(self, initial: self.carExists)
    }
    
    //Função para Remover carro na cesta de compras
    @IBAction func deleteCarBucket(_ sender: Any) {
        self.detailCarViewModel.deleteCarInBucket(self)
    }

    //Função para chamar retorno
    @IBAction func retornar(_ sender: Any) {
        self.detailCarViewModel.callReturnViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
