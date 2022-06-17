//
//  Settings.swift
//  Examen Tecnico
//
//  Created by Alejandro Villordo on 15/06/22.
//

import Foundation


class AppSettings:ObservableObject{
    @Published var request_token : String = ""
    @Published var session_id : String = ""
}
