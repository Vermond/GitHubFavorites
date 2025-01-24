
//
//  FavoriteSearchVC.swift
//  GitHubFavorites
//
//  Created by Jinsu Gu on 1/23/25.
//

import Foundation
import UIKit
import CoreData

class FavoriteSearchVC: UIViewController {
    @IBOutlet weak private var searchText: UITextField!
    @IBOutlet weak var contentsView: UITableView!
    
    private var fetchedResultsController: NSFetchedResultsController<UserData>!
    private var groupedUserData = [String: [UserData]]()
    private var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFetchedResultsController()
    }
    
    @IBAction func searchPerson() {
        setFetchedResultsController()
    }
    
    func setFetchedResultsController() {
        let context = StorageController.shared.context
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "userName", ascending: true)]
        
        if let text = searchText.text, !text.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "userName CONTAINS[c] %@", text)
        }
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            setGroupedData()
        } catch {
            print("Failed to fetch data from VC : \(error.localizedDescription)")
        }
    }
    
    private func setGroupedData() {
        if let objects = fetchedResultsController.fetchedObjects {
            groupedUserData = Dictionary(grouping: objects) { String($0.userName?.prefix(1) ?? "") }
            sectionTitles = groupedUserData.keys.sorted()
        } else {
            groupedUserData = [:]
            sectionTitles = []
        }
        
        contentsView.reloadData()
    }
}

extension FavoriteSearchVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sectionTitles[section]
        return groupedUserData[sectionKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleUserCell", for: indexPath) as? SimpleUserCell {
            let sectionKey = sectionTitles[indexPath.section]
            if let data = groupedUserData[sectionKey]?[indexPath.row] {
                cell.setData(data: data)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension FavoriteSearchVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        setGroupedData()
    }
}
