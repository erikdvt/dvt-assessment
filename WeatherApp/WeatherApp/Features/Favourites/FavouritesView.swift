//
//  FavouritesView.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/09/04.
//

import SwiftUI
import SwiftData

struct FavouritesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var favourites: [WeatherFavourite]

    let onSelect: (WeatherFavourite) async -> Void
    
    var body: some View {
        SwiftUI.List {
            ForEach(favourites, id: \.persistentModelID) { favourite in
                Button {
                    Task {
                        await onSelect(favourite)
                        dismiss()
                    }
                } label: {
                    Text(favourite.city)
                }
            }
            .onDelete { offsets in
                offsets.forEach { modelContext.delete(favourites[$0]) }
                try? modelContext.save()
            }
        }
        .navigationTitle("Favourites")
    }
}
