//
//  ViewModel.swift
//  Notepad
//
//  Created by Shahwat Hasnaine on 13/3/24.
//

import Foundation

class ViewModel: ObservableObject {
    // save fetched notes for view loading
    @Published var notes: [Note] = []
    
    let dataService = PersistentContainer.shared
    
    // states
    @Published var showAlert: Bool = false
    @Published var noteTitle: String = ""
    @Published var noteBody: String = ""
    @Published var noteIsFavorite: Bool = false
    
    init() {
        getAllNotes()
    }
    
    func getAllNotes() {
        notes = dataService.read()
    }
    
    func createNote() {
        dataService.create(title: noteTitle, body: noteBody, isFavorite: noteIsFavorite)
        getAllNotes()
    }
    
    func toggleFavorite(note: Note) {
        dataService.update(entity: note, isFavorite: !note.isFavorite)
        getAllNotes()
    }
    
    func deleteNotes(note: Note) {
        dataService.delete(entity: note)
        getAllNotes()
    }
    
    func clearState() {
        showAlert = false
        noteTitle = ""
        noteBody = ""
        noteIsFavorite = false
    }
}
