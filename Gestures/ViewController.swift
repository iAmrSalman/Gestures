//
//  ViewController.swift
//  Gestures
//
//  Created by Amr Salman on 9/5/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit

struct AppUtility {
  
  static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.orientationLock = orientation
    }
  }
  
  /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
  static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
    
    self.lockOrientation(orientation)
    
    UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
  }
  
}

extension UIImage{
  convenience init(view: UIView) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: (image?.cgImage)!)
  }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if UIDevice.current.userInterfaceIdiom == .phone {
      AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
  }
  
  @IBAction func onAddViewBtnPressed(_ sender: Any) {
    let newView = UIView(frame: CGRect(origin: CGPoint(x: self.view.center.x - 75, y: self.view.center.y - 75), size: CGSize(width: 150, height: 150)))
    
    newView.backgroundColor = getRandomColor()
    
    self.view.addSubview(newView)

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(_:)))
    panGesture.delegate = self
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.handlePinsh(_:)))
    pinchGesture.delegate = self
    let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.handelRotate(_:)))
    rotationGesture.delegate = self
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handelTap(_:)))
    tapGesture.delegate = self
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handelLongPress(_:)))
    longPressGesture.delegate = self
    longPressGesture.minimumPressDuration = 1.0
    
    newView.addGestureRecognizer(panGesture)
    newView.addGestureRecognizer(pinchGesture)
    newView.addGestureRecognizer(rotationGesture)
    newView.addGestureRecognizer(tapGesture)
    newView.addGestureRecognizer(longPressGesture)

  }
  
  @IBAction func onCaptureBtnPressed(_ sender: Any) {
    
    let logoImg = UIImageView(frame: CGRect(origin: CGPoint.init(x: 10, y: self.view.bounds.height - (#imageLiteral(resourceName: "logo").size.height + 10)), size: #imageLiteral(resourceName: "logo").size))
    logoImg.image = #imageLiteral(resourceName: "logo")
    
    UIView.animate(withDuration: 0.0, animations: { 
      self.view.addSubview(logoImg)
    }) { (_) in
      let image = UIImage(view: self.view)
      
      let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
      activityViewController.completionWithItemsHandler = { _ in
        logoImg.removeFromSuperview()
      }
      self.present(activityViewController, animated: true, completion: nil)
    }

  }
  
  @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
    guard let gestureView = sender.view else { return }
    if sender.state == .began || sender.state == .changed {
      self.view.bringSubview(toFront: gestureView)
      let translation = sender.translation(in: self.view)
      gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
      sender.setTranslation(CGPoint.zero, in: self.view)
    }
  }
  
  @IBAction func handlePinsh(_ sender: UIPinchGestureRecognizer) {
    guard let gestureView = sender.view else { return }
    self.view.bringSubview(toFront: gestureView)
    gestureView.transform = gestureView.transform.scaledBy(x: sender.scale, y: sender.scale)
    sender.scale = 1.0
  }
  
  @IBAction func handelRotate(_ sender: UIRotationGestureRecognizer) {
    guard let gestureView = sender.view else { return }
    self.view.bringSubview(toFront: gestureView)
    gestureView.transform = gestureView.transform.rotated(by: sender.rotation)
    sender.rotation = 0.0
  }
  
  @IBAction func handelTap(_ sender: UITapGestureRecognizer) {
    guard let gestureView = sender.view else { return }
    self.view.bringSubview(toFront: gestureView)
  }
  
  @IBAction func handelLongPress(_ sender: UILongPressGestureRecognizer) {
    guard let gestureView = sender.view else { return }
    
    let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    actionsheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
      UIView.animate(withDuration: 0.7, animations: {
        gestureView.center.x += UIScreen.main.bounds.width * 1.5
      }, completion: { (_) in
        gestureView.removeFromSuperview()
      })
    }))
    
    actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    self.present(actionsheet, animated: true, completion: nil)
  }
  
  func getRandomColor() -> UIColor {
    
    let randomRed = CGFloat(drand48())
    let randomGreen = CGFloat(drand48())
    let randomBlue = CGFloat(drand48())
    
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    
  }

}

