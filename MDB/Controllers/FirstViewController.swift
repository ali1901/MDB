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
    var imageStore: ImageStore!
    var searhQuery = ""
    var loadedMovies = [Movie]()
    var indxPthItm: Int? = nil
    
    let mc = MovieCaretaker()
    
    var dictionarySelectedIndecPath: [IndexPath: Bool] = [:]
    
    enum Mode {
      case view
      case select
    }
    
    var mMode: Mode = .view {
      didSet {
        switch mMode {
        case .view:
          for (key, value) in dictionarySelectedIndecPath {
            if value {
                firstView.collectionView.deselectItem(at: key, animated: true) 
            }
          }
          
          dictionarySelectedIndecPath.removeAll()
          
          firstView.editBarBtn.title = "Select" //selectBarButton.title = "Select"
          firstView.deleteBtn.isHidden = true
          //navigationItem.leftBarButtonItem = nil
          firstView.collectionView.allowsMultipleSelection = false //collectionView.allowsMultipleSelection = false
        case .select:
            firstView.editBarBtn.title = "Cancel" //selectBarButton.title = "Cancel"
            firstView.deleteBtn.isHidden = false
          //navigationItem.leftBarButtonItem = deleteBarButton
          firstView.collectionView.allowsMultipleSelection = true //collectionView.allowsMultipleSelection = true
        }
      }
    }
    
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

        firstView.deleteBtn.isHidden = true
        firstView.searchTxtField.clearButtonMode = .whileEditing
        loadedMovies = mc.loadMoviesAdresses(for: "MovieTitles")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        loadedMovies = mc.loadMoviesAdresses(for: "MovieTitles")
        firstView.searchTxtField.text = ""
        searhQuery = ""
        firstView.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "searchSegue":
            if let dvc = segue.destination as? MovieDetailViewController {
                dvc.store = self.store
                dvc.imageStore = self.imageStore
                if let text = firstView.searchTxtField.text {
                    dvc.searchQuery = text
                } else {
                    dvc.searchQuery = "it"
                }
            }
        case "cellSegue":
            if let dvc = segue.destination as? MovieDetailViewController {
                dvc.store = self.store
                dvc.imageStore = self.imageStore
                if let item = indxPthItm {
                    dvc.savedMovie = loadedMovies[item]
                }
            }
        case "favoritesSegue":
            if let dVC = segue.destination as? FavoritesViewController {
                dVC.store = self.store
                dVC.imageStore = self.imageStore
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
        mMode = mMode == .view ? .select : .view
    }
    
    @IBAction func deleteBTN(_ sender: UIButton) {
        for item in dictionarySelectedIndecPath {
            let t = loadedMovies[item.key.item].title
            print(t, "is about to be removed.")
            self.imageStore.deleteImage(forKey: loadedMovies[item.key.item].title)
            self.store.deleteMovie(for: t, index: item.key.item)
            loadedMovies.remove(at: item.key.item)
        }
        print("----")
        firstView.collectionView.reloadData()
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
        
        cell.layer.cornerRadius = 10.0

        let key = loadedMovies[indexPath.item].title
        cell.imageView.image = imageStore.image(forKey: key)
        if cell.imageView.image != nil {
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        }
        cell.titleLabel.text = loadedMovies[indexPath.item].title
        cell.isHighlighted = isEditing
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indxPthItm = indexPath.item
        switch mMode {
        case .view:
          collectionView.deselectItem(at: indexPath, animated: true)
          let item = loadedMovies[indexPath.item]
          performSegue(withIdentifier: "cellSegue", sender: item)
        case .select:
          dictionarySelectedIndecPath[indexPath] = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
      if mMode == .select {
        dictionarySelectedIndecPath[indexPath] = false
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
