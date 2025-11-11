def xor(a, b):
    c = []
    for i in range(len(a)):
        if a[i] == b[i]:
            c.append('0')
        else:
            c.append('1')
    return c

def crc_divide(data, divisor):
    n = len(divisor)
    m = len(data)
    data += ['0'] * (n - 1)
    for i in range(m):
        if data[i] == '1':
            data[i:i+n] = xor(data[i:i+n], divisor)
    return data[-(n - 1):]

# Inputs
dividend = list(input("Enter the dividend: "))
divisor = list(input("Enter the divisor: "))

# Sender side
remainder = crc_divide(dividend.copy(), divisor)
transmitted = dividend + remainder
print("Transmitted CRC Code:", "".join(transmitted))

# Receiver side
check = crc_divide(transmitted.copy(), divisor)
print("Remainder at Receiver:", "".join(check))
if '1' in check:
    print("Error detected!")
else:
    print("No error detected.")

#1101011, 1011

#1101011111,1011