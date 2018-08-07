//
//  AJModalViewController.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

public class AJModalViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var height: CGFloat = 0
    var width: CGFloat = 0
    var dismissOnTouch: Bool = true
    
    var viewController: UIViewController = UIViewController()
    private let containerView = UIView()
    
    private let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    private let blurEffectView = UIVisualEffectView()
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.blurEffectView.removeFromSuperview()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        self.addChildViewController(viewController)
        
        containerView.layer.cornerRadius = 3
        containerView.clipsToBounds = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([containerView.heightAnchor.constraint(equalToConstant: height),
                                     containerView.widthAnchor.constraint(equalToConstant: width),])
        
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(viewController.view)
        
        containerView.backgroundColor = UIColor.yellow
        
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        viewController.didMove(toParentViewController: self)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        blurEffectView.effect = self.blurEffect
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        
        if self.dismissOnTouch {
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissController))
            blurEffectView.addGestureRecognizer(tapGesture)
        }
        
        view.addSubview(blurEffectView)
        
        self.view.bringSubview(toFront: containerView)
    }
    
    @objc fileprivate func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static public func show(viewController: UIViewController, height: CGFloat, width: CGFloat, parent: UIViewController, dismissOnTouch: Bool = true) {
        let vc: AJModalViewController = AJModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.height = height
        vc.width = width
        vc.viewController = viewController
        vc.transitioningDelegate = vc
        vc.dismissOnTouch = dismissOnTouch
        parent.present(vc, animated: true, completion: nil)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalHideAnimator()
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalShowAnimator()
    }
    
}
