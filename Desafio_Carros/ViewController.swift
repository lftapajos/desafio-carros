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
    
    @IBOutlet weak var carsTableView: UITableView!
    @IBOutlet var carViewModel: CarViewModel!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startloading()
        carsTableView.delegate = self
        carsTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadDate()
    }
    
    func downloadDate(){
        self.carViewModel.getCars {
            self.carsModel = Array(self.carViewModel.carsList)
            
            self.stopLoading()
            self.carsTableView.reloadData()
        }
    }
    
    func startloading()
    {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    // stop loading
    func stopLoading()
    {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
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
    
}
