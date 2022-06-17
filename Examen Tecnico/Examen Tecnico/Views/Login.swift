//
//  Login.swift
//  Examen Tecnico
//
//  Created by Alejandro Villordo on 15/06/22.
//

import SwiftUI

struct Login: View {
    @State var username = ""
    @State var password = ""
    
    @State var urlR : URL?
    
    @State var failed = false
    @State var sucess = false
    @State var mesagge = ""
    @StateObject var alertLogin = AlertLogin()
    @State var token = ""
    @StateObject var appSettings = AppSettings()
    
    @State var login = false
    
    var body: some View {
        
        NavigationView{
            LoadingView(isShowing: $login){
                VStack(alignment: .center) {
                    VStack {
                    TextField("username", text: $username)
                        .padding()
                        .frame(width: 300, height: 70, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray))
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                     

                    TextField("password",text: $password)
                        .padding()
                        .frame(width: 300, height: 70, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray))
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    
                    if failed == true {
                        Text(mesagge)
                            .frame(width: 300, alignment: .center)
                    }
                    
                    Button {
                        login(Username: username, Password: password)
                    } label: {
                        Text("Log in")
                    }
                        .frame(width: 300, height: 65, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray))
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    }
                    NavigationLink(destination:Home()
                                    .navigationBarBackButtonHidden(true).navigationBarHidden(true),isActive: $sucess){}
                }
                .padding(.leading,55)
//                .sheet(isPresented: $login) {
//                createSeccion(requestToken: token)
//                } content: {
//                    WebView(url: urlR!)
//                }
            }
        }
        .environmentObject(appSettings)
        .onAppear {
            createToken()
        }
        
    }
    func login(Username:String,Password:String){
        failed = false
        login = true
        
        let params : [String: Any] = ["username" : Username,
                                        "password" : Password,
                                        "request_token" : token]

        
        
        let deseriali = try? JSONSerialization.data(withJSONObject: params)

        
        guard let url2 = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=987eaed5c54b78230a1949db19001a44")else {fatalError("Error")}
        
        var request2 = URLRequest(url:url2)
        request2.httpMethod = "POST"
        request2.httpBody = deseriali
        
        request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request2) { data, response, error in
        
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    let jsonDecoder = JSONDecoder()
                    let login = try jsonDecoder.decode(VMUser.self, from: data)
                    
                    if login.success == true {
                        print("Sucess")
                        self.login = false
                        
                        sucess = true
                        
                    } else {
                        self.login = false
                        self.failed = true
                        alertLogin.message = "Usuario y/o contraseña invalidos"
                    }
                    
                }catch{
                    print("error",error.localizedDescription)
                }
            }   else {
                do{
                    let jsonDecoder = JSONDecoder()
                    let login = try jsonDecoder.decode(VMGeneric.self, from: data!)
                    
                    if login.success == false {
                        failed = true
                        self.login = false
                        mesagge = login.status_message
                        return
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
        dataTask.resume()
    }
    
    func createSeccion(requestToken : String) {
        let params:[String:Any] = ["request_token":requestToken]
        
        let deseriali = try? JSONSerialization.data(withJSONObject: params)

        
        guard let url2 = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=987eaed5c54b78230a1949db19001a44")else {fatalError("Error")}
        
        var request = URLRequest(url:url2)
        request.httpMethod = "POST"
        request.httpBody = deseriali
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            if response.statusCode == 200 {
                
                guard let data = data else {
                    return
                }
                
                do
                {
                    let jsonDEcoder = JSONDecoder()
                    let getId = try? jsonDEcoder.decode(VMSeccion.self, from: data)
                    
                    if getId?.success == true {
                        
                        appSettings.session_id = getId?.session_id ?? ""
                        print(getId?.session_id)
                        login(Username: username, Password: password)
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                }

            }
        }
        dataTask.resume()
    }
    
    func createToken(){
        
        guard let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=987eaed5c54b78230a1949db19001a44") else  {fatalError("error")}
        
        let urlRequest = URLRequest(url:url)
        
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
                    let jsonDecoder = JSONDecoder()
                    let getToken = try jsonDecoder.decode(DataAutentificacion.self, from: data)
                    
                    token = getToken.request_token
                    print(token)
                    
                    let URL = URL(string: "https://www.themoviedb.org/authenticate/\(token)")
                    
                    urlR = URL
                    
//                    Autorizathion(rToke: token)
//                    createSeccion(requestToken: token)
                }catch{
                    print("Error Decodign",error.localizedDescription)
                }
            }
        }
        dataTask.resume()
        appSettings.request_token = token
    }
    
    
    func Autorizathion (rToke:String) {
        
        let params: [String : Any] = ["REQUEST_TOKEN":rToke]
//
        let deseriali = try? JSONSerialization.data(withJSONObject: params)
        
        guard let url = URL(string: "https://www.themoviedb.org/authenticate/\(rToke)?redirect_to=http://www.yourapp.com/approved") else {fatalError("Error URL")}

                
        var request = URLRequest(url:url)
//                request.httpBody = deseriali
//                request.httpMethod = "POST"
        

                let dataTask = URLSession.shared.dataTask(with: request) { Data, response, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        print(error?.localizedDescription)
                        return
                    }

                    if response.statusCode == 200 {
                        guard let error = error else {
                            print(error?.localizedDescription)
                            return
                        }
                        do{
                            createSeccion(requestToken: token)
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                }
        dataTask.resume()
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
