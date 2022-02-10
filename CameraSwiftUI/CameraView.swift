//
//  CameraView.swift
//  CameraSwiftUI
//
//  Created by Khayrul on 2/7/22.
//

import SwiftUI

struct CameraView: View {
    @State var camera = CameraModel()
    
    var body: some View {
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            VStack{
                Spacer()
                HStack{
                    Button(action: {camera.takePic()}, label: {
                        ZStack{
                            Circle()
                                .fill(Color.white)
                                .frame(width: 65, height: 65, alignment: .center)
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 75, height: 75)
                        }
                            
                    })
                }
            }
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
