import java.util.Scanner;

public class HeapSort {
    static int[] arr;
    static int size;

    // Percolate Down
    static void percolateDown(int root) {
        int smallest = root;
        int left = 2 * root + 1;
        int right = 2 * root + 2;
        if (left < size && arr[left] < arr[smallest])
            smallest = left;
        if (right < size && arr[right] < arr[smallest])
            smallest = right;
        if (smallest != root) {
            int temp = arr[root];
            arr[root] = arr[smallest];
            arr[smallest] = temp;
            percolateDown(smallest);
        }
    }

    // Build Min-Heap
    static void buildHeap() {
        for (int i = (size / 2) - 1; i >= 0; i--)
            percolateDown(i);
    }

    // Remove Min
    static int removeMin() {
        int min = arr[0];
        arr[0] = arr[size - 1];
        size--;
        percolateDown(0);
        return min;
    }

    // Heap Sort using Min-Heap
    static void heapSort(int n) {
        int[] sorted = new int[n];
        size = n;
        buildHeap();

        for (int i = 0; i < n; i++)
            sorted[i] = removeMin();

        // Overwrite original array with sorted values
        for (int i = 0; i < n; i++)
            arr[i] = sorted[i];
    }

    static void printArray(int n) {
        for (int i = 0; i < n; i++)
            System.out.print(arr[i] + " ");
        System.out.println();
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter number of elements: ");
        int n = sc.nextInt();

        arr = new int[n];
        System.out.print("Enter " + n + " elements: ");
        for (int i = 0; i < n; i++)
            arr[i] = sc.nextInt();

        System.out.print("Before Sorting: ");
        printArray(n);

        size = n;
        heapSort(n);

        System.out.print("After Sorting:  ");
        printArray(n);

        sc.close();
    }
}

/*
 * BUILD HEAP (arr, n):
 * FOR i = (n/2 - 1) DOWN TO 0:
 * PERCOLATE DOWN(arr, n, i)
 * 
 * PERCOLATE DOWN (arr, size, root):
 * smallest = root
 * left = 2 * root + 1
 * right = 2 * root + 2
 * IF left < size AND arr[left] < arr[smallest]:
 * smallest = left
 * IF right < size AND arr[right] < arr[smallest]:
 * smallest = right
 * IF smallest != root:
 * SWAP arr[root] and arr[smallest]
 * PERCOLATE DOWN(arr, size, smallest)
 * 
 * REMOVE MIN (arr, size):
 * min = arr[0]
 * arr[0] = arr[size - 1]
 * size = size - 1
 * PERCOLATE DOWN(arr, size, 0)
 * RETURN min
 * 
 * HEAP SORT (arr, n):
 * BUILD HEAP(arr, n)
 * FOR i = 0 TO n-1:
 * sorted[i] = REMOVE MIN(arr, size)
 * COPY sorted[] back into arr[]
 */