//
//  noti.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 10/11/2024.
//

import SwiftUI

struct StuffDetailView: View {
    
    var viewModel: StuffActionViewModel
    var onClose: (() -> Void)?
    let animation: Namespace.ID
    
    @State private var showActions: Bool = false
    @State private var dragOffSet: CGSize = .zero
    @State private var viewOffSet: CGSize = .zero
    @State var didGesture: Bool = false
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        
        let isCompact = UIScreen.main.bounds.height <= 736
        
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                Text("What you'd like to do with this item?")
                    .font(isCompact ? .title : .title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 80)
                    .lineLimit(3, reservesSpace: false)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 24))
                
                ZStack {
                    Color(.itemPrimary)
                        .cornerRadius(20)
                    
                    Text(viewModel.item.name)
                        .foregroundStyle(.white)
                        .frame(alignment: .leading)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                    
                    
                    // Bottom-aligned RoundedRectangle
                    VStack {
                        Spacer() // Pushes the RoundedRectangle to the bottom
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 100, height: 8)
                            .padding(.bottom, 8)// Optional padding if needed
                            .foregroundStyle(Color.black.opacity(0.4))
                    }
                    
                    
                }
                
                .offset(x: 0, y: min(viewOffSet.height + dragOffSet.height, 80))
                .frame(height: isCompact ? 150 : 190)
                .matchedGeometryEffect(id: viewModel.item.id, in: animation)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { gesture in
                            guard gesture.translation.height > -40 else {
                                withAnimation(.spring(duration: 0.4)) {
                                    viewOffSet = .zero
                                    dragOffSet = .zero
                                }
                                return
                            }
                            dragOffSet = gesture.translation
                            
                            guard gesture.translation.height >= 50, !didGesture else { return }
                            
                            let generator = UIImpactFeedbackGenerator(style: .rigid)
                            generator.impactOccurred()
                            
                            didGesture = true
                        }
                    
                        .onEnded { gesture in
                            
                            if gesture.translation.height > 50  {
                                
                                withAnimation(.spring(duration: 1.3)) {
                                    
                                    showActions = false
                                }
                                
                                withAnimation(.spring(duration: 0.1)) {
                                    viewOffSet = .zero
                                    dragOffSet = .zero
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    viewModel.showClosingAnimaiton = false // never show repeating animation again
                                    onClose?()
                                }
                            } else {
                                withAnimation(.spring(duration: 0.4)) {
                                    viewOffSet = .zero
                                    dragOffSet = .zero
                                }
                                didGesture = false
                            }
                        }
                )
                
            }
            
            VStack(spacing: 30) {
                Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                    GridRow {
                        StuffActionView(
                            color: .contentSecondary,
                            icon: Image(systemName: "checkmark.circle"),
                            title: "Do it now",
                            shortDescription: "If this task can be done within two minutes do it now!"
                        )
                        
                        StuffActionView(
                            color: .otherItemColor1,
                            icon: Image(systemName: "clock.badge"),
                            title: "Do it later",
                            shortDescription: "Let this item show up again on another time"
                        )
                        
                    }
                    .offset(y: showActions ? 0 : 600)
                    GridRow {
                        StuffActionView(
                            color: .otherItem,
                            icon: Image(systemName: "calendar.badge.checkmark"),
                            title: "Schedule",
                            shortDescription: "Schedule this item for a date when you want to do it"
                        )
                        
                        StuffActionView(
                            color: .contentPrimary,
                            icon: Image(systemName: "point.3.filled.connected.trianglepath.dotted"),
                            title: "Delegate",
                            shortDescription: "If not for you, delegate it to someone else."
                        )
                    }
                    .offset(y: showActions ? 0 : 1000)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: isCompact ? 340 : 380)
                
                if !isCompact {
                    
                    Button {} label: {
                        ZStack {
                            Color(.black.withAlphaComponent(0.2))
                                .cornerRadius(20)
                            
                            
                            Image(systemName: "xmark.bin")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.red)
                            
                        }
                        .frame(height: 60)
                        
                    }
                    .offset(y: showActions ? 0 : 1400)
                    
                    Spacer()
                }
                
                
            }
            .zIndex(-1)
            
            .onAppear {
                withAnimation(.spring(duration: 0.6, bounce: 0.2)) {
                    showActions = true
                }
            }
        }
        .padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.bg).ignoresSafeArea(.all))
        
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if viewModel.showClosingAnimaiton {
                    withAnimation(
                        Animation.easeInOut(duration: 0.7)
                            .repeatForever(autoreverses: true) // Repeat 3 times
                    ) {
                        viewOffSet.height = 10
                    }
                    
                }
            }
            
        }
    }
}

#Preview {
    
    @Previewable @Namespace var animation
    
    return StuffDetailView(viewModel: StuffActionViewModel(item: StuffItem(color: .accent, name: "Something to do")), animation: animation)
}

