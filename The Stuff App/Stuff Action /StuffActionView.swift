//
//  noti.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 10/11/2024.
//

import SwiftUI

@Observable
class StuffActionViewModel {
    
    let item: StuffItem
    
    init(item: StuffItem) {
        self.item = item
    }
    
}

struct StuffActionView: View {
    
    var viewModel: StuffActionViewModel
    
    let animation: Namespace.ID
    
    var onClose: (() -> Void)?

    @State private var showActions: Bool = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                
                HStack {
                    Text("What you'd like to do with this item?")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                        .foregroundStyle(.white)
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 24))
                    
                    Button {
                        withAnimation(.spring(duration: 0.6, bounce: 0.2, blendDuration: 0.2)) {
                            showActions = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onClose?()
                        }
                    
                    } label: {
    
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
            
                
                ZStack {
                    Color(.itemPrimary)
                        .cornerRadius(20)
                    
                    Text(viewModel.item.name)
                        .foregroundStyle(.white)
                        .frame(alignment: .leading)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding()
                    
                }
                .frame(height: 200)
                .matchedGeometryEffect(id: viewModel.item.id, in: animation)
            }
            
            VStack(spacing: 0) {
                Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                    GridRow {
                        StuffAction(
                            color: .contentSecondary,
                            icon: Image(systemName: "checkmark.circle"),
                            title: "Do it now",
                            shortDescription: "If this task can be done within two minutes do it now!"
                        )
                        
                        StuffAction(
                            color: .otherItemColor1,
                            icon: Image(systemName: "clock.badge"),
                            title: "Do it later",
                            shortDescription: "Let this item show up again on another time"
                        )
                        
                    }
                    .offset(y: showActions ? 0 : 300)
                    GridRow {
                        StuffAction(
                            color: .otherItem,
                            icon: Image(systemName: "calendar.badge.checkmark"),
                            title: "Schedule",
                            shortDescription: "Schedule this item for a date when you want to do it"
                        )
                        
                        StuffAction(
                            color: .contentPrimary,
                            icon: Image(systemName: "point.3.filled.connected.trianglepath.dotted"),
                            title: "Delegate",
                            shortDescription: "If not for you, delegate it to someone else."
                        )
                    }
                    .offset(y: showActions ? 0 : 800)
                   
                }
                .frame(maxWidth: .infinity, maxHeight: 380)
                
                Spacer()
            }
 
            .onAppear {
              
                    withAnimation(.spring(duration: 0.6, bounce: 0.2, blendDuration: 0.2)) {
                        showActions = true
                    }
                
            }
          
          
            .background(Color(.bg).clipShape(RoundedRectangle(cornerRadius: 20)))
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))

        .background(Color(.bg).ignoresSafeArea(.all))
    }
}


struct StuffAction: View {
    
    let color: Color
    let icon: Image
    let title: String
    let shortDescription: String

    var onTap: (() -> Void)?
    
    var body: some View {
        
        
        ZStack {
            Color(color)
                .clipShape(RoundedRectangle(cornerRadius: 20))
           
            VStack(spacing: 10) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                HStack {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.black)
                    Spacer()
                }
           
                Text(shortDescription)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
             
                }
            
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
        }
        .onTapGesture {
            onTap?()
        }
    }
}



#Preview {
    ContentView()
}

