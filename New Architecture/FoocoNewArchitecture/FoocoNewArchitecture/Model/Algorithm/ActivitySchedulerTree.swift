//
//  ActivitySchedulerTree.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 15/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation


enum ActivitySchedulerTreeError: Error {
    case CycleFound(String)
    case SameChild(String)
}

/**
 - invariant: left child is different than right child.
 - invariant: left child and right child are different than self.
 */
protocol Node {
    var leftChild: Node? {
        get set
    }
    var rightChild: Node? {
        get set
    }
}

/**
    It's a tree of activites, used during the algorithm to add activities to a context block time.
    This tree is what allows to add multiple activities into one single context block.
*/
class ActivitySchedulerTree {
    
    /**
     - invariant: is not leaf
    */
    class TimeBlockNode: Node {

        var timeBlock: TimeBlock?
        var leftChild: Node?
        var rightChild: Node?

        
        init(timeBlock: TimeBlock, leftChild: Node, rightChild: Node? = nil) throws {
         
            self.init(timeBlock: timeBlock, leftChild: leftChild, rightChild: rightChild)
            
        }
        
        init(timeBlock: TimeBlock, leftChild: Node? = nil, rightChild: Node) throws {
            
            self.init(timeBlock: timeBlock, leftChild: leftChild, rightChild: rightChild)
            
        }

        /**
         defined as private because the user can not create a TimeBlockNode as leaf, in other words, without left and right child.
        */
        private init(timeBlock: TimeBlock, leftChild: Node? = nil, rightChild: Node? = nil) throws {
            
            self.timeBlock = timeBlock
            
            if left.leftChild == rightChild {
            
                throw ActivitySchedulerTreeError.SameChild("A node was created with left child being the same as right child")
                
            }
            
            
            self.leftChild = leftChild
            self.rightChild = rightChild
        
            if hasCycle() {
        
                throw ActivitySchedulerTreeError.CycleFound("Tried to add a father that is it's son")
    
            }
        }
        
        
        
        func hasCycle() -> Bool {
            if self == leftChild || self == rightChild {
                return true
            }
            
            return false

        }
        
    }
    
    class ActivityNode: Node {
        
        var activity: Activity?
    
    }
    
    
    var root: ActivityNode
    
    init(root: Activity) {
        self.root = try! ActivityNode(activity: root)
    }
    
    /**
     returns true if the tree can add the new TimeBlock
    */
    func canAdd(activity: Activity) -> Bool {
        
        return canAddAux(node: root, activity: activity)
        
        
    }
    
    private func canAddAux(node: ActivityNode, activity: Activity) -> Bool {
        
        if let leftChild = node.leftChild {
            if canAddAux(node: leftChild, activity: activity) {
                return true
            }
        }
        
        if let rightChild = node.rightChild {
            if canAddAux(node: rightChild, activity: activity) {
                return true
            }
        }
        
        if node.isLeaf() && node.activity!.contains(activity) {
            return true
        }
        
        return false
        
    }
    
    
}
