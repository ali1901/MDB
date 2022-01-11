//
//  FavoritesViewController.swift
//  MDB
//
//  Created by Ali Safari on 9/6/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {


    var store: MovieStore!
    var imageStore: ImageStore!
    var movies = [Movie]()
    let mc = MovieCaretaker()
    var index: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        movies = store.loadMoviesAdresses(for: "Favorites") // Loading without caretaker
        movies = mc.loadMoviesAdresses(for: "Favorites") // loading through caretaker

        print("what's the status: \(isEditing)")
        tableView.rowHeight = 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "rowSegue":
            if let nvc = segue.destination as? MovieDetailViewController {
                nvc.store = self.store
                nvc.imageStore = self.imageStore
                if let inx = index {
                    nvc.savedMovie = movies[inx]
                }
            }
        default:
           print("Im on non")
        }
    }

    // MARK: - @IBActions
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        if isEditing {
            sender.title = "Edit"
            setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            setEditing(true, animated: true)
        }
    }
}

extension FavoritesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritesTableViewCell
        store.fetchImage(for: movies[indexPath.row], with: { (imgRes) in
            switch imgRes {
            case let .success(image):
                OperationQueue.main.addOperation {
                    cell.posterImageView.image = image
                }
            case let .failure(er):
                print(er)
            }
        })
        cell.titleLabel.text = movies[indexPath.row].title
        cell.subTLabel.text = movies[indexPath.row].year
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if store.deleteFavoriteMovie(for: "Favorites", with: indexPath.row) {
                movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        let item = movies[indexPath.row]
        performSegue(withIdentifier: "rowSegue", sender: item)
    }
}
