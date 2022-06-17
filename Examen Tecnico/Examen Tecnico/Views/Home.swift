//
//  Home.swift
//  Examen Tecnico
//
//  Created by Alejandro Villordo on 15/06/22.
//

import SwiftUI

struct Home: View {
    @State var isOpen = false
    
    @State var gDetail = false
    
    @State var Alert = false
    
    @State var LogOut = false
    ///Detele
    @State var textT = ""
    
    @State var lstMovies = [VMMovies]()
    
    @StateObject var dtoMovies = DtoMovies()
    
    @EnvironmentObject var appSettings : AppSettings
    
    ///lazygrild
    let layout : [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            VStack  {
                ScrollView(Axis.Set.vertical, showsIndicators: false) {
                    LazyVGrid(columns: layout){
                        ForEach(dtoMovies.lstMovies) { pr  in
                                
                                Button {
                                    textT = pr.original_title
                                    gDetail = true
                                } label: {
                                    CardMovie(img: pr.poster_path , name: pr.original_title, ranking: pr.popularity, dateCreate: pr.release_date, description: pr.overview)
                                }
                            
                        }
                    }
                    NavigationLink(destination: MovieDetail(movieTitle: textT),isActive: $gDetail) {}
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text("TV Shows"))
            .navigationBarItems(trailing:
            Button(action: {
                isOpen.toggle()
            }, label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18))
            }))
        }
        .actionSheet(isPresented: $isOpen) {
            ActionSheet(title: Text("What do you want to do"), buttons: [.default(Text("View Profiel"),action: {
                
            }),.cancel(Text("Cancel")),.destructive(Text("Log out"),action: {
                LogOut.toggle()
//                logout(idSeccion: "")
            })])
        }
        
        NavigationLink(destination: Login().navigationBarHidden(true).navigationBarBackButtonHidden(true), isActive: $LogOut){}
        .onAppear {
            getMoviesPopular()
        }
    }
    func getMoviesPopular(){
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=987eaed5c54b78230a1949db19001a44&language=en&page=1") else {fatalError("Error url")}
        
        let requestURl = URLRequest(url:url)
        
        let dataTask = URLSession.shared.dataTask(with: requestURl) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }

            if response.statusCode == 200 {
            
                guard let data = data else {
                    return
                }
                
                do{
                    
//                    dtoMovies.lstMovies = [DtoDetailMovies]()
                    
                    let jsonDecoder = JSONDecoder()
                    let getMovies = try jsonDecoder.decode(VMMovies.self, from: data)

                    getMovies.results?.forEach({ geting in
                        
                        let lst = DtoDetailMovies()
                        
                        lst.original_title = geting.original_title ?? "Unknwon"
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM,dd,YYYY"
                        let newDate = dateFormatter.date(from: geting.release_date ?? "")
                        lst.release_date = newDate ?? Date()
                        
                        lst.overview = geting.overview ?? ""
                        lst.popularity = geting.vote_average ?? 0
                        lst.idM = geting.id ?? 0
                        lst.poster_path = geting.poster_path ?? ""
                        
                        dtoMovies.lstMovies.append(lst)
                        
                    })
                    
                } catch{
                    print(error.localizedDescription)
                }
                
            }
        }
        dataTask.resume()
        
    }
    
    func logout (idSeccion:String) {
        let params:[String:Any]  = ["session_id":idSeccion]
        
        let deserialize = try? JSONSerialization.data(withJSONObject: params)
        
        guard let url = URL(string: "https://api.themoviedb.org/3/authentication/session") else {fatalError("Error URL")}
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.httpBody = deserialize
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTsk = URLSession.shared.dataTask(with: request) { data, response, error in
             
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    let jsonDEcoder = JSONDecoder()
                    let logout = try? jsonDEcoder.decode(VMGeneric.self, from: data)
                    
                    if logout?.success == true {
                        /// Bool
                        self.LogOut = true
                    }
                    
                    
                }
                catch{
                    
                }
            }

            Alert = true
            
        }
        dataTsk.resume()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
