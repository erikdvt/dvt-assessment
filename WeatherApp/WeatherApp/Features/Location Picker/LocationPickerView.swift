import SwiftUI
import GoogleMaps
import CoreLocation

struct LocationPickerView: View {

    let onConfirm: (CLLocationCoordinate2D) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var centreCoordinate: CLLocationCoordinate2D
    @State private var mapError: String?

    init(initialCoordinate: CLLocationCoordinate2D,
        onConfirm: @escaping (CLLocationCoordinate2D) -> Void) {
        self.onConfirm = onConfirm
        _centreCoordinate = State(initialValue: initialCoordinate)
    }

    var body: some View {
        VStack(spacing: 0) {
            GoogleMapView(coordinate: $centreCoordinate, mapError: $mapError)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundStyle(.red)
                        .offset(y: -12)
                }

            if let mapError {
                Text(mapError)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }

            Button("Confirm") {
                onConfirm(centreCoordinate)
                dismiss()
            }
            .padding()
        }
        .navigationTitle("Select Location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct GoogleMapView: UIViewRepresentable {

    @Binding var coordinate: CLLocationCoordinate2D
    @Binding var mapError: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(coordinate: $coordinate, mapError: $mapError)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: coordinate.latitude,
            longitude: coordinate.longitude,
            zoom: 10)
        let options = GMSMapViewOptions()
        options.camera = camera
        options.mapID = nil
        let mapView = GMSMapView(options: options)
        mapView.mapType = .normal
        mapView.isOpaque = true
        mapView.backgroundColor = .systemBackground
        mapView.delegate = context.coordinator
        mapView.setMinZoom(1, maxZoom: 20)
        mapView.moveCamera(GMSCameraUpdate.setCamera(camera))
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {}

    final class Coordinator: NSObject, GMSMapViewDelegate {

        private let coordinate: Binding<CLLocationCoordinate2D>
        private let mapError: Binding<String?>

        init(coordinate: Binding<CLLocationCoordinate2D>, mapError: Binding<String?>) {
            self.coordinate = coordinate
            self.mapError = mapError
        }

        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            coordinate.wrappedValue = position.target
        }
    }
}
