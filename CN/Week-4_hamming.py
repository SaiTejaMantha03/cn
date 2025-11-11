def find_parity_len(msg_len):
    p=0
    while(2**p)<msg_len+1:
        p+=1
    return p

def cal_error_pos(msg, p_bits):
    error_pos = 0
    n = len(msg)

    for i in range(p_bits):
        parity = 0  
        for j in range(n):
            if ((j + 1) & (1 << i)) != 0:
                parity ^= int(msg[j])  
        error_pos += parity * (1 << i)
    return error_pos


def correct_error(msg,error_pos):
    if error_pos>0:
        idx=error_pos-1
        msg[idx]='1' if msg[idx]=='0' else '0'
    return msg

message = list(input("Enter Received Hamming Code: "))
p_bits = find_parity_len(len(message))
error_pos = cal_error_pos(message, p_bits)

print("Error Bit at Position:", error_pos)
message = correct_error(message, error_pos)
print("Corrected Received Hamming Code:", "".join(message))

# 0110111