//
//  ViewController.swift
//  RedsquareView
//
//  Created by Мах Ol on 3/16/21.
//  Copyright © 2021 Мах Ol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Были мысли сделать все через MVVM, но через Boxing некрасиво, а RX только недавно начал изучать
    //Viper? Слишком много кода писать, да и заполнять нечем особо
    //в итоге решил не выпендриваться и написать просто в контроллере
    
    
    var squareViewWidthConstraint = NSLayoutConstraint()
    var squareViewHeightConstraint = NSLayoutConstraint()
    
    
    var squareView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 2, delay: 1, options: [.repeat, .autoreverse], animations: {
//            self.squareView.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2) После написания этой функции у меня встал вопрос: Как scale влияет на констрейнты? Не приходилось об этом задумываться ранее. И в ходе тестов выяснил, что он их не меняет даже. Вьюшка просто налезает на другую.
    
            self.squareViewHeightConstraint.constant *= 2
            self.squareViewWidthConstraint.constant *= 2
            super.view.layoutIfNeeded()
        }, completion: { (ok) in
            print("Completed")
            
        })
        //Также заметил что при опции .repeat, complitionBlock не выполняется в UIView.animate. Поискал как можно остановить анимацию, чтобы он выполнился. Предлагали использовать: self.view.layer.removeAllAnimations(). Это сработало, но что если у нас несколько анимацию и часть из них должна продолжится?
        //В итоге нашел информацию об UIViewPropertyAnimator, там как раз таки можно и на паузу поставить, и отменить анимацию
        //Сразу возникла ассоциация с GCD и NSOperation, в которой можно отменить task, вошедший в работу)
        
   
    }
    
    

}

extension ViewController {
    
    func setup() {
    self.squareView.backgroundColor = UIColor.red
    self.view.addSubview(self.squareView)
    
        self.setupConstraints()
    
      
  
    }
    
    func setupConstraints() {
        self.squareView.translatesAutoresizingMaskIntoConstraints = false

        //Можно было для уменьшения кода сделать через NSLayoutAnchor, но были случаи когда они работали некорректно и спасали меня тогда именно Constraints
           let squareViewViewHorizontalConstraint = NSLayoutConstraint(item: self.squareView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
           let squareViewVerticalConstraint = NSLayoutConstraint(item: self.squareView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
          squareViewWidthConstraint = NSLayoutConstraint(item: self.squareView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
          squareViewHeightConstraint = NSLayoutConstraint(item: self.squareView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
              
              self.squareView.addConstraints([squareViewWidthConstraint, squareViewHeightConstraint])
              self.view.addConstraints([squareViewVerticalConstraint, squareViewViewHorizontalConstraint])
              
              //Вроде положение квадрата завиксировали, но что будет если ширина превысит размер экрана? Для это добавил ограничивающие констрейнты
              
          let squareViewTrailingConstraint = NSLayoutConstraint(item: self.squareView, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 20)
          let squareViewLeadingConstraint = NSLayoutConstraint(item: self.squareView, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
          let squareViewTopConstraint = NSLayoutConstraint(item: self.squareView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .top, multiplier: 1, constant: 20)
          let squareViewBottomConstraint = NSLayoutConstraint(item: self.squareView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 20)
              
              self.view.addConstraints([squareViewTrailingConstraint, squareViewLeadingConstraint, squareViewTopConstraint, squareViewBottomConstraint ])
    }
}
    //Заключение: если выкинуть .repeat и .autoreverse из options то все работает нормально в любой ориентации и при любых размерах (задание выполнено)
    //Но я нашел кейс в котором возникает проблема: оставить .repeat и .autoreverse. Поставить изначально такую ширрину, которая при увеличении в два раза будет превышать ширину экрана (если меньше то все ОК), например 300. Поворачивать экран в процессе увеличени квадрата. В данном случае анимация ломается. Сталкивался с подобным в CollectionView на ipad, но сейчас не могу вспомнить как решил проблему. Поразмышляю на досуге)
            
        





