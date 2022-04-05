//
//  SearchBooksTableViewController.swift
//  lab05
//
//  Created by Saauren Mankad on 4/4/2022.
//

import UIKit

class SearchBooksTableViewController: UITableViewController, UISearchBarDelegate {
    
    // class properties
    let CELL_BOOK = "bookCell"
    let REQUEST_STRING = "https://www.googleapis.com/books/v1/volumes?q="
    var newBooks = [BookData]()
    var indicator = UIActivityIndicatorView()
    
    
    let MAX_ITEMS_PER_REQUEST = 40
    let MAX_REQUESTS = 10
    var currentRequestIndex: Int = 0
    
    weak var databaseController: DatabaseProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // add a loading indicator view
        
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        databaseController = appDelegate?.databaseController
        
    }
    
    
    func requestBooksNamed(_ bookName: String) async {
        
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "www.googleapis.com"
        searchURLComponents.path = "/books/v1/volumes"
        searchURLComponents.queryItems = [
            
            URLQueryItem(name: "maxResults", value: "\(MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "startIndex", value: "\(currentRequestIndex * MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "q", value: bookName)
        ]
        
        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }
        
        let urlRequest = URLRequest(url: requestURL)
        
        do {
            let  (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            await MainActor.run {
                indicator.stopAnimating()
            }
            
            let decoder = JSONDecoder()
            let volumeData = try decoder.decode(VolumeData.self, from: data)
            
            if let books = volumeData.books {
                await MainActor.run {
                    newBooks.append(contentsOf: books)
                    tableView.reloadData()
                    
                }
                
                if books.count == MAX_ITEMS_PER_REQUEST, currentRequestIndex + 1 < MAX_REQUESTS {

                    currentRequestIndex += 1
                    await requestBooksNamed(bookName)
                }
                
                
            }
            
            
        }
        
        catch let error {
            print(error)
        }
        
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        newBooks.removeAll()
        tableView.reloadData()
        
        
        guard searchBar.text != nil || searchBar.text == "" else {
            return
        }
        
        let searchText = searchBar.text
        
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        
        Task {
            URLSession.shared.invalidateAndCancel()
            currentRequestIndex = 0
            await requestBooksNamed(searchText!)
        }
    }
    

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = newBooks[indexPath.row]
        let _ = databaseController?.addBook(bookData: book)
        navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newBooks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_BOOK, for: indexPath)
        
        let book = newBooks[indexPath.row]
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.authors
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
