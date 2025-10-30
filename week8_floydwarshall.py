INF = 10**9

def distance_vector(graph):
    n = len(graph)
    dist = graph[:]  # Distance matrix (copy)
    
    for _ in range(n-1):
        for u in range(n):
            for v in range(n):
                for w in range(n):
                    if dist[u][w] > dist[u][v] + dist[v][w]:
                        dist[u][w] = dist[u][v] + dist[v][w]
    return dist

def main():
    n = int(input("Number of nodes: "))
    graph = []
    print("Enter adjacency matrix (-1 for no edge):")
    for _ in range(n):
        row = list(map(int, input().split()))
        graph.append([INF if x == -1 else x for x in row])

    dist = distance_vector(graph)

    while True:
        s = ord(input("Source node (A, B, C...): ").upper()) - 65
        d = ord(input("Destination node (A, B, C...): ").upper()) - 65

        if dist[s][d] == INF:
            print("No path")
        else:
            print(f"Shortest distance: {dist[s][d]}")

        if input("Enter 0 to exit, anything else to continue: ") == '0':
            break

if __name__ == "__main__":
    main()
