//
//  Constant.swift
//  Desafio_Carros
//
//  Created by Luis Felipe Tapajos on 14/06/18.
//  Copyright © 2018 Luis Felipe Tapajos. All rights reserved.
//

import Foundation
import UIKit

//Rota da API
let API_CARROS_URL = "http://desafiobrq.herokuapp.com/v1/carro/"

//Dados de teste do usuário
let NAME_CLIENT = "Jose"
let EMAIL_CLIENT = "jose@gmail.com"
let SALE_CLIENT = 100000.0

//Outras constantes
let SHADOW_GRY: CGFloat = 120.0 / 255.0
typealias DownloadComplete = () -> ()
typealias AddComplete = () -> ()

//Mensagens
let MESSAGE_ADD_SUCCESS = "Client add with success!"
let MESSAGE_INSUFFICIENT_FUNDS = "Insufficient funds!"
let MESSAGE_REMOVE_BUCKET = "Do you want to confirm the deletion of the bucket?"
let MESSAGE_CONFIRM_BUCKET = "Do you want to confirm the payment of the bucket?"
let MESSAGE_BUCKET_REMOVED = "Bucket successfully removed!"
let MESSAGE_BUCKET_CONFIRMED = "Bucket bought successfully!"
let MESSAGE_CONFIRM = "CONFIRM"
let MESSAGE_OK = "OK"
let MESSAGE_CANCEL = "CANCEL"
let MESSAGE_YES = "YES"
let MESSAGE_NO = "NO"
let MESSAGE_ATTENTION = "ATTENTION"
let MESSAGE_MESSAGE = "MESSAGE"
