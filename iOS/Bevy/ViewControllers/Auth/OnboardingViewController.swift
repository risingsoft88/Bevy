//
//  OnboardingViewController.swift
//  Bevy
//
//  Created by macOS on 6/18/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnSkip: UIButton!

    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0

    //data for the slides
    var imgs = [R.image.onboardingScreen1(), R.image.onboardingScreen2(), R.image.onboardingScreen3()] // R.image.onboardingScreen4(), R.image.onboardingScreen5()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview

        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        //create the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }

        for index in 0..<imgs.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            let slide = UIView(frame: frame)

            //subviews
            let imageView = UIImageView.init(image: imgs[index])
            imageView.frame = CGRect(x:0, y:0, width:scrollWidth, height:scrollHeight)
            imageView.contentMode = .scaleToFill
//            imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)

            slide.addSubview(imageView)
            scrollView.addSubview(slide)
        }

        //set width of scrollview to accomodate all the slides
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(imgs.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollView.contentSize.height = 1.0

        //initial state
        pageControl.numberOfPages = imgs.count
        pageControl.currentPage = 0
    }

    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }

    //indicator
    @IBAction func pageChanged(_ sender: Any) {
        scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }

    func setIndiactorForCurrentPage()  {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
        if (pageControl.currentPage == imgs.count-1) {
            btnSkip.setTitle("Done", for: .normal)
        } else {
            btnSkip.setTitle("Skip", for: .normal)
        }
        if (pageControl.currentPage == 3) {
            btnSkip.setTitleColor(UIColor.black, for: .normal)
        } else {
            btnSkip.setTitleColor(UIColor.white, for: .normal)
        }
    }

    @IBAction func clickDone(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("skip", forKey: "skipOnboarding")
        let vc = R.storyboard.auth().instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

