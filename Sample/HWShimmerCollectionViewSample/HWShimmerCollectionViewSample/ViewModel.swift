//
//  ViewModel.swift
//  HWShimmerCollectionViewSample
//
//  Created by hanwe on 2021/02/18.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

protocol GithubViewModelInput {
    var searchTextRelay: PublishRelay<String> { get }
}

protocol GithubViewModelOutput {
    var navigationBarTitle: Observable<String> { get }
    var gitHubRepositories: PublishSubject<[RepoModel]> { get } // model
    var isLoading: PublishSubject<Bool> { get }
    var error: Observable<NSError> { get }
}

protocol GithubViewModelType {
    var inputs: GithubViewModelInput { get }
    var outputs: GithubViewModelOutput { get }
}

class ViewModel: GithubViewModelInput, GithubViewModelOutput, GithubViewModelType {
    var inputs: GithubViewModelInput { return self }
    var outputs: GithubViewModelOutput { return self }
    
    
    //MARK: WeatherViewModelInput property
    var searchTextRelay: PublishRelay<String> = .init()
    
    //MARK: WeatherViewModelOutput property
    var navigationBarTitle: Observable<String>
    var isLoading: PublishSubject<Bool>
    var error: Observable<NSError>
    var gitHubRepositories: PublishSubject<[RepoModel]>
    
    //MARK: property
    var disposeBag: DisposeBag = DisposeBag()
    
    //MARK: life cycle
    init() {
        self.navigationBarTitle = Observable.just("hi~ this is navigation bar title")
        self.isLoading = PublishSubject.init()
        self.error = Observable.just(NSError())
        self.gitHubRepositories = PublishSubject.init()
    }
    
    //MARK: func
    func initSubscribe() {
        self.searchTextRelay
            .debounce(.milliseconds(600), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .subscribe(onNext: { searchTxt in
                self.isLoading.onNext(true)
                DataApiManager.requestGETURLRx("https://api.github.com/search/repositories?q=\(searchTxt)&sort=start&page=0", headers: nil)
                    .subscribe { (response) in
                        var repoModelArr: [RepoModel] = []
                        for i in 0..<response["items"].count {
                            if let model: RepoModel = RepoModel.fromJson(jsonData: response["items"][i].rawString()?.data(using: .utf8), object: RepoModel()) {
                                repoModelArr.append(model)
                            }
                        }
                        self.gitHubRepositories.onNext(repoModelArr)
                        self.isLoading.onNext(false)
                } onError: { (err) in
                    print("err:\(err)")
                    self.isLoading.onNext(false)
                    self.error = Observable.just(err as NSError)
                } onCompleted: {
                    
                } onDisposed: {
                    
                }
                .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
    }

}
