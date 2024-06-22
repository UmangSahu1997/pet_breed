//
//  BreedDetailVC.swift
//  PetApp
//
//  Created by Umang Sahu on 21/06/24.
//

import UIKit

class Welcome: Codable {
    let message: [String]?
    let status: String?

    init(message: [String]?, status: String?) {
        self.message = message
        self.status = status
    }
}

class BreedDetailVC: BaseVC {
    var gg = ""
    private var likedPets: [String] = []
    fileprivate var isLiked: [Bool] = []
    private var imgList: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        perticularBreedTblView.delegate = self
        perticularBreedTblView.dataSource = self
        dd()
        registerTableViewCells()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imgList?.enumerated().forEach { (index, name) in
            if isLiked[index] {
                likedPets.append(name)
            }
        }
        var strings = userDefaults.object(forKey: "myKey") as? [String:[String]]
        if strings == nil {
           
            userDefaults.set([gg:likedPets], forKey: "myKey")
        }
        else {
            strings?[gg] = likedPets
            userDefaults.set(strings, forKey: "myKey")
        }
        addFavList(kk: LikedModel(imgURL: likedPets, breed: "kk"))
    }
    
    @IBOutlet weak var perticularBreedTblView: UITableView!
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "BreedWiseTblViewCell",
                                  bundle: nil)
        self.perticularBreedTblView.register(textFieldCell,
                                forCellReuseIdentifier: "BreedWiseTblViewCell")
    }
    
    func dd() {
        let url = URL(string: "https://dog.ceo/api/breed/\(gg)/images")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"  // optional
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print("Error while fetching data:", error)
                return
            }

            guard let data = data else {
                return
            }

        do {
            let posts = try JSONDecoder().decode(Welcome.self, from: data)
            self.imgList = posts.message
            self.isLiked = [Bool](repeating: false, count: posts.message?.count ?? 0)
            var strings = self.userDefaults.object(forKey: "myKey") as? [String:[String]]
            strings?[self.gg]?.forEach({ data in
                if let message = posts.message?.firstIndex(of: data) {
                    self.isLiked[message] = true
                }
            })
            DispatchQueue.main.async {
                self.perticularBreedTblView.reloadData()
            }
            print("User ID:", posts)
            } catch let jsonError {
                print("Failed to decode json", jsonError)
            }

        }
        task.resume()
    }
    
    
}

extension BreedDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imgList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BreedWiseTblViewCell") as? BreedWiseTblViewCell {
            if let imgUrl = URL(string: (imgList?[indexPath.row] ?? "")) {
                cell.petImgView.load(url: imgUrl)
            }
            cell.indexPath = indexPath
            cell.likeDelegate = self
            if isLiked[indexPath.row] {
                cell.likeBtn.backgroundColor = .green
            }
            else {
                cell.likeBtn.backgroundColor = .red
            }
            return cell
        }
        
        return UITableViewCell()
    }
}

extension BreedDetailVC: TodoDelegate {
    func likeBtnTap(for cell: BreedWiseTblViewCell) {
        
        if let indexPath = cell.indexPath {
            if (isLiked[indexPath.row]) {
                isLiked[indexPath.row] = false
            }
            else {
                isLiked[indexPath.row] = true
            }
            perticularBreedTblView.reloadRows(at: [indexPath], with: .automatic)
        }
       
        
        print("hhhh")
    }
}

var imageChache = NSCache<AnyObject, UIImage>()
extension UIImageView {
    func load(url: URL) {
       // var imageChache = NSCache<AnyObject, UIImage>()
        image = nil
        if let imgChashed = imageChache.object(forKey: url.absoluteString as AnyObject) {
            print("yoyo")
            self.image = imgChashed
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageChache.setObject(image, forKey: url.absoluteString as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}
