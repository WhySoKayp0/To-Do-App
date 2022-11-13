//
//  AddNoteView.swift
//  Notes
//
//  Created by Matthew on 13/11/22.
//

import SwiftUI

struct AddNoteView: View {
    
    @State var text = ""
    
    // To dismiss the view after action has been done
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            TextField("Write a note...", text: $text)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .clipped()
            
            Button(action: postNote){
                Text("Add")
            }
            .padding(8)
        }
    }
    
    // POST request to the API
    func postNote() {
        let params = ["note": text] as [String : Any]
        
        let url = URL(string: "http://localhost:3000/notes")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        catch let error{
            print(error)
        }
        
        // Headers of postman API
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) {data , res, err in
            guard err == nil else {return}
            guard let data = data else {return}
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            }
            catch let error {
                print(error)
            }
        }
        
        task.resume()
        
        self.text = ""
        // To dismiss the view after action has been done
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
