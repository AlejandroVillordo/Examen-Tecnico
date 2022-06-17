//
//  VMUser.swift
//  Examen Tecnico
//
//  Created by Alejandro Villordo on 15/06/22.
//

import Foundation

class VMUser : Codable {
    var success : Bool
    var request_token : String
    var expires_at : String
}


class DataAutentificacion : Codable {
    var success : Bool
    var request_token : String
    var expires_at : String
}

class VMSeccion:Codable {
    var success : Bool
    var failure : Bool
    var status_code : Int
    var session_id : String
    var status_message :String
}
