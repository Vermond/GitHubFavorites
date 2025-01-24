//
//  UserSearchVC.swift
//  GitHubFavorites
//
//  Created by Jinsu Gu on 1/23/25.
//

import Foundation
import UIKit
import CoreData

class UserSearchVC: UIViewController {
    @IBOutlet weak private var searchText: UITextField!
    @IBOutlet weak private var contentsView: UITableView!
    
    private var fetchedResultsController: NSFetchedResultsController<UserData>!
    private var userData: [GitHubUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialzeFetchedResultsController()
    }
    
    func initialzeFetchedResultsController() {
        let context = StorageController.shared.context
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "userId", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch data from VC : \(error.localizedDescription)")
        }
    }
    
    @IBAction func searchPerson() {
        if let token = Bundle.main.object(forInfoDictionaryKey: "GITHUB_API_TOKEN") as? String {
            userData.removeAll()
            
            Task { [weak self] in
                await NetworkController.shared.fetchData(urlStr: "https://api.github.com/search/users?q=" + (self?.searchText.text ?? "") + " in:login", token: token) { [weak self] result in
                    switch result {
                    case .success(let data):
                        do {
                            let decodedResponse = try JSONDecoder().decode(GitHubUserModel.self, from: data)
                            
                            self?.userData = decodedResponse.items
                            
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
            cell.setData(data: userData[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension UserSearchVC: NSFetchedResultsControllerDelegate {    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.contentsView.reloadData()
    }
}
