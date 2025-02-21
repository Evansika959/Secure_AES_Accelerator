from aes_simulation import aes_encrypt
import os

def encrypt():
    key = bytes.fromhex("000102030405060708090a0b0c0d0e0f")
    ciphertext_pairs = []
    for _ in range(20):
        plaintext = os.urandom(16)
        ciphertext = aes_encrypt(plaintext, key)
        ciphertext_pairs.append((plaintext, ciphertext))
    return ciphertext_pairs

def save_to_file(ciphertext_pairs, filename="../run/goldenbrick.txt"):
    # Create the directory if it doesn't exist.
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'w') as f:
        f.write("Plaintext\tCiphertext\n")
        for plaintext, ciphertext in ciphertext_pairs:
            f.write(plaintext.hex() + "\t" + ciphertext.hex() + "\n")

def save_plaintext_to_file(ciphertext_pairs, filename="../run/encrypt_goldenbrick_in"):
    # Create the directory if it doesn't exist.
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'w') as f:
        for plaintext, _ in ciphertext_pairs:
            f.write(plaintext.hex() + "\n")

def save_cyphertext_to_file(ciphertext_pairs, filename="../run/encrypt_goldenbrick_in"):
    # Create the directory if it doesn't exist.
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'w') as f:
        for _ , ciphertext in ciphertext_pairs:
            f.write(ciphertext.hex() + "\n")

ciphertext_pairs = encrypt()
save_to_file(ciphertext_pairs, "../run/goldenbrick.txt")
save_cyphertext_to_file(ciphertext_pairs, "../run/encrypt_goldenbrick_out.txt")
save_plaintext_to_file(ciphertext_pairs, "../run/encrypt_goldenbrick_in.txt")
