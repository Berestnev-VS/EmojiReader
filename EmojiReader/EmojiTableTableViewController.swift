//
//  EmojiTableTableViewController.swift
//  EmojiReader
//
//  Created by Владимир on 14.07.2021.
//

import UIKit

class EmojiTableTableViewController: UITableViewController {
    
    var objects = [
        Emoji(emoji: "⽣", name: "Ключ канси \"Жизнь\"", description: "Используется в Японии и Корее", isFavorite: false),
        Emoji(emoji: "🌌", name: "Ночное небо", description: "empty", isFavorite: true),
        Emoji(emoji: "🕌", name: "Мечеть", description: "empty", isFavorite: false),
        Emoji(emoji: "🏝", name: "Пляж", description: "empty", isFavorite: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Словарь эмоджи??)"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let sourceVC = segue.source as! EditingEmojiTVC
        let emoji = sourceVC.emoji
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            objects[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            let newIndexPath = IndexPath(row: objects.count, section: 0)
            objects.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editEmoji" else { return }
        let indexPath = tableView.indexPathForSelectedRow! //зафиксироавть indexPath по выбранной ячейке
        let emoji = objects[indexPath.row]
        let navigationVC = segue.destination as! UINavigationController
        let edditEmojiVC = navigationVC.topViewController as! EditingEmojiTVC
        edditEmojiVC.emoji = emoji //свойство emoji выведет значения для выбранного emoji по objects
        edditEmojiVC.title = "Edit \"\(edditEmojiVC.emoji.emoji)\""
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
        let object = objects[indexPath.row]//indexPath содержит место нахождения каждой ячейки в массиве(таблице)
        //т.е. достаёт объекты из objects по конкретным местонахождениям (индексам) в массиве
        cell.setOfEmojiCells(object: object)
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        objects.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = objects.remove(at: sourceIndexPath.row)
        objects.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favourite = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done, favourite])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { action, view, completion in
            self.objects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "checkmark")
        
        return action
    }
    
    func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = objects[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Love it") { action, view, completion in
            object.isFavorite = !object.isFavorite
            self.objects[indexPath.row] = object
            completion(true)
        }
        action.backgroundColor = object.isFavorite ? .systemPink : .systemGray
        action.image = object.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        return action
    }

}
