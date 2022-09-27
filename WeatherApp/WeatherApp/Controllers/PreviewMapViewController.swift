//
//  PreviewMapViewController.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/09/19.
//

import UIKit
import MapKit

class PreviewMapViewController: UIViewController {
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        DispatchQueue.main.async { [self] in
            self.addSubview()
            self.setConstraint()
            self.mapView.delegate = self
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedMapView(_:)))
            self.mapView.addGestureRecognizer(tap)
        }
    }
    private func addSubview() {
        view.addSubview(mapView)
        view.addSubview(handle)
        view.addSubview(subHandle)
    }
    private func setConstraint() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        handle.translatesAutoresizingMaskIntoConstraints = false
        subHandle.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        handle.topAnchor.constraint(equalTo: view.topAnchor, constant: 7).isActive = true
        handle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        handle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        handle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        subHandle.topAnchor.constraint(equalTo: handle.bottomAnchor).isActive = true
        subHandle.leadingAnchor.constraint(equalTo: handle.leadingAnchor).isActive = true
        subHandle.trailingAnchor.constraint(equalTo: handle.trailingAnchor).isActive = true
        subHandle.heightAnchor.constraint(equalToConstant: 15).isActive = true
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
    private let subHandle: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
}

extension PreviewMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        debugPrint(annotation)
        
        return nil
    }
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        print("===========================================")
        debugPrint(annotation)
        print("===========================================")
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        mapView.camera.centerCoordinate
    }
}
extension PreviewMapViewController {
    /// 제스처 조작
    @objc
    private func didTappedMapView(_ sender: UITapGestureRecognizer) {
        let location: CGPoint = sender.location(in: self.mapView)
        let mapPoint: CLLocationCoordinate2D = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        if sender.state == .ended {
            self.searchLocation(mapPoint)
        }
    }
    
    /// 하나만 출력하기 위하여 모든 포인트를 삭제
    private func removeAllAnnotations() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
    
    /// 해당 포인트의 주소를 검색
    private func searchLocation(_ point: CLLocationCoordinate2D) {
        let geocoder: CLGeocoder = CLGeocoder()
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
        
        // 포인트 리셋
        self.removeAllAnnotations()
        
        geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if error == nil, let marks = placeMarks {
                marks.forEach { (placeMark) in
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                    
                    print( """
                    \(placeMark.administrativeArea ?? "")
                    \(placeMark.locality ?? "")
                    \(placeMark.thoroughfare ?? "")
                    \(placeMark.subThoroughfare ?? "")
                    """)
                    
                    self.mapView.addAnnotation(annotation)
                }
            } else {
                print("검색 실패")
            }
        }
    }
}
