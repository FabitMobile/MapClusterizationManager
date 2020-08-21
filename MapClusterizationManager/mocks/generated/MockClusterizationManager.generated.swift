// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Mirage2 

class MockClusterizationManager: ClusterizationManager {
    //MARK: - VARIABLES
    //MARK: - FUNCTIONS
    //MARK: clusterize
    class ClusterizeArgs {
        var elements: [ClusterizableElement]
        var zooms: [Int]
        var completion: ClusterizationManagerСompletion?
        init(_ elements: [ClusterizableElement], _ zooms: [Int], _ completion: ClusterizationManagerСompletion?) {
            self.elements = elements
            self.zooms = zooms
            self.completion = completion
        }
    }
    lazy var mock_clusterize = FuncCallHandler<ClusterizeArgs, Void>(returnValue: ())    
    func clusterize(elements: [ClusterizableElement],                    forZooms zooms: [Int],                    completion: ClusterizationManagerСompletion?) {
        return mock_clusterize.handle(ClusterizeArgs(elements, zooms, completion))
    }
}
