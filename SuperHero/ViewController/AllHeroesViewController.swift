//
//  ViewController.swift
//  SuperHero
//
//  Created by Andrei on 14.02.23.
//
import MetricKit
import UIKit

class AllHeroesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate, UISearchResultsUpdating {
    
    // MARK: - Properties
    static let cellId =  "cellId"
    let fetchHeroesSize = 20
    private var functionCalled = false
    // backup array
    var heroesArray = [SuperHeroGeneral]()
    // main array used
    var filteredArray: [SuperHeroGeneral] = [] {
        didSet{
            if !self.functionCalled && filteredArray.count == fetchHeroesSize{
                self.correctTheOrderOfLikedHeroes()
            }
        }
    }
    var likedHeroesIndexes = [String]()
    
    // MARK: - UI Elements
    
    lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        let myColl = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myColl.register(MyCell.self, forCellWithReuseIdentifier: AllHeroesViewController.cellId)
        myColl.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        myColl.backgroundColor = .white
        myColl.isScrollEnabled = true
        myColl.isUserInteractionEnabled = true
        myColl.alwaysBounceVertical = true
        myColl.translatesAutoresizingMaskIntoConstraints = false
        return myColl
    }()
    
    var searchBar: UISearchController = {
            let sb = UISearchController()
            sb.searchBar.placeholder = "Enter the movie name"
            sb.searchBar.searchBarStyle = .minimal
            return sb
        }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // check the performances in Organizer for loading the viewController
        mxSignpost(.begin, log: MXMetricManager.allHeroesViewController, name: "AllHeroesViewController")
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout{
            layout.delegate = self
        }
        self.title = "Heroes"
        
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
        
        addViews()
        mxSignpost(.begin, log: MXMetricManager.heroesFetch, name: "heroesFetch")
        fetchHeroes()
        mxSignpost(.begin, log: MXMetricManager.heroesFetch, name: "heroesFetch")
        mxSignpost(.end, log: MXMetricManager.allHeroesViewController, name: "AllHeroesViewController")
    }
    
    // MARK: - ViewController Functions
    func sortArray(x1: [SuperHeroGeneral], x2: [GeneralResponse]) -> [SuperHeroGeneral] {
        var sortedArray = [SuperHeroGeneral]()
        for item in x1 {
            if let _ = x2.firstIndex(where: { $0.id == item.id }) {
                sortedArray.insert(item, at: 0)
            } else {
                sortedArray.append(item)
            }
        }
        return sortedArray
    }
    
    func correctTheOrderOfLikedHeroes() {
        // Code to load the struct again after the view appears.
        functionCalled = true
        let defaults = UserDefaults.standard
        if let likedHeroes = defaults.codable([GeneralResponse].self, forKey: UserDefaultKeys.heroSavedKey) {
            let sortedObjects = sortArray(x1: filteredArray, x2: likedHeroes)
            likedHeroesIndexes = likedHeroes.map({$0.id!})
            filteredArray = sortedObjects
            heroesArray = sortedObjects
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        // Code to save struct before the view disappears.
        let defaults = UserDefaults.standard
        let toBeSavedData = filteredArray.filter{ likedHeroesIndexes.contains($0.id!)}
        defaults.set(codable: toBeSavedData, forKey: UserDefaultKeys.heroSavedKey)
    }
    
    func addViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func fetchHeroes(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        for id in 1...fetchHeroesSize{
            SuperHeroGet.sharedInstance.fetchSuperHeroData(withId: String(id), modelType: SuperHeroGeneral.self, requestType: nil) { result in
                switch result {
                case .success(let character):
                    self.filteredArray.append(character)
                    self.heroesArray.append(character)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc func heartTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let cell = tapGestureRecognizer.view?.superview as? MyCell else { return }
        if cell.heartImageTapped == false{
            cell.heartImageTapped = true
            likedHeroesIndexes.append(cell.heroesCell)
        }else{
            cell.heartImageTapped = false
            likedHeroesIndexes = likedHeroesIndexes.filter({$0 != cell.heroesCell})
        }
    }
    
    // MARK: - UiCollectionView SetUp
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let heroesData = filteredArray[indexPath.row]
        let heroIsLiked = likedHeroesIndexes.contains(where: {$0 == heroesData.id})
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllHeroesViewController.cellId, for: indexPath) as! MyCell
        if let heroId = heroesData.id{
            cell.heroesCell = heroId
        }
        if heroIsLiked {
            cell.heartImageTapped = true
        }else{
            cell.heartImageTapped = false
        }
        cell.imageView.image = ImageCache.sharedInstance.loadImageUsingCacheString(urlString: heroesData.image.url)
        let tapped = UITapGestureRecognizer(target: self, action: #selector(heartTapped(tapGestureRecognizer: )))
        cell.heartImage.addGestureRecognizer(tapped)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 200
        let randomInt = CGFloat.random(in: 0..<100)
        return height + randomInt
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let heroData = filteredArray[indexPath.row]
        let presentHeroPage = SuperheroViewController()
        presentHeroPage.superhero = heroData
        navigationController?.pushViewController(presentHeroPage, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else{ return }
        if !searchController.isActive{
            self.filteredArray = heroesArray
        }else{
            self.filteredArray = heroesArray.filter({$0.name!.contains(query)})
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

extension MXMetricManager {
    static let allHeroesViewController = MXMetricManager.makeLogHandle(category: "allHeroesViewController")
    static let heroesFetch = MXMetricManager.makeLogHandle(category: "heroesFetch")
}
