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
    
    var body: some View {
        
        VStack(spacing: 20) {
            largeTextView
            swipableCardView
            actionsGridView
        }
        .onAppear {
            withAnimation(.spring(duration: 0.6, bounce: 0.2)) {
                showActions = true
            }
            
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
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.bg).ignoresSafeArea(.all))
    }
    
    private var largeTextView: some View {
        Text("What you'd like to do with this item?")
            .font(.title)
            .minimumScaleFactor(0.01)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
            .lineLimit(3, reservesSpace: false)
            .foregroundStyle(.white)
            .bold()
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 24))
    
    }
    
    private var swipableCardView: some View {
        ZStack {
            Color(.itemPrimary)
                .cornerRadius(20)
            
            Text(viewModel.item.name)
                .foregroundStyle(.white)
                .frame(alignment: .leading)
                .font(.title)
                .minimumScaleFactor(0.01)
                .fontWeight(.semibold)
                .padding()

            // n
            VStack {
                Spacer() // Pushes the RoundedRectangle to the bottom
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 100, height: 8)
                    .padding(.bottom, 8)// Optional padding if needed
                    .foregroundStyle(Color.black.opacity(0.4))
            }
        }
        .offset(x: 0, y: min(viewOffSet.height + dragOffSet.height, 80))
        .frame(maxHeight: 190)
        .matchedGeometryEffect(id: viewModel.item.id, in: animation)
        .simultaneousGesture(
            DragGesture()
                .onChanged { gesture in
                    guard gesture.translation.height > -100 else {
                        withAnimation(.spring(duration: 0.4)) {
                            viewOffSet = .zero
                            dragOffSet = .zero
                        }
                        return
                    }
                    dragOffSet = gesture.translation
                    
                    guard gesture.translation.height >= 80, !didGesture else { return }
                    
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
    
    private var actionsGridView: some View {
        VStack(spacing: 30) {
            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                GridRow {
                
                    StuffActionView(
                        color: .hilightedItem,
                        icon: Image(systemName: "hand.point.up.left.and.text.fill"),
                        title: "Take action",
                        shortDescription: "Write down actions, schedule them or review them"
                    )
                
                    StuffActionView(
                        color: .contentSecondary,
                        icon: Image(systemName: "checkmark.circle"),
                        title: "Mark as completed",
                        shortDescription: "You already completed this task!"
                    )
                
                    
                }
                .offset(y: showActions ? 0 : 600)
                
                GridRow {
                    StuffActionView(
                        color: .otherItem,
                        icon: Image(systemName: "clock.badge"),
                        title: "Appear another time",
                        shortDescription: "Not for now, I'll probably need to do this later."
                    )
                    
                    StuffActionView(
                        color: .red.opacity(0.8),
                        icon: Image(systemName: "trash.fill"),
                        title: "Move to trash",
                        shortDescription: "When it's not actionable, better delete it"
                    )
            
                }
                .offset(y: showActions ? 0 : 1000)
                
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .zIndex(-1)
        .frame(minHeight: 360)
    }
}


#Preview {
    
    @Previewable @Namespace var animation
    
    return StuffDetailView(viewModel: StuffActionViewModel(item: StuffItem(color: .accent, name: "Something to do")), animation: animation)
}

