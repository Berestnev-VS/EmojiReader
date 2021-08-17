//
//  EditingEmojiTVC.swift
//  EmojiReader
//
//  Created by Владимир on 15.07.2021.
//

import UIKit

class EditingEmojiTVC: UITableViewController {

    var emoji = Emoji(emoji: "", name: "", description: "", isFavorite: false)
    
    @IBOutlet weak var emojiTF: UITextField!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var descriptionTF: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateSaveButton()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)  //отвечает за скрытие клавиатуры при нажатии по экрану
    }
    
    private func updateSaveButton() {
        let emojiText = emojiTF.text ?? ""
        let nameText = nameTF.text ?? ""
        let descriptionText = descriptionTF.text ?? ""
        saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty
    }
    
    private func updateUI() {
        emojiTF.text = emoji.emoji
        nameTF.text = emoji.name
        descriptionTF.text = emoji.description
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //будет срабатывать перед исп. сигвэя
        super .prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveSegue" else { return }
        let emoji = emojiTF.text ?? ""
        let name = nameTF.text ?? ""
        let description = descriptionTF.text ?? ""
        
        self.emoji = Emoji(emoji: emoji, name: name, description: description, isFavorite: self.emoji.isFavorite)
    }
    
    
}
