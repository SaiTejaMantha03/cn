def xor(a, b):
    return ['0' if x == y else '1' for x, y in zip(a, b)]

def func(a, d):
    a = a.copy()  
    for _ in range(len(a) - len(d) + 1):
        if a[0] == '1':
            a[:len(d)] = xor(a[:len(d)], d)
        a.pop(0)
    return a

def crc(div, d):
    div = list(div)
    d = list(d)
    
    div_extended = div + ['0'] * (len(d) - 1)
    crc = func(div_extended, d)
    print("Remaining CRC:", ''.join(crc))
    crc_list = div + crc
    crc_list = func(crc_list, d)
    print("Remainder at receiver:", ''.join(crc_list))

def main():
    div = input('Enter dividend (binary string): ')
    d = input('Enter divisor (generator polynomial as binary string): ')
    crc(div, d)

if __name__ == "__main__":
    main()
