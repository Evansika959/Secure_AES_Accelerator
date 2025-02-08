from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
from Crypto.Random import get_random_bytes
import binascii

from key_expansion_demo import key_expansion, format_round_keys
from aes_encryptRound_gentb import aes_single_round

def aes_encrypt_ecb(key, plaintext):
    # Ensure plaintext is exactly 16 bytes
    assert len(plaintext) == 16, "Plaintext must be exactly 16 bytes."
    cipher = AES.new(key, AES.MODE_ECB)
    ciphertext = cipher.encrypt(plaintext)  # No padding
    return ciphertext

def add_round_key(state: bytearray, round_key: bytes):
        """Perform AddRoundKey operation."""
        return bytearray(s ^ k for s, k in zip(state, round_key))


key = get_random_bytes(16)  # Random 128-bit key
plaintext = get_random_bytes(16)  # Random 128-bit plaintext

key = bytes.fromhex("000102030405060708090a0b0c0d0e0f")
plaintext = bytes.fromhex("00112233445566778899aabbccddeeff")

print("Overview: ")

ciphertext = aes_encrypt_ecb(key, plaintext)
print("Key:                 ", key.hex())
print("Original Plaintext:  ", plaintext.hex())
print("Encrypted Ciphertext:", ciphertext.hex())

print("=============================================================")
print("=============================================================\n")

round_keys = format_round_keys(key_expansion(key))

state = add_round_key(bytearray(plaintext), bytes.fromhex(round_keys[0]))

print("After round key")

print("Initial Key:", round_keys[0])
print("After Round Key:", state.hex())

for i in range(1, 11):
    state = aes_single_round(state, bytes.fromhex(round_keys[i]), i == 10)
    print("Round Key:", round_keys[i])
    print("After Round", i, ":", state.hex())

print("=============================================================")
print("simulated ciphertext: ", state.hex())








