//
//  TabViewController.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-01.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import Tabman
import Pageboy

class TabViewController: TabmanViewController {

    
    private var viewControllers: [EventVC] = [EventVC]()
    var initialPage: Int?
    
    override func viewDidLoad() {
        self.isScrollEnabled = false
        
        self.dataSource = self
        
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.tintColor = UIColor.lightGray
        bar.backgroundColor = UIColor.lightGray
        bar.backgroundView.style = .clear
        
        
        bar.buttons.customize({ (button) in
            let defaultFont = button.font
            button.font = Customisation.Font.MarkerFelt_Thin ?? defaultFont
            button.selectedTintColor = UIColor.black
            button.tintColor = UIColor.darkGray
        })
        
        bar.indicator.tintColor = UIColor.white
        // Add to view
        addBar(bar, dataSource: self, at: .bottom)
        
        loadEventVCs()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadTabVC(_:)), name: .ReloadTabViewController, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(goToNewEvent), name: .AddNewEvent, object: nil)
        
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        goToInitialPage()
    }
    
    func goToInitialPage() {
        if initialPage != nil {
            scrollToPage(.at(index: initialPage!), animated: false)
            initialPage = nil
        }
    }
    
    func loadEventVCs() {
        viewControllers = [EventVC]()
        for (index,event) in EventsData.instance.events.enumerated() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let eventVC = storyboard.instantiateViewController(withIdentifier: "Event") as! EventVC
            
            eventVC.eventID = index
            eventVC.TabVC = self
            viewControllers.append(eventVC)
        }
        reloadData()
    }
    
//    @objc func reloadTabVC (_ notification: Notification) {
//        if let reloadOptions = notification.userInfo?[EventVC.ReloadOptionsKey] as? [EventVC.ReloadOptions]{
//            if reloadOptions.contains(EventVC.ReloadOptions.ReloadTabButtons) {
//                reloadData()
//            }
//            if reloadOptions.contains(EventVC.ReloadOptions.ReloadTabVCs) {
//                loadEventVCs()
//            }
//            if reloadOptions.contains(EventVC.ReloadOptions.GotoLastVC) {
//                scrollToPage(.last, animated: false)
//            }
//        }
//
//    }
    
//    @objc func goToNewEvent() {
//        loadEventVCs()
//        reloadData()
//        scrollToPage(.last, animated: true)
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = viewControllers[index].eventTitle
        return TMBarItem(title: title)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    

}

//extension Notification.Name {
//    static let ReloadTabViewController = Notification.Name("reloadTabViewController")
//    static let AddNewEvent = Notification.Name("addNewEvent")
//}
