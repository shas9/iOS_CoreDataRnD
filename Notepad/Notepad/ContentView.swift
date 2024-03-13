//
//  ContentView.swift
//  Notepad
//
//  Created by Shahwat Hasnaine on 13/3/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.notes.count == 0 {
                    Text("No note saved yet. Press the New Button to create one")
                        .bold()
                        .foregroundStyle(.secondary)
                    
                } else {
                    List {
                        ForEach(viewModel.notes) { note in
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(note.title ?? "Untitled")
                                            .font(.title3)
                                            .lineLimit(1)
                                            .bold()
                                    }
                                    
                                    Text(note.body ?? "")
                                        .lineLimit(1)
                                }
                                Spacer()
                                
                                // fav icon
                                Image(systemName: note.isFavorite ? "star.fill" : "star")
                                    .onTapGesture {
                                        viewModel.toggleFavorite(note: note)
                                    }
                                    .foregroundStyle(note.isFavorite ? .yellow : .secondary)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteNotes(note: note)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                Button("New") {
                    viewModel.showAlert = true
                }
                .alert(viewModel.noteTitle, isPresented: $viewModel.showAlert, actions: {
                    TextField("Title", text: $viewModel.noteTitle)
                    TextField("Body", text: $viewModel.noteBody)
                    Button("Save", action: {
                        viewModel.createNote()
                        viewModel.clearState()
                    })
                    Button("Cancel", role: .cancel, action: { viewModel.clearState() })
                }) {
                    Text("Create a new note")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
