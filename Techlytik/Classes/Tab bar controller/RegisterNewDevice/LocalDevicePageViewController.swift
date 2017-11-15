//
//  TutorialPageViewController.swift
//  UIPageViewController Post
//
//  Created by Jeffrey Burt on 12/11/15.
//  Copyright © 2015 Atomic Object. All rights reserved.
//

import UIKit

class LocalDevicePageViewController: UIPageViewController {
    
    weak var localDevicePageDelegate: LocalDevicePageViewControllerDelegate?
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.nextCountViewController(count: "one"),
                self.nextCountViewController(count: "two"),
                self.nextCountViewController(count: "three"),
                self.nextCountViewController(count: "four"),
                self.nextCountViewController(count: "five"),
                self.nextCountViewController(count: "six"),
                self.nextCountViewController(count: "seven")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(viewController: initialViewController)
        }
        
        localDevicePageDelegate?.localDevicePageViewController(localDevicePageViewController: self, didUpdatePageCount: orderedViewControllers.count)
        
    }
    
    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController)
        {
            scrollToViewController(viewController: nextViewController)
            
        }
    }
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController) {
            let _: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            _ = orderedViewControllers[newIndex]
        }
    }
    
    private func nextCountViewController(count: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(count)ViewController")
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyTutorialDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
     func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            
            let index = orderedViewControllers.index(of: firstViewController)
        {
            localDevicePageDelegate?.localDevicePageViewController(localDevicePageViewController: self, didUpdatePageIndex: index)
            
        }
    }
}

// MARK: UIPageViewControllerDataSource
extension LocalDevicePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else
        {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else
        {
            return nil
        }
        
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}

extension LocalDevicePageViewController: UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        notifyTutorialDelegateOfNewIndex()
    }
}

protocol LocalDevicePageViewControllerDelegate: class
{
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func localDevicePageViewController(localDevicePageViewController: LocalDevicePageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func localDevicePageViewController(localDevicePageViewController: LocalDevicePageViewController,
                                    didUpdatePageIndex index: Int)
    
}
