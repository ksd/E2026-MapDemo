// Controller.swift
// Project: MapDemo 
//
// Created by ksd/Kaj Schermer Didriksen on 22/10/2026 at 09.37.
	

import Foundation

@Observable
@MainActor
class Controller {
    private static let randomURL = URL(string: "https://randomuser.me/api/?results=10")!
    var users: [User] = []

    func loadUsers() async throws {
        let (data,_) = try await URLSession.shared.data(from: Controller.randomURL)
        users = try JSONDecoder().decode(RanadomUserData.self, from: data).results
        users.forEach { user in
            print(user.fullname)
        }
    }

    init() {
        Task {
            do {
                try await loadUsers()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
