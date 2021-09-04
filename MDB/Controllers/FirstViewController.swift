//
//  ViewController.swift
//  MDB
//
//  Created by Ali Safari on 8/24/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var store: MovieStore!
    var searhQuery = ""
    let userDefaults = UserDefaults.standard
    var titles = [String]()
    var loadedMovies = [Movie]()
    var indxPthItm: Int? = nil

    
    private let sectionInsets = UIEdgeInsets(
    top: 50.0,
    left: 20.0,
    bottom: 50.0,
    right: 20.0)
    
    private let itemsPerRow: CGFloat = 2
    
    public var firstView: FirstView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! FirstView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        firstView.searchTxtField.clearButtonMode = .whileEditing
        titles = loadMoviesAdresses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firstView.searchTxtField.text = ""
        searhQuery = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? MovieDetailViewController {
            detailVC.store = self.store
            if segue.identifier == "searchSegue"{ // TRIGGERING THE SEGUE WITH Search BUTTON
                if let text = firstView.searchTxtField.text {
                    detailVC.searchQuery = text
                } else {
                    detailVC.searchQuery = "it"
                }
            } else { // TRIGGERING THE SEGUE WITH COLLECTION VIEW CELLS
                if let item = indxPthItm {
                    detailVC.savedMovie = loadedMovies[item]
                }
            }
        }
    }
    
    // _MARK: Custom funcs
    private func loadMoviesAdresses() -> [String] {
        var titles = [String]()
        let dir = store.documentDirectories
        var docDir = dir.first!
        if let movieTitles = userDefaults.value(forKey: "MovieTitles") {
            titles = movieTitles as! [String]
            for item in titles {
//                print("these are availible: \(item)")
                docDir.appendPathComponent("\(item).plist")
                loadMovies(url: docDir)
                docDir = docDir.deletingLastPathComponent()
//                print ("this the address: \(docDir)")
                //                print("these are availible: \(movie?.year)")
            }
        }
        return titles
    }
    
    private func loadMovies(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let unarchiver = PropertyListDecoder()
            let movie = try unarchiver.decode(Movie.self, from: data)
//            print("i got this: \(movie.title)")
            loadedMovies.append(movie)
        } catch {
            print("Error loading movie from URL: \(error)")
        }        
    }
    
    // _MARK: IBActions
    @IBAction func searchTapped(_ sender: UIButton) {
        if let query = firstView.searchTxtField.text{
            self.searhQuery = query
        } else {
            self.searhQuery = "it"
        }
    }
}

// MARK: -Extentions
extension FirstViewController: UITextFieldDelegate {
// func setTextFiel
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! CollectionViewCell
        store.fetchImage(for: loadedMovies[indexPath.item], with: { (imageResult) in
            switch imageResult {
            case let .success(image):
                OperationQueue.main.addOperation {
                    cell.imageView.image = image
                    cell.activityIndicator.stopAnimating()
                }
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        })
        cell.titleLabel.text = loadedMovies[indexPath.item].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indxPthItm = indexPath.item
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
}

extension FirstViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
}
