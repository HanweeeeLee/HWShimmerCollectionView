//
//  RepoModel.swift
//  HWShimmerCollectionViewSample
//
//  Created by hanwe on 2021/02/18.
//

import FlexibleModelProtocol

struct RepoModel: FlexibleModelProtocol {
    var id: Int = -1
    var fullName: String = ""
    var description: String = ""
    var stargazersCount: Int = -1
    var url: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case stargazersCount = "stargazers_count"
        case url = "html_url"
    }
}
