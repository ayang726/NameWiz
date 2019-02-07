//
//  HomeCollectionVC.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-05.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import UIKit

class HomeCollectionVC: UIViewController {

    private let eventsInstance = EventsData.instance
    @IBOutlet weak var greetingsMessage: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    
    let deleteButton = UIButton(type: .custom)

    @IBOutlet weak var collectionViewLongPressOutlet: UILongPressGestureRecognizer!
    
    @IBOutlet weak var tapOutlet: UITapGestureRecognizer!
    
    @IBAction func collectionViewCellLongPressAction(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began{
            let point = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                if let cell = collectionView.cellForItem(at: indexPath) {
                    deleteButton.frame.origin = cell.center
                    deleteButton.addTarget(self, action: #selector(deleteEvent(_:)), for: .touchUpInside)
                    collectionView.addSubview(deleteButton)
                    view.addGestureRecognizer(tapOutlet)
                }
            }
        }
    }
    
    
    @objc func deleteEvent(_ button: UIButton) {
        let point = button.frame.origin
        if let indexPath = collectionView.indexPathForItem(at: point) {
            let _ = EventsData.instance.removeEvent(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            view.removeGestureRecognizer(tapOutlet)
            deleteButton.removeFromSuperview()
        }
    }
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        deleteButton.removeFromSuperview()
        view.removeGestureRecognizer(tapOutlet)
    }
    
    @IBAction func addEventButtonAction(_ sender: UIBarButtonItem) {
        EventsData.instance.addEvent()
        collectionView.reloadData()
        
        
    }
    
    @IBAction func clearDataAction(_ sender: UIBarButtonItem) {
        EventsData.instance.removeAll()
        collectionView.reloadData()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.tintColor = UIColor.white
        deleteButton.backgroundColor = UIColor.red
        deleteButton.sizeToFit()
        deleteButton.layer.cornerRadius = 5
        
//        collectionViewLongPressOutlet.minimumPressDuration = 1.2
    }
    

}

extension HomeCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsInstance.eventsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.CollectionViewIdentifier, for: indexPath) as! HomeCollectionViewCell
        cell.textLabel.text = eventsInstance.getEventTitle(for: indexPath.row)
        cell.textLabel.font = Customisation.Font.MarkerFelt_Thin
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2-5, height: Customisation.CollectionViewHeight)
    }
    
}


extension HomeCollectionVC {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Identifiers.GoToEvents, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.GoToEvents {
            if let destination = segue.destination as? TabViewController, let indexPath = sender as? IndexPath {
                destination.initialPage = indexPath.row
            }
        }
    }
}


