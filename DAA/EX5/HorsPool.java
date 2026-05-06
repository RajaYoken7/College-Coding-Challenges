import java.util.Scanner;

public class HorsPool {

    static int[] shiftTable = new int[256];

    // Build Shift Table
    static void buildShiftTable(String pattern) {
        int m = pattern.length();

        for (int i = 0; i < 256; i++)
            shiftTable[i] = m;

        for (int i = 0; i < m - 1; i++)
            shiftTable[pattern.charAt(i)] = m - 1 - i;
    }

    // Horspool Search — returns index or -1
    static int horspoolSearch(String text, String pattern) {
        int n = text.length();
        int m = pattern.length();

        buildShiftTable(pattern);

        int i = m - 1;
        while (i <= n - 1) {
            int k = 0;
            while (k <= m - 1 && pattern.charAt(m - 1 - k) == text.charAt(i - k))
                k++;
            if (k == m)
                return i - m + 1; // return index where pattern found
            i += shiftTable[text.charAt(i)];
        }
        return -1; // pattern not found
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter text:    ");
        String text = sc.nextLine();

        System.out.print("Enter pattern: ");
        String pattern = sc.nextLine();

        // Search and print result
        int result = horspoolSearch(text, pattern);
        System.out.println("\nResult:");
        if (result != -1)
            System.out.println("Pattern found at index: " + result);
        else
            System.out.println("Pattern NOT found. Returned: -1");

        sc.close();
    }
}

/*
 * BUILD SHIFT TABLE (pattern P):
 * m = length of P
 * FOR each character c in alphabet:
 * table[c] = m
 * FOR i = 0 TO m-2:
 * table[P[i]] = m - 1 - i
 * 
 * HORSPOOL SEARCH (text T, pattern P):
 * n = length of T
 * m = length of P
 * buildShiftTable(P)
 * i = m - 1
 * WHILE i <= n - 1:
 * k = 0
 * WHILE k <= m-1 AND P[m-1-k] == T[i-k]:
 * k = k + 1
 * IF k == m:
 * RETURN i - m + 1 // pattern found, return index
 * i = i + table[T[i]]
 * RETURN -1 // pattern not found
 * 
 */