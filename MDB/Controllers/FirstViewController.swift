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
    var loadedMovies = [Movie]()
    var indxPthItm: Int? = nil

    
    private let sectionInsets = UIEdgeInsets(
        top: 10.0,
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
        loadedMovies = store.loadMoviesAdresses(for: "MovieTitles")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        firstView.searchTxtField.text = ""
        searhQuery = ""
//        firstView.collectionView.collectionViewLayout.invalidateLayout()
        firstView.collectionView.reloadSections(IndexSet(integer: 0)) //NOT WORKING
        firstView.collectionView.reloadData() //NOT WORKING
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "searchSegue":
            if let dvc = segue.destination as? MovieDetailViewController {
                dvc.store = self.store
                if let text = firstView.searchTxtField.text {
                    dvc.searchQuery = text
                } else {
                    dvc.searchQuery = "it"
                }
            }
        case "cellSegue":
            if let dvc = segue.destination as? MovieDetailViewController {
                dvc.store = self.store
                if let item = indxPthItm {
                    dvc.savedMovie = loadedMovies[item]
                }
            }
        case "favoritesSegue":
            if let dVC = segue.destination as? FavoritesViewController {
                dVC.store = self.store
            }
        default:
            print("Im on non")
        }
    }
    
    // _MARK: Custom funcs

    
    // _MARK: IBActions
    @IBAction func searchTapped(_ sender: UIButton) {
        if let query = firstView.searchTxtField.text{
            self.searhQuery = query
        } else {
            self.searhQuery = "it"
        }
    }
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if isEditing {
            sender.title = "Edit"
            setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            setEditing(true, animated: true)
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
        cell.isHighlighted = isEditing
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indxPthItm = indexPath.item
        if let _ = indxPthItm {
            performSegue(withIdentifier: "cellSegue", sender: nil)
        }
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
