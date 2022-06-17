//
//  CardMovie.swift
//  Examen Tecnico
//
//  Created by Alejandro Villordo on 16/06/22.
//

import SwiftUI

struct CardMovie: View {
    var img : String
    var name : String
    var ranking : Decimal
    var dateCreate : Date
    var description : String
    
    @State var size:CGSize?
    
    var body: some View {
        VStack(spacing:20) {
            Image(systemName: "photo")
                .font(.system(size: 20,weight: .bold))
            VStack {
                Text(name)
                    .font(.system(size: 12,weight: .bold))
                    .lineLimit(1)
                    .frame(alignment: .leading)
            }
            .padding(.horizontal)
            HStack {
                Text(dateCreate,style: .date)
                    .font(.system(size: 12,weight: .bold))
                
                Image(systemName: "star.fill")
                    .font(.system(size: 8,weight: .bold))
                Text(NSDecimalNumber(decimal: ranking).stringValue)
                    .font(.system(size: 12,weight: .bold))
            }
            
            HStack {
                    Text(description)
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .frame(width: 160, alignment: .leading)
            }
            
            .lineLimit(4)
            
        }
        
        .frame(width: 180, height: 350, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(.gray))
    }
}

struct CardMovie_Previews: PreviewProvider {
    static var previews: some View {
        CardMovie(img: "fff", name: "Luca", ranking: 2.66, dateCreate: Date(), description: "Perro")
    }
}
