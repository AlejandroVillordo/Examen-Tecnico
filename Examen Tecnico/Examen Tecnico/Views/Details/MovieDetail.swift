//
//  MovieDetail.swift
//  Examen Tecnico
//
//  Created by Alejandro Villordo on 16/06/22.
//

import SwiftUI

struct MovieDetail: View {
    var movieTitle : String
    var body: some View {
        Text(movieTitle)
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail(movieTitle: "Hello")
    }
}
