#!/usr/bin/env python3
"""
AES-128 Simulator in Python (No Padding)
Both key and plaintext are provided as 128-bit hex strings.
Displays the state after:
  - Initial AddRoundKey (pre-round)
  - Each of the 10 rounds
"""

# -----------------------
# AES S-box (256 entries)
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
# AES Basic Transformations (Rounds)
# -------------------------------------
def add_round_key(state, round_key):
    """XOR the state with the round key (both as 4x4 matrices)."""
    for r in range(4):
        for c in range(4):
            state[r][c] ^= round_key[r][c]
    return state

def sub_bytes(state):
    """Substitute each byte in the state using the AES S-box."""
    for r in range(4):
        for c in range(4):
            state[r][c] = SBOX[state[r][c]]
    return state

def shift_rows(state):
    """Shift the rows of the state to the left by the row index."""
    new_state = [row[:] for row in state]
    for r in range(4):
        new_state[r] = state[r][r:] + state[r][:r]
    return new_state

def xtime(a):
    """Multiply by 2 in GF(2^8)."""
    return ((a << 1) & 0xFF) ^ (0x1B if a & 0x80 else 0x00)

def mix_single_column(col):
    """Mix one column for MixColumns."""
    t = col[0] ^ col[1] ^ col[2] ^ col[3]
    u = col[0]
    col[0] ^= t ^ xtime(col[0] ^ col[1])
    col[1] ^= t ^ xtime(col[1] ^ col[2])
    col[2] ^= t ^ xtime(col[2] ^ col[3])
    col[3] ^= t ^ xtime(col[3] ^ u)
    return col

def mix_columns(state):
    """Apply MixColumns to the state (column by column)."""
    for c in range(4):
        # extract the column
        col = [state[r][c] for r in range(4)]
        col = mix_single_column(col)
        for r in range(4):
            state[r][c] = col[r]
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
# AES Encryption (Simulation)
# -----------------------------------
def aes_encrypt(plaintext, key):
    """
    Encrypt a 16-byte plaintext with a 16-byte key.
    Both inputs are bytes objects.
    Displays the state at the initial AddRoundKey and after each round.
    """
    # Convert plaintext into state matrix
    state = bytes_to_matrix(plaintext)
    
    # Get all round keys (11 round keys for AES-128)
    round_keys = get_round_keys(key)
    
    print("Initial Key (Round 0):")
    for row in round_keys[0]:
        print(' '.join(f"{b:02x}" for b in row))

    print(''.join(f"{b:02x}" for row in round_keys[0] for b in row))
    
    # Initial AddRoundKey
    state = add_round_key(state, round_keys[0])
    print("\nAfter Initial AddRoundKey:")
    for row in state:
        print(' '.join(f"{b:02x}" for b in row))

    # print(''.join(f"{b:02x}" for row in state for b in row))
    print(matrix_to_bytes(state).hex())
    
    # 9 Rounds with SubBytes, ShiftRows, MixColumns, and AddRoundKey
    for round in range(1, 10):
        state = sub_bytes(state)
        print(f"\nAfter Round {round} SubBytes:")
        print(matrix_to_bytes(state).hex())

        state = shift_rows(state)
        print(f"\nAfter Round {round} ShiftRows:")
        print(matrix_to_bytes(state).hex())

        state = mix_columns(state)
        print(f"\nAfter Round {round} MixColumns:")
        print(matrix_to_bytes(state).hex())

        state = add_round_key(state, round_keys[round])
        print(f"\nAfter Round {round}:")
        # for row in state:
        #     print(' '.join(f"{b:02x}" for b in row))
        print(matrix_to_bytes(state).hex())

        print(f"Round Key {round}: {matrix_to_bytes(round_keys[round]).hex()}")

    
    # Final round: SubBytes, ShiftRows, and AddRoundKey (no MixColumns)
    state = sub_bytes(state)
    state = shift_rows(state)
    state = add_round_key(state, round_keys[10])
    print(f"\nAfter Round 10 (Final Round):")
    # for row in state:
    #     print(' '.join(f"{b:02x}" for b in row))
    print(matrix_to_bytes(state).hex())
    
    return matrix_to_bytes(state)

# -----------------------------
# Main: Set key and plaintext
# -----------------------------
def main():
    # Example inputs (128-bit = 16 bytes)
    # They must be provided as hexadecimal strings.
    key_hex = "000102030405060708090a0b0c0d0e0f"
    plaintext_hex = "00112233445566778899aabbccddeeff"
    
    key = bytes.fromhex(key_hex)
    plaintext = bytes.fromhex(plaintext_hex)
    
    print("Key:       ", key_hex)
    print("Plaintext: ", plaintext_hex)
    print("====================================")
    
    ciphertext = aes_encrypt(plaintext, key)
    
    print("\nFinal Ciphertext:", ciphertext.hex())

    mat = bytes_to_matrix(plaintext)
    
    mat = shift_rows(mat)
    print(matrix_to_bytes(mat).hex())

    ans = ""


if __name__ == '__main__':
    main()
