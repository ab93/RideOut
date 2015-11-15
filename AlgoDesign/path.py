__author__ = 'avik'

import sys
import operator
import collections
import util

from pygraphviz import *

def getStartNode(graph,sourceNode):
    return sourceNode


def removeDuplicates(list):
    newList = []
    for item in list:
        if item not in newList:
            newList.append(item)

    #newList = sorted(newList)

    return newList


def isGoalNode(graph,destinationNodes,node):

    for goalNode in destinationNodes:
        if node == goalNode:
            return True

    return False


def getSuccessors(graph,node):
    #print node
    #print graph[node]
    return graph[node]


def ParseGraphLine(graph,offPeriod,line):
    graphLine = line.strip().split(' ')

    graph[graphLine[0]][graphLine[1]] = graphLine[2]

    return


def ParseInputFile(graph):

    G = AGraph(directed = True, ranksep="equally")

    with open('graphinput.txt','r+') as inputFile:

        line = inputFile.readline()
        sourceNode = line.strip()
        print "sourceNode",sourceNode
        graph[sourceNode] = []
        G.add_node(sourceNode)

        line = inputFile.next()
        destinationNodes = line.strip().split(' ')
        print "destinationNodes:",destinationNodes
        for nodes in destinationNodes:
            graph[nodes] = []
            G.add_node(nodes)

        line = inputFile.next()    #This can be empty which means no middle nodes
        middleNodes = line.strip().split(' ')
        print "middleNodes:",middleNodes
        for nodes in middleNodes:
            graph[nodes] = []
            G.add_node(nodes)


        line = inputFile.next()
        pipeCount = int(line.strip())
        print "pipeCount",pipeCount

        i = 0
        while i < pipeCount:
            i+=1
            line = inputFile.next()
            graphLine = line.strip().split(' ')
            graph[graphLine[0]].append(graphLine[1])
            G.add_edge(graphLine[0],graphLine[1])


        print "\n",graph

        G.write("test.dot")
        #raw_input("press enter:")

    return


def breadthFirstSearch(graph,source,dest,pathPoint,both=True):

    fringe = util.Queue()
    fringe.enqueue( (source,[],[source]) )
    found_pathPoint = False
    found_dest = False
    #rDestFirst = False
    #print "\nBFS:",graph

    while fringe.isEmpty() == False:
        node,visited,path = fringe.dequeue()
        #print "node,visited,path:",node,visited,path

        for nextNode in sorted(getSuccessors(graph,node)):
            #print "nextNode:",nextNode
            if not nextNode in visited:
                if isGoalNode(graph,dest,nextNode) and not found_dest:
                    found_dest = True
                    if not both:
                        return path + [nextNode]
                if isGoalNode(graph,pathPoint,nextNode) and not found_pathPoint:
                    found_pathPoint = True
                    if not both:
                        return path + [nextNode]
                if found_dest and found_pathPoint:
                    return path + [nextNode]
                #fringe.enqueue( (nextNode,time+1,visited + [nextNode]) )
                fringe.enqueue( (nextNode,visited + [node],path + [nextNode]) )

    return None


def BFS(graph,source,dest,pathPoint):

    fringe = util.Queue()
    fringe.enqueue( (source,[],[source]) )
    found_pathPoint = False
    found_dest = False
    
    #rDestFirst = False
    #print "\nBFS:",graph

    while fringe.isEmpty() == False:
        node,visited,path = fringe.dequeue()
        #print "node,visited,path:",node,visited,path

        for nextNode in sorted(getSuccessors(graph,node)):
            #print "nextNode:",nextNode
            if not nextNode in visited:
                if isGoalNode(graph,dest,nextNode):
                    #found_dest = True
                if isGoalNode(graph,pathPoint,nextNode) and not found_pathPoint:
                    found_pathPoint = True
                if found_dest and found_pathPoint:
                    return path + [nextNode]
                #fringe.enqueue( (nextNode,time+1,visited + [nextNode]) )
                fringe.enqueue( (nextNode,visited + [node],path + [nextNode]) )

    return None



def depthFirstSearch(graph,source,dest,pathPoint):

    frontier = util.Stack()
    frontier.push( (source,[]) )
    explored = []
    found_dest = False
    found_pathPoint = False

    while frontier.isEmpty() == False:

        node,path = frontier.pop()

        if isGoalNode(graph,dest,node):
            return path + [node]

        explored.append(node)
        for nextNode in sorted(getSuccessors(graph,node),reverse=True):
            #print "nextNode:",nextNode
            if not nextNode in explored:
                frontier.push( (nextNode,path + [node]) )

    return 'None',''


def main():

    graph = {}

    ParseInputFile(graph)
    driver_source = 'S'
    driver_dest = 'G'
    rider_source = 'B'
    rider_dest = 'K'
    driver_waypt = 'H'
    path = breadthFirstSearch(graph,driver_source,rider_source,driver_waypt)
    #print path
    if path:
        print path
        path1 = list(path)
        path2 = breadthFirstSearch(graph,path[-1],driver_dest,rider_dest,False)
        path = removeDuplicates(path1 + path2)
        print path

    rideShares = []
    ridePath = []
    flag = False
    for point in path:
        if point == rider_source:
            flag = True
        elif point == rider_dest:
            ridePath.append(point)
            flag = False
        if flag == True:
            ridePath.append(point)

    print ridePath

    #for point in ridePath:



if __name__ == '__main__':
    main()




