a=int(input("enter suresh coins: "))
b=int(input("entetr sundar coins: "))
c=int(input("enter the raja cons: "))
d=int(input("enter the sudar coins: "))
print ("Suresh is winner | " if (a>b) else "Sundar is winner| ", "Suresh= " , a, "Sundar= ", b)
if(a<b or a==c):
   a=a+c
elif(b<a):
   b=b+c
print( "suresh is winner | " if (a>b) else "sundar is winner | ", "Suresh= " , a, "Sundar= ", b)
if (a<b or a==c):
   a=a+d
elif (a>b):
   b=b+d
print ("Sundar is winner | " if (b>a) else "Suresh is winner | ", "Suresh= " , a, "Sundar= ", b)
print("\n\n", "FINAL WINNER: ", "Suresh" if (a > b) else "Sundar")
