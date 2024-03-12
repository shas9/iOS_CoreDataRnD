/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import CoreData

struct AddFriendView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) var presentation

  @State private var name = ""
  @State private var meetingPlace = ""
  @State private var meetingDate = Date()
  @State private var nameError = false
  @State private var meetingPlaceError = false
  @State var avatarName = "person.circle.fill"
  @State var pickerPresented = false

  var friendId: NSManagedObjectID?
  let viewModel = AddFriendViewModel()

  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section {
            HStack {
              Image(systemName: avatarName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
                .foregroundColor(Color("rw-green"))

              Button {
                withAnimation {
                  pickerPresented = true
                }
              } label: {
                Image(systemName: "pencil.circle")
                  .resizable()
                  .frame(width: 50, height: 50)
              }
            }
          }
          Section("FRIEND INFO") {
            VStack {
              TextField(
                "Name",
                text: $name,
              prompt: Text("Name"))
              if nameError {
                Text("Name is required")
                  .foregroundColor(.red)
              }
            }
            VStack {
              TextField(
                "Place",
                text: $meetingPlace,
              prompt: Text("Meeting Place"))
              if meetingPlaceError {
                Text("Meeting Place is required")
                  .foregroundColor(.red)
              }
            }
            DatePicker(
              "Date",
              selection: $meetingDate)
          }
        }

        Button {
          if name.isEmpty || meetingPlace.isEmpty {
            nameError = name.isEmpty
            meetingPlaceError = meetingPlace.isEmpty
          } else {
            let values = FriendValues(
              name: name,
              meetingPlace: meetingPlace,
              meetingDate: meetingDate,
              avatarName: avatarName)

            viewModel.saveFriend(
              friendId: friendId,
              with: values,
              in: viewContext)
            presentation.wrappedValue.dismiss()
          }
        } label: {
          Text("Save")
            .foregroundColor(.white)
            .font(.headline)
            .frame(maxWidth: 300)
        }
        .tint(Color("rw-green"))
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 5))
        .controlSize(.large)
      }
      .navigationTitle("\(friendId == nil ? "Add Bestie" : "Edit Bestie")")
      Spacer()
    }
    .sheet(isPresented: $pickerPresented) {
      SFSymbolSelectorView(
        isPresented: $pickerPresented,
        selectedSymbolName: $avatarName)
    }
    .onAppear {
      guard
        let objectId = friendId,
        let friend = viewModel.fetchFriend(for: objectId, context: viewContext)
      else {
        return
      }

      meetingPlace = friend.meetingPlace
      name = friend.name
      meetingDate = friend.meetingDate
      avatarName = friend.avatarName
    }
  }
}

struct AddFriendView_Previews: PreviewProvider {
  static var previews: some View {
    AddFriendView()
  }
}
