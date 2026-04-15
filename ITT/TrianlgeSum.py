a = int(input("Enter the number of test cases: "))
for t in range(a):
    b = int(input(f"Enter the number of rows for test case {t+1}: "))
    c = []
    m = 0
    for i in range(b):
        row = [int(x) for x in input(f"Enter numbers for row {i+1}: ").split()]
        c.append(row)
        m += max(row)
    print("\nTriangle Structure:")
    for row in c:
        print(*(row)) 
    print(f"Maximum Sum: {m}\n")
