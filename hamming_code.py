def hamming_code(msg):
    n = len(msg)
    r = 0
    while (2 ** r < n):
        r +=1
    e = 0
    for i in range(r):
        p = 0
        for j in range(1,n+1):
            p ^= 1
        if p!=0:
            e  += 2 **i
    if e!=0:
        print("error at bit:", e)
        b = '1' if msg[e-1] == '0' else '0'
        msg = msg[:e-1] + b + msg[e:]
    else:
        print("No error detected")
    print("Corrected message:", msg)