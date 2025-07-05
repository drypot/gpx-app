//
//  Publisher.swift
//  GPXApp
//
//  Created by drypot on 2024-02-12.
//

import Foundation
import Combine

/*
 https://www.swiftbysundell.com/articles/the-power-of-extensions-in-swift/#specializing-generics
 */

extension Publisher {
        
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self
            .map(Result.success)
            .catch { error in
                Just(Result.failure(error))
            }
            .eraseToAnyPublisher()
    }
    
}
