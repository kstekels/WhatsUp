//
//  SettingsView.swift
//  WhatsUp
//
//  Created by Kārlis Štekels on 05/09/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct SettingsConfig {
    var showPhotoOptions: Bool = false
    var sourceType: UIImagePickerController.SourceType?
    var selecetedImage: UIImage?
    var displayName: String = ""
}

struct SettingsView: View {
    
    @EnvironmentObject private var model: Model
    @State private var settingsConfig = SettingsConfig()
    
    @State private var currentPhotoURL: URL? = Auth.auth().currentUser!.photoURL
    
    @FocusState private var isEditing: Bool
    
    var displayName: String {
        guard let currentuser = Auth.auth().currentUser else {
            return "Guest"
        }
        return currentuser.displayName ?? "Guest"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                AsyncImage(url: currentPhotoURL) { image in
                    image.rounded()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .rounded()
                }
                .onTapGesture {
                    settingsConfig.showPhotoOptions = true
                }
                .confirmationDialog("Select", isPresented: $settingsConfig.showPhotoOptions) {
                    Button("Camera") {
                        settingsConfig.sourceType = .camera
                    }
                    Button("Photo Library") {
                        settingsConfig.sourceType = .photoLibrary
                    }
                }
                
                TextField(settingsConfig.displayName, text: $settingsConfig.displayName)
                    .textFieldStyle(.roundedBorder)
                    .focused($isEditing)
                    .textInputAutocapitalization(.never)
                
                Spacer()
                
                Button("Signout") {
                    
                }
            }
            .sheet(item: $settingsConfig.sourceType, content: { sourceType in
                ImagePicker(image: $settingsConfig.selecetedImage, sourceType: sourceType)
            })
            .onChange(of: settingsConfig.selecetedImage, perform: { newImage in
                //resize
                guard let img = newImage,
                      let resizedImage = img.resize(to: CGSize(width: 100, height: 100)),
                      let imageData = resizedImage.pngData()
                else {
                    return
                }
                Task {
                    // upload the image to Firebase Storage to get the url
                    guard let currentuser = Auth.auth().currentUser else { return }
                    let filename = "\(currentuser.uid).png"
                    do {
                        let url = try await Storage.storage().uploadData(for: filename, data: imageData, bucket: .photos)
                        try await model.updatePhotoURL(for: currentuser, photoURL: url)
                        currentPhotoURL = url
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
            .padding()
            .onAppear{
                settingsConfig.displayName = displayName
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let currentUser = Auth.auth().currentUser else {
                            return
                        }
                        Task {
                            do {
                                try await model.updateDisplayName(for: currentUser, displayName: settingsConfig.displayName)
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
        }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Model())
    }
}
