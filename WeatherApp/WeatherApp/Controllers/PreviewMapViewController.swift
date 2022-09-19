//
//  PreviewMapViewController.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/09/19.
//

import UIKit
import MapKit

class PreviewMapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        DispatchQueue.main.async { [self] in
            self.addSubview()
            self.setConstraint()
            self.mapView.delegate = self
        }
    }
    private func addSubview() {
        view.addSubview(mapView)
        view.addSubview(handle)
    }
    private func setConstraint() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        handle.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        handle.topAnchor.constraint(equalTo: view.topAnchor, constant: 7).isActive = true
        handle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        handle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        handle.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.pointOfInterestFilter = MKPointOfInterestFilter.init(including: [.beach])
        mapView.showsUserLocation = true
//        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        return mapView
    }()
    
    private let handle: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 2.5
        return view
    }()
}

extension PreviewMapViewController: MKMapViewDelegate {
    
}
