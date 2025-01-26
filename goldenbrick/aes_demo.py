from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
from Crypto.Random import get_random_bytes
import binascii

def aes_encrypt_decrypt_demo():
    # Step 1: Key and Plaintext
    key = get_random_bytes(16)  # 16 bytes = 128-bit key
    plaintext = b"This is a secret message!"
    print("Original Plaintext:", plaintext.decode())

    # Step 2: Encryption
    cipher = AES.new(key, AES.MODE_CBC)  # Using CBC mode
    iv = cipher.iv  # Initialization Vector
    ciphertext = cipher.encrypt(pad(plaintext, AES.block_size))  # Pad and encrypt
    print("\nEncrypted Ciphertext (hex):", ciphertext.hex())

    # Step 3: Decryption
    decipher = AES.new(key, AES.MODE_CBC, iv)  # Recreate cipher with the same IV
    decrypted_plaintext = unpad(decipher.decrypt(ciphertext), AES.block_size)  # Decrypt and unpad
    print("\nDecrypted Plaintext:", decrypted_plaintext.decode())

# Helper function to format data in hexadecimal
def print_state(label, data):
    print(f"{label}: {binascii.hexlify(data).decode()}")

def aes_step_by_step_demo():
    # Step 1: Key and Plaintext
    key = get_random_bytes(16)  # Generate a random 128-bit key
    # plaintext = b"Simple AES Example"
    plaintext = get_random_bytes(16)  # Generate a random 16-byte plaintext
    print("=== AES Step-by-Step Process ===")
    print_state("Original Plaintext:", plaintext)
    print_state("Encryption Key", key)

    # Step 2: Padding (to align to AES block size)
    block_size = AES.block_size  # AES block size (16 bytes)
    padded_plaintext = plaintext
    print("\n--- Step 1: Pad Plaintext ---")
    print_state("Padded Plaintext", padded_plaintext)

    # Step 3: Initialize AES in ECB mode for step-by-step clarity
    cipher = AES.new(key, AES.MODE_ECB)

    # Step 4: Initial AddRoundKey
    state = bytearray(padded_plaintext)
    round_key = key
    for i in range(0,16):
        state[i] ^= round_key[i]  # XOR plaintext with the key
    print("\n--- Step 2: Initial AddRoundKey ---")
    print_state("State After AddRoundKey", state)

    # Step 5: SubBytes
    s_box = [
    0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
    0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
    0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
    0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
    0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
    0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
    0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
    0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
    0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
    0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
    0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
    0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
    0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
    0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
    0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
    0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
    ]

    state = bytearray(s_box[byte] for byte in state)  # Substitute bytes using the S-box
    print("\n--- Step 3: SubBytes ---")
    print_state("State After SubBytes", state)

    # Step 6: ShiftRows
    def shift_rows(state):
        rows = [state[i::4] for i in range(4)]  # Break into rows
        for i in range(4):
            rows[i] = rows[i][i:] + rows[i][:i]  # Shift each row by its index
        return bytearray(sum(zip(*rows), ()))

    state = shift_rows(state)
    print("\n--- Step 4: ShiftRows ---")
    print_state("State After ShiftRows", state)

    # Step 7: MixColumns
    def mix_columns(state):
        # Define GF(2^8) multiplication
        def gmul(a, b):
            p = 0
            for _ in range(8):
                if b & 1:
                    p ^= a
                high_bit = a & 0x80
                a = (a << 1) & 0xFF
                if high_bit:
                    a ^= 0x1B  # Irreducible polynomial
                b >>= 1
            return p

        # Mix each column
        columns = [state[i:i + 4] for i in range(0, len(state), 4)]
        mixed = []
        for col in columns:
            mixed.extend([
                gmul(2, col[0]) ^ gmul(3, col[1]) ^ col[2] ^ col[3],
                col[0] ^ gmul(2, col[1]) ^ gmul(3, col[2]) ^ col[3],
                col[0] ^ col[1] ^ gmul(2, col[2]) ^ gmul(3, col[3]),
                gmul(3, col[0]) ^ col[1] ^ col[2] ^ gmul(2, col[3]),
            ])
        return bytearray(mixed)

    state = mix_columns(state)
    print("\n--- Step 5: MixColumns ---")
    print_state("State After MixColumns", state)

    # Step 8: Final AddRoundKey (simplified for demonstration)
    round_key = get_random_bytes(16)  # Generate a new round key (demo)
    for i in range(0,16):
        state[i] ^= round_key[i]
    print("\n--- Step 6: Final AddRoundKey ---")
    print_state("Final Encrypted State", state)

    print("\n=== AES Encryption Completed ===")

if __name__ == "__main__":
    aes_step_by_step_demo()
    # aes_encrypt_decrypt_demo()


