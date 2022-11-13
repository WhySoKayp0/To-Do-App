//
//  ContentView.swift
//  Notes
//
//  Created by Matthew on 13/11/22.
//

import SwiftUI

struct Home: View {
    
    // Using note to populate UI
    // State property will update the UI for every change in the note concurrently
    @State var notes = [Note]()
    
    @State var showAdd = false
    
    @State var showAlert = false
    
    @State var deleteItem: Note?
    
    @State var updateNote = ""
    @State var updateNoteId = ""
    
    @State var isEditMode: EditMode = .inactive
    
    // Delete request alert
    var alert: Alert {
        Alert(title: Text("Delete"),message: Text("Are you sure you want to delete this note?"),primaryButton: .destructive(Text("Delete"), action: deleteNote), secondaryButton: .cancel())
    }
    
    var body: some View {
        
        // NavigationView will allow us to add navigation bar items
        NavigationView {
            // A list is created and it will loop throughout the note array
            // It will iterate through with each note from the struct note
            List(self.notes) { note in
                
                // If edit mode is not pressed. It will remain to show the list
                if (self.isEditMode == .inactive) {
                    Text(note.note)
                    .padding()
                    
                    // Long press gesture
                    .onLongPressGesture {
                        self.showAlert.toggle()
                        deleteItem = note
                    }
                }
                // else it will show the pencil icon which indicates it is about to be edited. 
                else {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.yellow)
                        Text(note.note)
                        .padding()
                        
                    }
                    // note is the object
                    // .note is the string inside the object note
                    .onTapGesture {
                        self.updateNote = note.note
                        self.updateNoteId = note.id
                        self.showAdd.toggle()
                    }
                    
                }
            }
            .alert(isPresented: $showAlert, content: {
                alert
            })
            // Whenever the showAdd property is true. The content will be presented
            // The content refers to the AddNoteView()
            // Whenever the function is called , it will fetchNotes
            .sheet(isPresented: $showAdd, onDismiss: fetchNotes, content: {
                AddNoteView()
            })
            
            .onAppear(perform: {
                fetchNotes()
            })
            .navigationTitle("Notes")
            // Edit and Done Button
            // Interchangable between Edit and Done Button
            .navigationBarItems(leading: Button(action: {
                if (self.isEditMode == .inactive) {
                    self.isEditMode = .active
                }
                else {
                    self.isEditMode = .inactive
                }
            }, label: {
                if (self.isEditMode == .inactive) {
                    Text("Edit")
                }
                else {
                    Text("Done")
                }
            }),trailing: Button(action: {
                self.showAdd.toggle()
            }, label: {
                Text("Add")
            }).sheet(isPresented: $showAdd, onDismiss: fetchNotes, content: {
                if (self.isEditMode == .inactive) {
                    AddNoteView()
                }
                else {
                    UpdateNoteView(text: $updateNote, noteId: $updateNoteId)
                }
            })
            )
        }
    }
    
    // Get Request
    func fetchNotes() {
        let url = URL(string: "http://localhost:3000/notes")!
        
        // The guard keyword allows us to use the else statement
        // If there is an error with the data, it will break out of the function
        let task = URLSession.shared.dataTask(with: url) { data, res, err in guard let data = data else {return}
            
            do {
                let notes = try JSONDecoder().decode([Note].self, from: data)
                self.notes = notes
            }
            catch {
                print(error)
            }
        }
        task.resume()
        
        if (self.isEditMode == .active) {
            self.isEditMode = .inactive
        }
    }
    
    func deleteNote() {
        
        guard let id = deleteItem?._id else {return}
        
        let url = URL(string: "http://localhost:3000/notes/\(id)")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {data, res, err in
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
        
        fetchNotes()
    }
}

// Objects we will fetch from our API
struct Note: Identifiable, Codable {
    // Database property ID type is string id
    var id: String { _id }
    var _id: String
    var note: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
