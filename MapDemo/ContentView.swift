// ContentView.swift
// Project: MapDemo
//
// Created by ksd/Kaj Schermer Didriksen on 01/10/2026 at 09.50.


import SwiftUI
import MapKit

struct ContentView: View {
    @State private var cameraPosition: MapCameraPosition = .eaaa
    @State private var mapSelection: String?
    @State private var route: MKRoute?
    @State private var travelTime: String?
    @State private var showDetails = false

    @State private var controller = Controller()

    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection){

            Marker("Erhvervsakademi Århus",
                   coordinate: CLLocationCoordinate2D(latitude: 56.119657, longitude: 10.158651)
            ).tag("1")

            Marker(
                "Kajs kontor",
                coordinate: CLLocationCoordinate2D(latitude: 52.51874, longitude: 13.40802)
            ).tag("2")

            ForEach(controller.users) { user in
                Annotation(user.fullname,
                           coordinate: user.MKLocation,
                           anchor: .bottom) {
                    AsyncImage(url: user.picture.thumbnail) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.blue, lineWidth: 4))
                            .shadow(radius: 2)
                    } placeholder: {
                        Color.green
                    }
                }
                           .tag(user.id)
            }

            if let route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 5)
            }
        }

        .onChange(of: mapSelection) { oldValue, newValue in
          //  if newValue != nil && newValue != "1" {
                showDetails.toggle()
          //  }
        }

        .sheet(isPresented: $showDetails) {
            VStack {
                Text(travelTime ?? "Det vil tage lang tid at køre til kajs kontor")
                Button("Vis rute") {
                    fetchRoute(from: CLLocationCoordinate2D(latitude: 56.119657, longitude: 10.158651),
                               to: CLLocationCoordinate2D(latitude: 52.51874, longitude: 13.40802))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.blue.gradient, in: .rect(cornerRadius: 15))
                .padding()
                if let userID = mapSelection {
                    let user = controller.users.first { user in
                        user.id == userID
                    }
                    if let user {
                        Text(user.fullname)
                    }
                }
            }
            .presentationDetents([.height(200)])
            //.interactiveDismissDisabled(true)
        }
    }

    private func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D ) {
        let request = MKDirections.Request()

        request.source = MKMapItem(
            location: CLLocation(
                latitude: source.latitude,
                longitude: source.longitude
            ),
            address: nil
        )
        request.destination = MKMapItem(
            location: CLLocation(
                latitude: destination.latitude,
                longitude: destination.longitude
            ),
            address: nil
        )
        request.transportType = .automobile
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            guard let route else {return}
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.allowedUnits = [.hour, .minute]
            travelTime = formatter.string(from: route.expectedTravelTime)
        }

    }
}

#Preview {
    ContentView()
}




extension MapCameraPosition {
    static var eaaa = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 56.119657, longitude: 10.158651),
            distance: 2000000,
            heading: 0,
            pitch: 0
        ))
}
