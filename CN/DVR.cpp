#include <bits/stdc++.h>
using namespace std;

#define INF 9999999

void inputGraph(int& n, vector<vector<int>>& graph) {
    cout << "Enter number of nodes: ";
    cin >> n;
    graph.assign(n, vector<int>(n));
    cout << "\nEnter adjacency matrix (-1 if no edge present)\n";
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) {
            cin >> graph[i][j];
            if (graph[i][j] == -1) graph[i][j] = INF;
        }
}

void floydWarshall(int n, vector<vector<int>>& graph, vector<vector<int>>& next) {
    auto dist = graph;
    next.assign(n, vector<int>(n, -1));

    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            if (graph[i][j] != INF && i != j) next[i][j] = j;

    for (int k = 0; k < n; k++)
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                if (dist[i][k] + dist[k][j] < dist[i][j]) {
                    dist[i][j] = dist[i][k] + dist[k][j];
                    next[i][j] = next[i][k];
                }

    graph = dist;
}

void printPath(int u, int v, vector<vector<int>>& next) {
    if (next[u][v] == -1) {
        cout << "No path found.\n";
        return;
    }
    cout << "Path: " << char('A' + u);
    while (u != v) {
        u = next[u][v];
        cout << " -> " << char('A' + u);
    }
    cout << '\n';
}

int main() {
    int n;

    vector<vector<int>> next;
    vector<vector<int>> graph;

    inputGraph(n,graph);
    floydWarshall(n, graph, next);

    while (true) {
        cout << "\n--- Shortest Path Query ---\n";
        char sC, dC;
        cout << "Enter Source Node (A, B, C...): ";
        cin >> sC;
        cout << "Enter Destination Node (A, B, C...): ";
        cin >> dC;

        int s = toupper(sC) - 'A', d = toupper(dC) - 'A';
        if (graph[s][d] == INF)
            cout << "\nShortest Distance: Infinity\n";
        else
            cout << "\nShortest Distance: " << graph[s][d] << '\n';

        printPath(s, d, next);

         int choice;
        cout << "\nEnter 0 to Exit, 1 to Continue, 2 to Re-enter graph: ";
        cin >> choice;

        if (choice == 0) break;
        if (choice == 2) {
            inputGraph(n, graph);
            floydWarshall(n, graph, next);
        }
        
    }
    return 0;
}
