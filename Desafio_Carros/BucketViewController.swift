//
//  BucketViewController.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 17/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import UIKit

class BucketViewController: UIViewController {

    @IBOutlet var bucketViewModel: BucketViewModel!
    @IBOutlet weak var bucketTableView: UITableView!
    @IBOutlet weak var buttonBucket: UIButton!
    @IBOutlet weak var buttonConfirmBucket: UIButton!
    @IBOutlet weak var labelBucketSale: UILabel!
    
    var bucketModel = [Car]()
    var carList = [CarsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bucketTableView.delegate = self
        bucketTableView.dataSource = self
        
        //Carrega a lista de carros na cesta de compras
        self.bucketModel = Array(self.bucketViewModel.getAllBucket())
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Mostra o saldo atual da cesta de compras
        self.labelBucketSale.text = self.bucketViewModel.showBucketSale()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retornar(_ sender: Any) {
        self.bucketViewModel.callReturnViewController(self)
    }
    
    @IBAction func confirmRemoveBucket(_ sender: Any) {
        self.bucketViewModel.showConfirmAlertRemoveBucket(self, message: MESSAGE_REMOVE_BUCKET, returnPage: false)
        self.bucketTableView.reloadData()
    }
    
    @IBAction func confirmBucket(_ sender: Any) {
        self.bucketViewModel.showConfirmAlertBucket(self, message: MESSAGE_CONFIRM_BUCKET, returnPage: false)
        self.bucketTableView.reloadData()
    }
    
}

extension BucketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bucketCell = tableView.dequeueReusableCell(withIdentifier: "BucketTableViewCell", for: indexPath) as! BucketTableViewCell
        bucketCell.confiqureBucketCell(item: self.bucketModel[indexPath.row])
        return bucketCell
        
    }
    
}
