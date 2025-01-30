//
//  APIConfig.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//


public struct APIConfig {
    
    public struct APIUrl {
        
        #if DEBUG
        static let domain = APIUrl.dev
        #elseif QA
        static let domain = APIUrl.qa
        #elseif STAGING
        static let domain = APIUrl.staging
        #elseif RELEASE
        static let domain = APIUrl.staging
        #endif
        
        private static let dev = "https://app.getswipe.in/api/public"
        private static let qa = "https://app.getswipe.in/api/public"
        private static let staging = "https://app.getswipe.in/api/public"
        private static let prod = "https://app.getswipe.in/api/public"
    }
 
}
