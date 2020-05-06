//
//  Glide.swift
//  GlideUI
//
//  Created by Osama Naeem on 24/10/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit

enum State {
      case closed
      case compressed
      case open
  }

class Glide : NSObject, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    private var configuration: GlideConfiguration!
    private weak var parentViewController: UIViewController?
    private var card: (Glideable & UIViewController)?
    private weak var containerView: UIView?
    private weak var cardTopAnchorConstraint: NSLayoutConstraint!
    private var headerHeight: CGFloat?
    private var window = UIWindow()
    private var anotherWindow: UIWindow?
    private let blackView = UIView()
    private var startingConstant : CGFloat = 0
    private var calculatedSegmentHeightsDictionary : [State: CGFloat] = [ : ]
    private var currentState: State = .closed
    private var gestureRecognizer : UIPanGestureRecognizer!
    weak var delegate: GlideDelegate?
    
    var shouldHandleGesture: Bool = true

    init(parentViewController: UIViewController, configuration: GlideConfiguration, card: Glideable & UIViewController) {
        super.init()
        self.parentViewController = parentViewController
        self.configuration = configuration
        self.card = card
        addCardToContainer()
    }
    
    private func addCardToContainer() {
        guard let card = self.card else { return }
        self.containerView = parentViewController?.view
        self.setupPreviewLayer(parentViewController: self.parentViewController!, cardViewController: card)
        
        guard let container = containerView else {
            print("No Parent Container View Available")
            return
        }
        
        self.headerHeight = card.headerHeight
        addChildToContainer(containerView: container, card: card.view)
        self.setupRecognizer(card: card.view)
    }
    
    
    private func setupPreviewLayer(parentViewController: UIViewController, cardViewController: UIViewController) {
        window = UIApplication.shared.keyWindow!
        
        
        blackView.backgroundColor = UIColor.black
        blackView.alpha = 0
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapRecognizer)))
        window.addSubview(cardViewController.view)
        showPopUpIndicator()
        
        
        
    }

    private func addChildToContainer(containerView: UIView, card: UIView) {
        guard let safeAreaLayout = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.height else { return }
        guard let bottomAreaInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else { return }
        
        ///Calculating Segment Heights if Segmentation is enabled in Configuration file
        calculateSegmentHeights()
        
        ///The headerheight is over written if segmentation is enabled
        ///Segmentation closed height then becomes the headerHeight
        let visibleHeight = configuration.segmented ? (calculatedSegmentHeightsDictionary[.closed] ?? 0) : (safeAreaLayout + bottomAreaInset - (self.headerHeight ?? 0))
       
        card.translatesAutoresizingMaskIntoConstraints = false
        
        cardTopAnchorConstraint = card.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: visibleHeight)
        card.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        card.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        card.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
        cardTopAnchorConstraint.isActive = true

    }
    
    private func configureCardSize(parentView: UIView, configuration: GlideConfiguration) -> CGFloat {
        return configuration.concreteDimension.translateView(containerView: parentView, navControllerPresent: true)
     }
    
    private func setupRecognizer(card : UIView) {
        guard let controller = self.card else { return }
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(recognizer: )))
        gestureRecognizer.delegate = self
        card.addGestureRecognizer(gestureRecognizer)
    }
   
    @objc func handleTapRecognizer() {
        dismissCard()
    }
    
    
    func triggerCard() {
        configuration.segmented ? showCard(state: .compressed) : showCard(state: .open)
    }
    func collapseCard() {
        
        self.dismissCard()
    }
    
    func triggerOpenState() {
        self.currentState == .compressed ? showCard(state: .open) : showCard(state: .open)
    }
    
    private func showPopUpIndicator() {
        guard let card = self.card else { return }
        if configuration.popUpIndicator {
            let grayView = UIView()
            let width: CGFloat = 50
            grayView.backgroundColor = .lightGray
            grayView.layer.cornerRadius = 3
            grayView.frame = CGRect(x: (card.view.frame.width / 2) - (width / 2), y: 8, width: width, height: 6)
            card.view.addSubview(grayView)
        }
    }
    
    private func calculateSegmentHeights() {
        guard let safeAreaLayout = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.height else { return }
        guard let bottomAreaInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else { return }
        
        if configuration.segmented {
            let segmentationHeights = configuration.segmentHeightDictionary
            guard let compressedHeight = segmentationHeights[.compressed] else {
                print("No Compressed Heights Available in Configuration File")
                return
            }
            guard let openHeight = segmentationHeights[.open] else {
                print("No Open Heights Available in Configuration File")
                return
            }
            
            guard let closeHeight = segmentationHeights[.closed] else {
                print("No closed Heights Available in Configuration File")
                return
            }
            
            let compressedStateConstraintConstant = (safeAreaLayout + bottomAreaInset - compressedHeight)
            let openStateConstraintConstant = (safeAreaLayout + bottomAreaInset - openHeight)
            let closedStateConstraintConstant = (safeAreaLayout + bottomAreaInset - closeHeight)
            
            calculatedSegmentHeightsDictionary[.compressed] = compressedStateConstraintConstant
            calculatedSegmentHeightsDictionary[.open] = openStateConstraintConstant
            calculatedSegmentHeightsDictionary[.closed] = closedStateConstraintConstant
        }
    }
    

    /// MARK: - Animations
    
    @objc func handlePanRecognizer(recognizer: UIPanGestureRecognizer) {
            guard let safeAreaLayout = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.height else { return }
            guard let bottomAreaInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else { return }
            guard shouldHandleGesture else { return } // KEY STUFF HERE
            guard let container = self.containerView else { return }
            guard let card = self.card else { return }
            
             switch recognizer.state {
                 
             case .began:
                 startingConstant = (cardTopAnchorConstraint?.constant)!
             case .changed:
                 
                 let translationY = recognizer.translation(in: card.view).y
            
                 if self.startingConstant + translationY > 0 {
                   self.cardTopAnchorConstraint!.constant = self.startingConstant + translationY
                    blackView.alpha = dimAlphaWithCardTopConstraint(value: cardTopAnchorConstraint!.constant)
                 }
                      
             case .ended:
                 

                let velocityY = recognizer.velocity(in: card.view).y
                let topAnchorConstant = configuration.segmented ? calculatedSegmentHeightsDictionary[.compressed]! : configureCardSize(parentView: container, configuration: configuration)
             
             if cardTopAnchorConstraint!.constant < topAnchorConstant {
                 if velocityY > 0 {
                     //card moving down
                     showCard(state: .compressed)
                 }else {
                     //card moving up
                     showCard(state: .open)
                 }
                     
                     
             } else if cardTopAnchorConstraint!.constant < (safeAreaLayout) {
                 if velocityY > 0 {
                     //Card moving down
                      showCard(state: .closed)
                 }else {
                     //card moving upwards
                    configuration.segmented ? showCard(state: .compressed) : showCard(state: .open)
                 }
             }else {
                 dismissCard()
             }
                 
             default:
                 break
             }
        }
    
    
    private func showCard(state: State) {
        guard let safeAreaLayout = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.height else { return }
        guard let bottomAreaInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else { return }
      
        guard let card = self.card else { return }
        guard let container = self.containerView else { return }
        
        
        self.window.layoutIfNeeded()
        
        if (configuration.segmented) {
            
            switch state {
            case .compressed:
                guard let compressedSegmentHeight = calculatedSegmentHeightsDictionary[.compressed] else {
                    print("No Compressed Segment Height in Configuration File")
                    return }
                cardTopAnchorConstraint!.constant = compressedSegmentHeight
                
                  
            let showCard = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 1, animations: {  self.window.layoutIfNeeded() })
                showCard.addAnimations {
                    card.view.layer.cornerRadius = 15
                    self.blackView.alpha = 0.4
                 }
                
                showCard.addCompletion { position in
                    switch position {
                    case .end:
                        self.currentState = .compressed
                       // print(self.currentState)
                    default:
                        ()
                    }
                }
                   
                showCard.startAnimation()
                if showCard.isRunning {
                    self.delegate?.glideStateChangingFromOpenToCompress()
                    if let detectedScrollView = detectScrollView() {
                        detectedScrollView.panGestureRecognizer.isEnabled = false
                    }
                  }
                break
                
            case .open:
                guard let openSegmentHeight = calculatedSegmentHeightsDictionary[.open] else {
                    print("No Open Segment Height in Configuration File")
                    return
                }
                cardTopAnchorConstraint.constant = openSegmentHeight
                
                  
                let showCard = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 1, animations: { self.window.layoutIfNeeded()})
                    showCard.addAnimations {
                        card.view.layer.cornerRadius = 15
                        self.blackView.alpha = 0.4
                    }
                
                showCard.addCompletion { position in
                    switch position {
                    case .end:
                        self.currentState = .open
                       // print(self.currentState)
                    default:
                        ()
                    }
                }
                
                showCard.startAnimation()
                break
            
            
            case .closed:
                guard let closedSegmentHeight = calculatedSegmentHeightsDictionary[.closed] else {
                    print("No Closed Segment Height in Configuration File")
                    return
                }
                cardTopAnchorConstraint.constant = closedSegmentHeight
            
              
                let showCard = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 1, animations: { self.window.layoutIfNeeded()})
                
                showCard.addAnimations {
                    card.view.layer.cornerRadius = 0
                    self.blackView.alpha = 0
                }
               
                showCard.addCompletion { position in
                    switch position {
                    case .end:
                        self.currentState = .closed
                        self.delegate?.glideDidClose()
                       // print(self.currentState)
                    default:
                        ()
                    }
                }
                showCard.startAnimation()
                break
            }
            // Segmentation is not enabled
        } else {
            
            switch state {
                
            case .open:
                cardTopAnchorConstraint.constant = configureCardSize(parentView: container, configuration: configuration)
                  
                let showCard = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 1, animations: { self.window.layoutIfNeeded()})

                showCard.addAnimations {
                    card.view.layer.cornerRadius = 15
                    self.blackView.alpha = 0.4
                 }
                   
                showCard.addCompletion { position in
                    switch position {
                    case .end:
                        self.currentState = .open
                    default:
                        ()
                    }
                }
                
                showCard.startAnimation()
                break
            case .compressed:
                //Nothing should take place here!
                fallthrough
                
            case .closed:
            
                cardTopAnchorConstraint.constant = (safeAreaLayout + bottomAreaInset - (self.headerHeight ?? 0))
                
                let dismissCard = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 1, animations: { self.window.layoutIfNeeded()})
                dismissCard.addAnimations {
                    card.view.layer.cornerRadius = 0
                    self.blackView.alpha = 0
                }
                
                dismissCard.addCompletion { position in
                    switch position {
                    case .end:
                        self.currentState = .closed
                    default:
                        ()
                    }
                }
                
                dismissCard.startAnimation()
               
            }
        }
        
        
    }
    

    private func dismissCard() {
        self.window.layoutIfNeeded()
        guard let safeAreaLayout = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.height else { return }
        guard let bottomAreaInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else { return }
        guard let card = self.card else { return }
        
        let dismissConstant = (safeAreaLayout + bottomAreaInset  - (headerHeight ?? 0))
        
        let dismissHeight = configuration.segmented ? (calculatedSegmentHeightsDictionary[.closed] ?? dismissConstant) : dismissConstant
        
        cardTopAnchorConstraint!.constant = dismissHeight
    

        let dismissCard = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 1, animations: {
               self.window.layoutIfNeeded()
        })

             
        // run the animation
        dismissCard.addAnimations {
            card.view.layer.cornerRadius = 0
            self.blackView.alpha = 0
        }
        
        dismissCard.addCompletion { position in
            switch position {
            case .end:
                self.currentState = .closed
                self.delegate?.glideDidClose()
            default:
                ()
            }
        }
        
        shouldHandleGesture = true
        dismissCard.startAnimation()
    }
    
    
    private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
      let fullDimAlpha : CGFloat = 0.4
      
      guard let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
        return fullDimAlpha
      }
      
      let fullDimPosition = (safeAreaHeight + bottomPadding) / 2.0
      
      let noDimPosition = (safeAreaHeight + bottomPadding - (headerHeight ?? 0))
      
      if value < fullDimPosition {
        return fullDimAlpha
      }
    
      if value > noDimPosition {
        return 0.0
      }
        
      return fullDimAlpha - fullDimAlpha * ((value - fullDimPosition) / fullDimPosition)
    }
    
    func detectScrollView() -> UIScrollView? {
        guard let cardViewController = self.card as? UINavigationController else { return nil }
        var detectedScrollView : UIScrollView? = UIScrollView()
        var detectedVC = UIViewController()
        for vc in cardViewController.viewControllers {
            if let vc = vc as? SelectSourceViewController {
                detectedVC = vc
            }
        }
        
        for subview in detectedVC.view.subviews {
          if let view = subview as? UIScrollView {
               detectedScrollView = view
            }
        }
        
        return detectedScrollView
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognzier = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        guard let cardViewController = self.card else { return false}

        guard let detectedScrollView = detectScrollView() else { return false}
        
        let velocity = panGestureRecognzier.velocity(in: cardViewController.view)
        detectedScrollView.panGestureRecognizer.isEnabled = true
        
        if otherGestureRecognizer == detectedScrollView.panGestureRecognizer {
            switch currentState {
            case .compressed:
                detectedScrollView.panGestureRecognizer.isEnabled = false
                return false
            case .closed:
                detectedScrollView.panGestureRecognizer.isEnabled = false
                return false
            case .open:
                if velocity.y > 0 {
                    if detectedScrollView.contentOffset.y > 0.0 {
                        return true
                    }
                    shouldHandleGesture = true
                    detectedScrollView.panGestureRecognizer.isEnabled = false
                    return false
                }else {
                    shouldHandleGesture = false
                    return true
                }
            default:
                ()
            }
        }
        
        return false
    }
    
}

