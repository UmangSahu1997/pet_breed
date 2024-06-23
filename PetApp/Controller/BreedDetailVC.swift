//
//  BreedDetailVC.swift
//  PetApp
//
//  Created by Umang Sahu on 21/06/24.
//

import UIKit

class BreedDetailVC: BaseVC {
    var breed = ""
    private var likedPets: [String] = []
    fileprivate var isLiked: [Bool] = []
    private var imgList: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        getSpecificBreedList()
        setupTblView()
        titleLbl.text = breed
        registerTableViewCells()
    }
    
    private func setupTblView() {
        perticularBreedTblView.delegate = self
        perticularBreedTblView.dataSource = self
        perticularBreedTblView.separatorStyle = .none
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
            
            userDefaults.set([breed:likedPets], forKey: "myKey")
        }
        else {
            strings?[breed] = likedPets
            userDefaults.set(strings, forKey: "myKey")
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var perticularBreedTblView: UITableView!
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "BreedWiseTblViewCell",
                                  bundle: nil)
        self.perticularBreedTblView.register(textFieldCell,
                                             forCellReuseIdentifier: "BreedWiseTblViewCell")
    }
    
    
    func getSpecificBreedList() {
        if let url = URL(string: "\(ApiConstant.instance.pertiicularBreedUrl)\(breed)/images") {
            httpUtils.getApiData(requestUrl: url, resultType: PerticularBreedList.self) { (result) in
                if result.status == "success" {
                    self.imgList = result.message
                    self.isLiked = [Bool](repeating: false, count: result.message?.count ?? 0)
                    let strings = self.userDefaults.object(forKey: "myKey") as? [String:[String]]
                    strings?[self.breed]?.forEach({ data in
                        if let message = result.message?.firstIndex(of: data) {
                            self.isLiked[message] = true
                        }
                    })
                    DispatchQueue.main.async {
                        self.perticularBreedTblView.reloadData()
                    }
                }
            }
        }
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
            cell.likeBtn.tintColor = .red
            cell.selectionStyle  = .none
            if isLiked[indexPath.row] {
                cell.likeBtn.setTitle("", for: .normal)
                cell.likeBtn.setImage(UIImage(systemName: "heart.fill", withConfiguration: .none), for: .normal)
            }
            else {
                cell.likeBtn.setTitle("", for: .normal)
                cell.likeBtn.setImage(UIImage(systemName: "heart", withConfiguration: .none), for: .normal)
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
    }
}
