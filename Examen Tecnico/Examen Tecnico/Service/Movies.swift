//
//  Movies.swift
//  Examen Tecnico
//
//  Created by Alejandro Villordo on 16/06/22.
//

import Foundation

class DtoMovies : ObservableObject {
    @Published var lstMovies = [DtoDetailMovies]()
}

class DtoDetailMovies : ObservableObject ,Identifiable {
    @Published var idM : Int
    @Published var original_title : String
    @Published var popularity: Decimal
    @Published var release_date : Date
    @Published var poster_path : String
    @Published var overview : String
    
    init(){
        idM  = 0
        original_title = ""
        popularity = 0
        release_date = Date()
        poster_path = ""
        overview = ""
    }
}
