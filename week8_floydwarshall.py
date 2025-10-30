INF =9999999

def generate_input():
    n=int(input("Enter number of nodes: "))
    graph=[]

    print("\nEnter adjacency matrix(-1 if no edge present)")

    for i in range(n):
        row_input = input().split()
        row = [int(x) for x in row_input]
        row = [INF if x == -1 else x for x in row]
        graph.append(row)
    return n,graph

def floyd_warshall(n,graph):
    dist=[]
    for row in graph:
        dist.append(row.copy())
    
    next_node=[]
    for i in range(n):
        row=[]
        for j in range(n):
         if graph[i][j] != INF and i != j:
             row.append(j)
         else:
             row.append(-1)
        next_node.append(row)

    for k in range(n):
        for i in range(n):
            for j in range(n):
                if dist[i][j]>dist[i][k]+dist[k][j]:
                     dist[i][j]=dist[i][k]+dist[k][j]
                     next_node[i][j] = next_node[i][k]
    
    return dist,next_node


# ---------- Step 3: Reconstruct and print path ----------
def print_path(u, v, next_node):
    if next_node[u][v] == -1:
        print("No path found.")
        return

    path = [u]  # start path with source

    # Follow next_node until destination
    while u != v:
        u = next_node[u][v]
        path.append(u)

    # Print path as letters (A, B, C, ...)
    print("Path: ", end="")
    for i in range(len(path)):
        print(chr(65 + path[i]), end="")
        if i != len(path) - 1:
            print(" -> ", end="")
    print()


# ---------- Step 4: Run everything ----------
n, graph = generate_input()
dist, next_node = floyd_warshall(n, graph)

while True:
    print("\n--- Shortest Path Query ---")
    s = ord(input("Enter Source Node (A, B, C...): ").upper()) - 65
    d = ord(input("Enter Destination Node (A, B, C...): ").upper()) - 65

    print("\nShortest Distance:", dist[s][d] if dist[s][d] != INF else "Infinity")
    print_path(s, d, next_node)

    choice = int(input("\nEnter 0 to Exit, 1 to Continue, 2 to Re-enter graph: "))
    if choice == 0:
        break
    elif choice == 2:
        n, graph = generate_input()
        dist, next_node = floyd_warshall(n, graph)
