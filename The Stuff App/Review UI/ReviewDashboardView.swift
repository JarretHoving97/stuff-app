//
//  ReviewDashboardView.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/11/2024.
//

import SwiftUI


struct ReviewDashboardView: View {
    
    var viewModel: ReviewDashboardViewModel
    
    @State private var presentSheet: Bool = false
    
    init(viewModel: ReviewDashboardViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                taskView
                motivationTaskText
                
                HStack {
                    Text("To do for completion")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                        .font(.title3)
                    
                    
                    Button {
                        presentSheet.toggle()
                       
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
          
                actionsList
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            .sheet(isPresented: $presentSheet) {
                AddStuffItemView(
                    presentSheet: $presentSheet) { name in
                        Task {
                            await viewModel.addNewsTask(description: name)
                        }
                    }
                    .presentationDetents([.height(120)])
        
            }
        }
        .background(Color(.bg))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    var actionsList: some View {
    
        VStack {
            ForEach(viewModel.actions, id: \.self) { action in
                
                ZStack {
                    
                    Color(.itemPrimary)
                    
                    HStack(spacing: 10){
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(action.isCompleted ? .accent : .bg)
                                .frame(width: 20, height: 20)
                            
                            if action.isCompleted {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        VStack {
                            Text(action.description)
                                .foregroundStyle(.white)
                                .strikethrough(action.isCompleted)
                                .font(.body)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                   
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
                    .onTapGesture {
                        
                        var completed = action.isCompleted
                        completed.toggle()
                        
                
                            Task {
                                await viewModel.setTaskCompleted(for: action.id, isCompleted: completed)
                            }
                        
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    var taskView: some View {
        ZStack {
            HStack(spacing: 10){
                
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                
                VStack {
                    Text(viewModel.itemTitle)
                    
                        .foregroundStyle(.white)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
            
                    
                    Text("some subtitle maybe?")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
           
                
                Spacer()
            }

        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    
    private var motivationTaskText: some View {
        Text(viewModel.motivationTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.white)
            .font(.largeTitle)
            .fontWeight(.medium)
            .lineLimit(2, reservesSpace: true)
    }
    
}

#Preview {
    
    var stuffItem = StuffItem(
        color: .purple,
        name: "Plan a meeting with dev team"
    )
    
    stuffItem.actions = MOCK_ACTION_STORE().actions
    
   return ReviewDashboardView(
        viewModel: ReviewDashboardViewModel(
            item: stuffItem,
            actionLoader: MOCK_ACTION_STORE()
        )
    )
}


