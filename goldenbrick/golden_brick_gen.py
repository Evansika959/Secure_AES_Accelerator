from aes_simulation import aes_encrypt, aes_decrypt
import os

def gen_tb():
    key = os.urandom(16)
    with open('../run/tb_input.txt', 'w') as fin, open('../run/tb_output.txt', 'w') as fout:
        fin.write(f"{key.hex()} 0 1\n")
        for _ in range(20):
            intext = os.urandom(16)
            # randomly decide if it's a decryption test or an encryption test
            if os.urandom(1)[0] % 2 == 0:
                # encryption test (indicator 0)
                indicator = 0
                outtext = aes_encrypt(intext, key)
            else:
                # decryption test (indicator 1)
                indicator = 1
                outtext = aes_decrypt(intext, key)

            fin.write(f"{intext.hex()} {indicator} 0\n")
            fout.write(f"{outtext.hex()} {indicator}\n")

if __name__ == '__main__':
    gen_tb()