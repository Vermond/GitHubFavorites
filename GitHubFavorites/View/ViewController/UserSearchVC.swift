//
//  UserSearchVC.swift
//  GitHubFavorites
//
//  Created by Jinsu Gu on 1/23/25.
//

import Foundation
import UIKit

class UserSearchVC: UIViewController {
    @IBOutlet weak private var searchText: UITextField!
    @IBOutlet weak private var contentsView: UITableView!
    
    private var userData: [(name: String, imgPath: String)] = []
    
    @IBAction func searchPerson() {
        if let token = Bundle.main.object(forInfoDictionaryKey: "GITHUB_API_TOKEN") as? String {
            userData.removeAll()
            
            Task { [weak self] in
                await NetworkController.shared.fetchData(urlStr: "https://api.github.com/search/users?q=" + (self?.searchText.text ?? "") + " in:login", token: token) { [weak self] result in
                    switch result {
                    case .success(let data):
                        do {
                            let decodedResponse = try JSONDecoder().decode(GitHubUserModel.self, from: data)
                            
                            for userInfo in decodedResponse.items {
                                self?.userData.append((name: userInfo.login, imgPath: userInfo.avatar_url))
                            }
                            
                            DispatchQueue.main.async {
                                self?.contentsView.reloadData()
                            }
                        } catch {
                            print(error)
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}

extension UserSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleUserCell", for: indexPath) as? SimpleUserCell, userData.count > indexPath.row {
            cell.setData(userName: userData[indexPath.row].name, imgPath: userData[indexPath.row].imgPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
