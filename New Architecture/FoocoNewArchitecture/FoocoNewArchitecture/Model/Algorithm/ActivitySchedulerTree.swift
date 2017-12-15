////
////  ActivitySchedulerTree.swift
////  FoocoNewArchitecture
////
////  Created by Victor S Melo on 15/12/17.
////  Copyright © 2017 Victor S Melo. All rights reserved.
////
//
//import Foundation
//
//
//enum ActivitySchedulerTreeError: Error {
//    case CycleFound(String)
//    case SameChild(String)
//    case TriedToAddChildToActivityNode(String)
//}
//
///**
// - invariant: left child is different than right child.
// - invariant: left child and right child are different than self.
// */
//protocol Node {
//    
//    var leftChild: Node? {
//        get set
//    }
//    var rightChild: Node? {
//        get set
//    }
//    var parent: Node? {
//        get set
//    }
//
//    func isLeaf() -> Bool
//
//}
//
///**
//    It's a tree of activites, used during the algorithm to add activities to a context block time.
//    This tree is what allows to add multiple activities into one single context block.
//*/
//class ActivitySchedulerTree {
//
//    /**
//     - invariant: is not leaf
//    */
//    class TimeBlockNode: Node {
//
//        var timeBlock: TimeBlock
//
//        private var _leftChild: Node?
//        var leftChild: Node? {
//            set {
//                _leftChild = newValue
//                _leftChild?.parent = self
//            }
//            get {
//                return _leftChild
//            }
//        }
//
//        private var _rightChild: Node?
//        var rightChild: Node? {
//            set {
//                _rightChild = newValue
//                _rightChild?.parent = self
//            }
//            get {
//                return _rightChild
//            }
//        }
//
//        var parent: Node?
//
//        /**
//         TimeBlockNode can be a leaf or not. If it is a leaf, means that this TimeBlock is free to be allocated for an activity.
//        */
//        init(timeBlock: TimeBlock, leftChild: Node? = nil, rightChild: Node? = nil, parent: Node? = nil) throws {
//
//            self.timeBlock = timeBlock
//
//            self.leftChild = leftChild
//            self.rightChild = rightChild
//            self.parent = parent
//
//            if isDuplicatedChild(){
//
//                throw ActivitySchedulerTreeError.SameChild("A node was created with left child being the same as right child")
//
//            }
//
//            if hasCycle() {
//
//                throw ActivitySchedulerTreeError.CycleFound("Tried to add a father that is it's son")
//
//            }
//        }
//
//
//
//        func hasCycle() -> Bool {
//            if (leftChild is TimeBlockNode && self === (leftChild as! TimeBlockNode)) || (rightChild is TimeBlockNode && self === (rightChild as! TimeBlockNode)) {
//                return true
//            }
//
//            return false
//
//        }
//
//        private func isDuplicatedChild() -> Bool {
//
//            if (leftChild is TimeBlockNode && rightChild is TimeBlockNode && (leftChild as! TimeBlockNode) === (rightChild as! TimeBlockNode)) ||
//                (leftChild is ActivityNode && rightChild is ActivityNode && (leftChild as! ActivityNode) === (rightChild as! ActivityNode)){
//                return true
//            }
//
//            return false
//
//        }
//
//        func isLeaf() -> Bool {
//            return leftChild == nil && rightChild == nil
//        }
//
//        func addLeft(activityNode: ActivityNode) -> Node {
//
//
//            var node: Node?
//
//
//
//
//            //remove self from parent
//            if self.parent?.leftChild === tbn {
//                tbn.parent?.leftChild = node
//
//            } else if self.parent?.rightChild === tbn {
//                tbn.parent?.leftChild = node
//            }
//
//        }
//
//    }
//
//    class ActivityNode: Node {
//
//        var activity: Activity
//
//        private var _leftChild: Node?
//        var leftChild: Node? {
//            set {
//                _leftChild = newValue
//                _leftChild?.parent = self
//            }
//            get {
//                return _leftChild
//            }
//        }
//
//        private var _rightChild: Node?
//        var rightChild: Node? {
//            set {
//                _rightChild = newValue
//                _rightChild?.parent = self
//            }
//            get {
//                return _rightChild
//            }
//        }
//
//        var parent: Node?
//
//
//        /**
//         ActivityNode can be a leaf or not.
//         */
//        init(activity: Activity, leftChild: Node? = nil, rightChild: Node? = nil, parent: Node? = nil) throws {
//
//            self.activity = activity
//
//            self.leftChild = leftChild
//            self.rightChild = rightChild
//
//            if isDuplicatedChild(){
//
//                throw ActivitySchedulerTreeError.SameChild("A node was created with left child being the same as right child")
//
//            }
//
//            if hasCycle() {
//
//                throw ActivitySchedulerTreeError.CycleFound("Tried to add a father that is it's son")
//
//            }
//        }
//
//        func hasCycle() -> Bool {
//            if (leftChild is ActivityNode && self === (leftChild as! ActivityNode)) || (rightChild is ActivityNode && self === (rightChild as! ActivityNode)) {
//                return true
//            }
//
//            return false
//
//        }
//
//        private func isDuplicatedChild() -> Bool {
//
//            if (leftChild is TimeBlockNode && rightChild is TimeBlockNode && (leftChild as! TimeBlockNode) === (rightChild as! TimeBlockNode)) ||
//                (leftChild is ActivityNode && rightChild is ActivityNode && (leftChild as! ActivityNode) === (rightChild as! ActivityNode)){
//                return true
//            }
//
//            return false
//
//        }
//
//        func isLeaf() -> Bool {
//            return leftChild == nil && rightChild == nil
//        }
//
//
//    }
//
//
//    var root: Node
//
//    private var nodeToAddActivity: TimeBlockNode? = nil
//
//    //keeped in cache. It's built when algorithm needs to know the availableTimeBlocks. Later, it may be updated when the algorithm needs to add an activity.
//    private var availableTimeBlockNodes: [TimeBlockNode] = []
//
//    init(root: TimeBlock) {
//        self.root = try! TimeBlockNode(timeBlock: root)
//    }
//
//    func getAvailableTimeBlocks() -> [TimeBlock] {
//
//        updateAvailableTimeBlockNodes()
//
//        var resultArray: [TimeBlock] = []
//        for tbn in availableTimeBlockNodes {
//            resultArray.append(tbn.timeBlock)
//        }
//
//        return resultArray
//
//    }
//
//    private func updateAvailableTimeBlockNodes() {
//
//        self.availableTimeBlockNodes = []
//        updateAvailableTimeBlockNodesAux(node: root)
//
//    }
//
//    private func updateAvailableTimeBlockNodesAux(node: Node) {
//
//        if node is ActivityNode {
//            return
//        }
//
//        //is timeBlock and is leaf
//        if node.isLeaf() {
//
//            availableTimeBlockNodes.append(node as! TimeBlockNode)
//            return
//
//        }
//
//        if let leftChild = node.leftChild {
//            updateAvailableTimeBlockNodesAux(node: leftChild)
//        }
//
//        if let leftChild = node.leftChild {
//            updateAvailableTimeBlockNodesAux(node: leftChild)
//        }
//
//    }
//
//
//    /**
//        Add an activity for the TimeBlock parameter
//     */
//    func add(activity: Activity, for timeBlock: TimeBlock) {
//
//        for tbn in availableTimeBlockNodes {
//
//            //must exist just one tbn that will enter in this if condition
//            if tbn.timeBlock == timeBlock {
//
//                //activity is on the left
//                if activity.start == timeBlock.start && activity.end < timeBlock.end{
//
//                    addLeft(newNode: ActivityNode(activity: activity), of: Node)
//
//
//                }
//
//                //activity is on the right
//
//                //activity is in the middle
//
//                replace(tbn, by: ActivityNode(activity: activity))
//
//                break
//            }
//        }
//
//    }
//
//    private func addLeft(newNode: Node, of parentNode: Node) {
//
//        if parentNode.leftChild == nil {
//            parentNode.leftChild = newNode
//            return
//        }
//
//
//    }
//
//    private func replace(_ old: Node, by new: Node) {
//
//        if let parent = old.parent {
//
//            if parent.leftChild === old {
//               parent.leftChild = new
//
//            } else if parent.rightChild === old {
//                parent.rightChild = new
//            }
//
//        }
//
//        new.leftChild = old.leftChild
//        new.rightChild = old.rightChild
//
//    }
//
//}

