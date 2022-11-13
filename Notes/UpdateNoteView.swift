//
//  UpdateNoteView.swift
//  Notes
//
//  Created by Matthew on 13/11/22.
//

import SwiftUI

struct UpdateNoteView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var text: String
    @Binding var noteId: String
    
    var body: some View {
        HStack {
            TextField("Update a note...", text: $text)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .clipped()
            
            // When button is pressed it will be trigger the function below. Update Note
            Button(action: updateNote){
                Text("Update")
            }
            .padding(8)
        }
    }
    
    // Function to update note
    func updateNote() {
        let params = ["note": text] as [String : Any]
        
        let url = URL(string: "http://localhost:3000/notes/\(noteId)")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        
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
        
        // Either text or note . Need to check
        self.text = ""
        // To dismiss the view after action has been done
        presentationMode.wrappedValue.dismiss()
    }
}

