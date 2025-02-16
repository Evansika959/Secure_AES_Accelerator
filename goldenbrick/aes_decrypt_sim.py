#!/usr/bin/env python3
"""
AES-128 Decryptor Simulator in Python (No Padding)
Both key and ciphertext are provided as 128-bit hex strings.
Displays the state after:
  - Initial AddRoundKey (pre-round)
  - Each of the 10 rounds (using inverse transformations)
"""

# -----------------------
# AES S-box and Inverse S-box (256 entries)
# -----------------------
SBOX = [
    0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
    0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
    0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
    0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
    0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
    0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
    0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a,
    0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
    0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0,
    0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
    0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
    0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
    0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85,
    0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
    0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5,
    0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
    0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17,
    0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
    0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88,
    0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
    0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c,
    0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
    0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9,
    0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
    0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6,
    0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
    0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e,
    0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
    0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94,
    0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
    0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
    0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
]

INV_SBOX = [
    0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38,
    0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB,
    0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87,
    0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB,
    0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D,
    0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E,
    0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2,
    0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25,
    0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16,
    0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92,
    0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA,
    0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84,
    0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A,
    0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06,
    0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02,
    0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B,
    0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA,
    0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73,
    0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85,
    0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E,
    0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89,
    0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B,
    0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20,
    0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4,
    0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31,
    0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F,
    0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D,
    0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF,
    0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0,
    0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61,
    0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26,
    0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D
]

# -----------------------
# Round Constants (Rcon)
# -----------------------
RCON = [
    0x00000000,
    0x01000000,
    0x02000000,
    0x04000000,
    0x08000000,
    0x10000000,
    0x20000000,
    0x40000000,
    0x80000000,
    0x1B000000,
    0x36000000
]

# -------------------------------------------
# Helper functions for state (4x4 matrix) I/O
# -------------------------------------------
def bytes_to_matrix(b):
    """Convert a 16-byte array into a 4x4 matrix (column-major)."""
    return [list(b[i::4]) for i in range(4)]

def matrix_to_bytes(matrix):
    """Convert a 4x4 matrix (column-major) back to a 16-byte array."""
    return bytes(sum(zip(*matrix), ()))

# -------------------------------------
# AES Basic Transformations (Encryption Side)
# (Used for key addition only since it's identical)
# -------------------------------------
def add_round_key(state, round_key):
    """XOR the state with the round key (both as 4x4 matrices)."""
    for r in range(4):
        for c in range(4):
            state[r][c] ^= round_key[r][c]
    return state

# -------------------------------------
# Inverse AES Transformations (for Decryption)
# -------------------------------------
def inv_sub_bytes(state):
    """Apply the inverse S-box to each byte in the state."""
    for r in range(4):
        for c in range(4):
            state[r][c] = INV_SBOX[state[r][c]]
    return state

def inv_shift_rows(state):
    """Inverse shift rows: shift rows right by the row index."""
    new_state = [row[:] for row in state]
    for r in range(4):
        new_state[r] = state[r][-r:] + state[r][:-r]
    return new_state

# GF multiplication helpers for InvMixColumns
def gmultiply(a, b):
    """Multiply two numbers in the GF(2^8) field."""
    p = 0
    for i in range(8):
        if b & 1:
            p ^= a
        hi_bit_set = a & 0x80
        a = (a << 1) & 0xFF
        if hi_bit_set:
            a ^= 0x1B
        b //= 2
    return p

def inv_mix_columns(state):
    """Apply the inverse MixColumns transformation on the state."""
    for c in range(4):
        a = [state[r][c] for r in range(4)]
        state[0][c] = gmultiply(a[0], 14) ^ gmultiply(a[1], 11) ^ gmultiply(a[2], 13) ^ gmultiply(a[3], 9)
        state[1][c] = gmultiply(a[0], 9)  ^ gmultiply(a[1], 14) ^ gmultiply(a[2], 11) ^ gmultiply(a[3], 13)
        state[2][c] = gmultiply(a[0], 13) ^ gmultiply(a[1], 9)  ^ gmultiply(a[2], 14) ^ gmultiply(a[3], 11)
        state[3][c] = gmultiply(a[0], 11) ^ gmultiply(a[1], 13) ^ gmultiply(a[2], 9)  ^ gmultiply(a[3], 14)
    return state

# -----------------------------
# Key Expansion (AES-128)
# -----------------------------
def sub_word(word):
    """Apply the S-box to each of the 4 bytes in a 32-bit word."""
    return ((SBOX[(word >> 24) & 0xFF] << 24) |
            (SBOX[(word >> 16) & 0xFF] << 16) |
            (SBOX[(word >> 8) & 0xFF] << 8) |
            (SBOX[word & 0xFF]))

def rot_word(word):
    """Rotate a 32-bit word left by 8 bits."""
    return ((word << 8) & 0xFFFFFFFF) | ((word >> 24) & 0xFF)

def key_expansion(key):
    """Generate the 44 32-bit words (11 round keys) for AES-128."""
    # Convert key (16 bytes) to 4 words
    key_words = []
    for i in range(4):
        key_words.append(int.from_bytes(key[4*i:4*i+4], byteorder='big'))
    
    for i in range(4, 44):
        temp = key_words[i - 1]
        if i % 4 == 0:
            temp = sub_word(rot_word(temp)) ^ RCON[i // 4]
        key_words.append(key_words[i - 4] ^ temp)
    return key_words

def get_round_keys(key):
    """Return round keys as a list of 4x4 matrices (each round key is 16 bytes)."""
    words = key_expansion(key)
    round_keys = []
    for i in range(0, 44, 4):
        round_key_bytes = b''.join(word.to_bytes(4, 'big') for word in words[i:i+4])
        round_keys.append(bytes_to_matrix(round_key_bytes))
    return round_keys

# -----------------------------------
# AES Decryption (Simulation)
# -----------------------------------
def aes_decrypt(ciphertext, key):
    """
    Decrypt a 16-byte ciphertext with a 16-byte key.
    Both inputs are bytes objects.
    Displays the state at:
      - Initial AddRoundKey (with round key 10)
      - After each inverse round (Rounds 9 to 1)
      - Final round (Round 0)
    """
    # Convert ciphertext into state matrix
    state = bytes_to_matrix(ciphertext)
    
    # Get all round keys (11 round keys for AES-128)
    round_keys = get_round_keys(key)
    
    print("Round Key 10:")
    print(matrix_to_bytes(round_keys[10]).hex())
    
    # Initial AddRoundKey (with last round key)
    state = add_round_key(state, round_keys[10])
    print("\nAfter Initial AddRoundKey (with Round Key 10):")
    print(matrix_to_bytes(state).hex())
    
    # 9 rounds: InvShiftRows, InvSubBytes, AddRoundKey, InvMixColumns
    for round in range(9, 0, -1):
        state = inv_shift_rows(state)
        print(f"\nAfter Round {round} InvShiftRows:")
        print(matrix_to_bytes(state).hex())
        
        state = inv_sub_bytes(state)
        print(f"\nAfter Round {round} InvSubBytes:")
        print(matrix_to_bytes(state).hex())
        
        state = add_round_key(state, round_keys[round])
        print(f"\nAfter Round {round} AddRoundKey:")
        print(matrix_to_bytes(state).hex())
        
        state = inv_mix_columns(state)
        print(f"\nAfter Round {round} InvMixColumns:")
        print(matrix_to_bytes(state).hex())
        print(f"Round Key {round}: {matrix_to_bytes(round_keys[round]).hex()}")
    
    # Final round: InvShiftRows, InvSubBytes, AddRoundKey (no InvMixColumns)
    state = inv_shift_rows(state)
    print(f"\nAfter Final Round InvShiftRows:")
    print(matrix_to_bytes(state).hex())
    
    state = inv_sub_bytes(state)
    print(f"\nAfter Final Round InvSubBytes:")
    print(matrix_to_bytes(state).hex())
    
    state = add_round_key(state, round_keys[0])
    print(f"\nAfter Final Round AddRoundKey (with Round Key 0):")
    print(matrix_to_bytes(state).hex())
    print(f"Round Key 0: {matrix_to_bytes(round_keys[0]).hex()}")
    
    return matrix_to_bytes(state)

# -----------------------------
# Main: Set key and ciphertext
# -----------------------------
def main():
    # Example inputs (128-bit = 16 bytes) provided as hex strings.
    key_hex = "000102030405060708090a0b0c0d0e0f"
    # For example, use a ciphertext produced from a known encryption.
    ciphertext_hex = "69c4e0d86a7b0430d8cdb78070b4c55a"
    
    key = bytes.fromhex(key_hex)
    ciphertext = bytes.fromhex(ciphertext_hex)
    
    print("Key:         ", key_hex)
    print("Ciphertext:  ", ciphertext_hex)
    print("====================================")
    
    plaintext = aes_decrypt(ciphertext, key)
    
    print("\nFinal Decrypted Plaintext:", plaintext.hex())

if __name__ == '__main__':
    main()
