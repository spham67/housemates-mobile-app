//
//  TaskSelectionVIew.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/10/23.
//

import SwiftUI

struct TaskSelectionView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Top part with a different background color
                Color(red: 0.439, green: 0.298, blue: 1.0)
                    .frame(width: 400, height: 120)
                    .overlay(
                        Text("Add Task")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.white)
                )
                
                // Search bar placeholder
                TextField("Search for a template...", text: .constant(""))
                    .font(.system(size: 20))
                    .padding(13)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(width: 370)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        Text("Housework")
                            .font(.system(size: 12))
                            .bold()
                        ForEach(0..<hardcodedHouseworkTaskData.count, id: \.self) { i in
                            if i % 3 == 0 {
                                HStack {
                                    ForEach(0..<min(3, hardcodedHouseworkTaskData.count - i), id: \.self) { j in
                                        TaskSelectionBox(taskIconString: hardcodedHouseworkTaskData[i + j].taskIcon, taskName: hardcodedHouseworkTaskData[i + j].taskName)
                                    }
                                }
                            }
                        }
                        Text("Indoor")
                            .font(.system(size: 12))
                            .bold()
                        ForEach(0..<hardcodedIndoorTaskData.count, id: \.self) { i in
                            if i % 3 == 0 {
                                HStack {
                                    ForEach(0..<min(3, hardcodedIndoorTaskData.count - i), id: \.self) { j in
                                        TaskSelectionBox(taskIconString: hardcodedIndoorTaskData[i + j].taskIcon, taskName: hardcodedIndoorTaskData[i + j].taskName)
                                    }
                                }
                            }
                        }
                        Text("Outdoor")
                            .font(.system(size: 12))
                            .bold()
                        ForEach(0..<hardcodedOutdoorTaskData.count, id: \.self) { i in
                            if i % 3 == 0 {
                                HStack {
                                    ForEach(0..<min(3, hardcodedOutdoorTaskData.count - i), id: \.self) { j in
                                        TaskSelectionBox(taskIconString: hardcodedOutdoorTaskData[i + j].taskIcon, taskName: hardcodedOutdoorTaskData[i + j].taskName)
                                    }
                                }
                            }
                        }
                    }
                }.background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 0.8118, green: 0.8196, blue: 1.0))
                )

                // Oval-shaped button at the bottom
                VStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .frame(width: 222, height: 51)
                        .overlay(
                            Text("Add a Custom Task +")
                                .font(.system(size: 18))
                                .bold()
                                .foregroundColor(.white)

                        )
                        .offset(y:-20)
                }
            }
        }.background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.925, green: 0.863, blue: 1.0).opacity(0.25),
                Color(red: 0.619, green: 0.325, blue: 1.0).opacity(0.25)
            ]), startPoint: .top, endPoint: .bottom)
            ).ignoresSafeArea(.all)
    }
}

struct TaskSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TaskSelectionView()
    }
}
