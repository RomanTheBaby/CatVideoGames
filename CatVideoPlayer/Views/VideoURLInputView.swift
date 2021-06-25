//
//  VideoURLInputView.swift
//  CatVideoPlayer
//
//  Created by Roman on 2021-06-24.
//

import SwiftUI


struct VideoURLInputView: View {
    
    
    @Environment(\.presentationMode) private var presentationMode

    
    // MARK: - Private Properties
    
    @State private var input = ""
    @State private var hasURLInClipboard = UIPasteboard.general.hasURLs
    
    private let doneAction: ((URL) -> Void)
    
//    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    
    // MARK: - Init
    
    init(doneAction: @escaping ((URL) -> Void)) {
        self.doneAction = doneAction
    }
    
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Spacer()

            TextField("Enter URL", text: $input)
                .padding()

            Button {
                input = UIPasteboard.general.url?.absoluteString ?? ""
            } label: {
                if let url = UIPasteboard.general.url {
                    Text("\n\(url.absoluteString)\n\n Paste From Clipboard\n")
                } else {
                    Text("Nothing in Clipboard")
                }
            }
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(16)
            .disabled(!hasURLInClipboard)

            Spacer()

            Button("Done") {
                presentationMode.wrappedValue.dismiss()
                
                /// TODO: - Fix force unwrap
                doneAction(URL(string: input)!)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .padding()
        
//        Form {
//            Section {
//                Toggle("Agree to terms and conditions", isOn: $hasURLInClipboard)
//            }
//
//            Section {
//                Button("Continue") {
//                    print("Thank you!")
//                }
//                .disabled(hasURLInClipboard == false)
//            }
//        }
    }
    
}


struct VideoURLInputView_Preview: PreviewProvider {
    static var previews: some View {
        VideoURLInputView() { _ in
            
        }
    }
}
