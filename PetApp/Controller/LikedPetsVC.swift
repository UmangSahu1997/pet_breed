//
//  LikedPetsVC.swift
//  PetApp
//
//  Created by Umang Sahu on 22/06/24.
//

import UIKit

class LikedPetsVC: BaseVC {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    var likedList: [LikedPet] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let strings = userDefaults.object(forKey: "myKey") as? [String:[String]] {
            var count = 0
            strings.forEach { (key: String, value: [String]) in
                count = count + 1
                value.forEach { imageUrl in
                    likedList.append(LikedPet(imgUrl: imageUrl, breed: key))
                }
            }
        }
        likedPetTblView.dataSource = self
        likedPetTblView.delegate = self
        likedPetTblView.separatorStyle = .none
        registerTableViewCells()
        likedPetTblView.reloadData()
        titleLbl.text = "Favorite Pets"
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "BreedWiseTblViewCell",
                                  bundle: nil)
        self.likedPetTblView.register(textFieldCell,
                                      forCellReuseIdentifier: "BreedWiseTblViewCell")
    }
    @IBOutlet weak var likedPetTblView: UITableView!
}

extension LikedPetsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        likedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BreedWiseTblViewCell") as? BreedWiseTblViewCell {
            if let imgUrl = URL(string: (likedList[indexPath.row].imgUrl ?? "")) {
                cell.petImgView.load(url: imgUrl)
            }
            cell.likeBtn.tintColor = .red
            cell.indexPath = indexPath
            cell.selectionStyle = .none
            cell.likeBtn.setTitle("", for: .normal)
            cell.likeBtn.setImage(UIImage(systemName: "heart.fill", withConfiguration: .none), for: .normal)
            cell.likeDelegate = self
            cell.breedLbl.text = likedList[indexPath.row].breed ?? ""
            return cell
        }
        
        return UITableViewCell()
    }
}

extension LikedPetsVC: TodoDelegate {
    func likeBtnTap(for cell: BreedWiseTblViewCell) {
        
        if let indexPath = cell.indexPath {
            
            var strings = userDefaults.object(forKey: "myKey") as? [String:[String]]
            let fString = strings?[likedList[cell.indexPath?.row ?? 0].breed ?? ""]?.filter { $0 != likedList[cell.indexPath?.row ?? 0].imgUrl ?? "" }
            strings?[likedList[cell.indexPath?.row ?? 0].breed ?? ""] = fString
            userDefaults.set(strings, forKey: "myKey")
            likedList.remove(at: indexPath.row)
            likedPetTblView.reloadData()
        }
    }
}
