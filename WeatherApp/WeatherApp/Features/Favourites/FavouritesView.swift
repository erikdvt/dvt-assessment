//
//  FavouritesView.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/09/04.
//

import SwiftUI

struct FavouritesView: View {
    @Environment(\.dismiss) private var dismiss
    let favourites: [WeatherFavourite]
    let onDelete: (WeatherFavourite) -> Void

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
                offsets.forEach { onDelete(favourites[$0]) }
            }
        }
        .navigationTitle("Favourites")
    }
}
