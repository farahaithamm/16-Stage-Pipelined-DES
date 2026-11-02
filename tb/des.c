#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
/*
* CSE451 - Assignment 1: DES
* Team members:
 *   1. Name: Aya Mohamed Mohamed Kamel   ID: 2200716
 *   2. Name: Aaesha Mahmod Bedair        ID: 2200510
 *   3. Name: Salma Ramadan Mohamed       ID: 2200381
 *   4. Name: Menna Ayman Hassan          ID: 2200236
 *   5. Name: Farah Haitham Saddik        ID: 2200485
*/

typedef unsigned char      u8;
typedef unsigned int       u32;
typedef unsigned long long u64;

/* DES permutation and substitution tables*/

static const u8 IP[64] = {
    58,50,42,34,26,18,10, 2, 60,52,44,36,28,20,12, 4,
    62,54,46,38,30,22,14, 6, 64,56,48,40,32,24,16, 8,
    57,49,41,33,25,17, 9, 1, 59,51,43,35,27,19,11, 3,
    61,53,45,37,29,21,13, 5, 63,55,47,39,31,23,15, 7
};

static const u8 FP[64] = {
    40, 8,48,16,56,24,64,32, 39, 7,47,15,55,23,63,31,
    38, 6,46,14,54,22,62,30, 37, 5,45,13,53,21,61,29,
    36, 4,44,12,52,20,60,28, 35, 3,43,11,51,19,59,27,
    34, 2,42,10,50,18,58,26, 33, 1,41, 9,49,17,57,25
};

static const u8 P[32] = {
    16, 7,20,21,29,12,28,17,  1,15,23,26, 5,18,31,10,
     2, 8,24,14,32,27, 3, 9, 19,13,30, 6,22,11, 4,25
};

static const u8 PC1[56] = {
    57,49,41,33,25,17, 9,  1,58,50,42,34,26,18,
    10, 2,59,51,43,35,27, 19,11, 3,60,52,44,36,
    63,55,47,39,31,23,15,  7,62,54,46,38,30,22,
    14, 6,61,53,45,37,29, 21,13, 5,28,20,12, 4
};

static const u8 PC2[48] = {
    14,17,11,24, 1, 5,  3,28,15, 6,21,10,
    23,19,12, 4,26, 8, 16, 7,27,20,13, 2,
    41,52,31,37,47,55, 30,40,51,45,33,48,
    44,49,39,56,34,53, 46,42,50,36,29,32
};

static const u8 SHIFTS[16] = { 1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1 };

static const u8 SBOX[8][64] = {
  { 14, 4,13, 1, 2,15,11, 8, 3,10, 6,12, 5, 9, 0, 7,
     0,15, 7, 4,14, 2,13, 1,10, 6,12,11, 9, 5, 3, 8,
     4, 1,14, 8,13, 6, 2,11,15,12, 9, 7, 3,10, 5, 0,
    15,12, 8, 2, 4, 9, 1, 7, 5,11, 3,14,10, 0, 6,13 },
  { 15, 1, 8,14, 6,11, 3, 4, 9, 7, 2,13,12, 0, 5,10,
     3,13, 4, 7,15, 2, 8,14,12, 0, 1,10, 6, 9,11, 5,
     0,14, 7,11,10, 4,13, 1, 5, 8,12, 6, 9, 3, 2,15,
    13, 8,10, 1, 3,15, 4, 2,11, 6, 7,12, 0, 5,14, 9 },
  { 10, 0, 9,14, 6, 3,15, 5, 1,13,12, 7,11, 4, 2, 8,
    13, 7, 0, 9, 3, 4, 6,10, 2, 8, 5,14,12,11,15, 1,
    13, 6, 4, 9, 8,15, 3, 0,11, 1, 2,12, 5,10,14, 7,
     1,10,13, 0, 6, 9, 8, 7, 4,15,14, 3,11, 5, 2,12 },
  { 7,13,14, 3, 0, 6, 9,10, 1, 2, 8, 5,11,12, 4,15,
    13, 8,11, 5, 6,15, 0, 3, 4, 7, 2,12, 1,10,14, 9,
    10, 6, 9, 0,12,11, 7,13,15, 1, 3,14, 5, 2, 8, 4,
     3,15, 0, 6,10, 1,13, 8, 9, 4, 5,11,12, 7, 2,14 },
  { 2,12, 4, 1, 7,10,11, 6, 8, 5, 3,15,13, 0,14, 9,
    14,11, 2,12, 4, 7,13, 1, 5, 0,15,10, 3, 9, 8, 6,
     4, 2, 1,11,10,13, 7, 8,15, 9,12, 5, 6, 3, 0,14,
    11, 8,12, 7, 1,14, 2,13, 6,15, 0, 9,10, 4, 5, 3 },
  { 12, 1,10,15, 9, 2, 6, 8, 0,13, 3, 4,14, 7, 5,11,
    10,15, 4, 2, 7,12, 9, 5, 6, 1,13,14, 0,11, 3, 8,
     9,14,15, 5, 2, 8,12, 3, 7, 0, 4,10, 1,13,11, 6,
     4, 3, 2,12, 9, 5,15,10,11,14, 1, 7, 6, 0, 8,13 },
  { 4,11, 2,14,15, 0, 8,13, 3,12, 9, 7, 5,10, 6, 1,
    13, 0,11, 7, 4, 9, 1,10,14, 3, 5,12, 2,15, 8, 6,
     1, 4,11,13,12, 3, 7,14,10,15, 6, 8, 0, 5, 9, 2,
     6,11,13, 8, 1, 4,10, 7, 9, 5, 0,15,14, 2, 3,12 },
  { 13, 2, 8, 4, 6,15,11, 1,10, 9, 3,14, 5, 0,12, 7,
     1,15,13, 8,10, 3, 7, 4,12, 5, 6,11, 0,14, 9, 2,
     7,11, 4, 1, 9,12,14, 2, 0, 6,10,13,15, 3, 5, 8,
     2, 1,14, 7, 4,10, 8,13,15,12, 9, 0, 3, 5, 6,11 }
};

static u64 IP_T[8][256];   /* initial permutation, one table per input byte */
static u64 FP_T[8][256];   /* final permutation,   one table per input byte */
static u32 SP[8][64];      /* S-box substitution fused with the P permutation */
static u8  subkey[16][8];  /* 16 round keys, each as eight 6-bit groups */

/* Generic bit permutation (used by init_tables and key_schedule) */
static u64 permute(u64 in, const u8* table, int n_out, int n_in)
{
    u64 out = 0;
    int i;
    for (i = 0; i < n_out; i++)
        out = (out << 1) | ((in >> (n_in - table[i])) & 1ULL);
    return out;
}

static u32 rotr32(u32 x, int n) { return (x >> n) | (x << (32 - n)); }
static u32 rotl32(u32 x, int n) { return (x << n) | (x >> (32 - n)); }

static void init_tables(void)
{
    int b, v, s;

    /* Precompute lookup tables for the initial and final permutations */
    for (b = 0; b < 8; b++) {
        for (v = 0; v < 256; v++) {
            u64 x = (u64)v << (56 - 8 * b);
            IP_T[b][v] = permute(x, IP, 64, 64);
            FP_T[b][v] = permute(x, FP, 64, 64);
        }
    }

    /* Precompute tables combining S-box substitution and P permutation */
    for (s = 0; s < 8; s++) {
        for (v = 0; v < 64; v++) {
            int row = ((v & 0x20) >> 4) | (v & 1);   /* outer bits */
            int col = (v >> 1) & 0xF;                /* inner 4 bits */
            u32 out = (u32)SBOX[s][row * 16 + col] << (28 - 4 * s);
            SP[s][v] = (u32)permute(out, P, 32, 32);
        }
    }
}

/* Build the 16 round keys from the 64-bit key. */
static void key_schedule(u64 key)
{
    u64 cd = permute(key, PC1, 56, 64);
    u32 c = (u32)(cd >> 28) & 0x0FFFFFFF;
    u32 d = (u32)cd & 0x0FFFFFFF;
    int r, i;

    for (r = 0; r < 16; r++) {
        for (i = 0; i < SHIFTS[r]; i++) {            /* 28-bit rotate left */
            c = ((c << 1) | (c >> 27)) & 0x0FFFFFFF;
            d = ((d << 1) | (d >> 27)) & 0x0FFFFFFF;
        }
        u64 k = permute(((u64)c << 28) | d, PC2, 48, 56);
        for (i = 0; i < 8; i++)
            subkey[r][i] = (u8)((k >> (42 - 6 * i)) & 0x3F);
    }
}

/* DES round function f(R, K): expansion, key mixing, S-boxes + P. */
static inline u32 feistel(u32 r, const u8* k)
{
    u32 t = rotr32(r, 1);   /* groups 0..6 come from here */
    u32 u = rotl32(r, 1);   /* group 7 comes from here    */
    return SP[0][((t >> 26) & 0x3F) ^ k[0]]
        | SP[1][((t >> 22) & 0x3F) ^ k[1]]
        | SP[2][((t >> 18) & 0x3F) ^ k[2]]
        | SP[3][((t >> 14) & 0x3F) ^ k[3]]
        | SP[4][((t >> 10) & 0x3F) ^ k[4]]
        | SP[5][((t >> 6) & 0x3F) ^ k[5]]
        | SP[6][((t >> 2) & 0x3F) ^ k[6]]
        | SP[7][(u & 0x3F) ^ k[7]];
}

/* Encrypt (decrypt=0) or decrypt (decrypt=1) one 64-bit block. */
static inline u64 des_block(u64 x, int decrypt)
{
    u64 ip = 0, out = 0;
    u32 l, r, tmp;
    int i, b;

    for (b = 0; b < 8; b++) ip |= IP_T[b][(x >> (56 - 8 * b)) & 0xFF];

    l = (u32)(ip >> 32);
    r = (u32)ip;

    for (i = 0; i < 16; i++) {
        const u8* k = decrypt ? subkey[15 - i] : subkey[i];
        tmp = r;
        r = l ^ feistel(r, k);
        l = tmp;
    }

    ip = ((u64)r << 32) | l;   /* final swap (R16 L16) */
    for (b = 0; b < 8; b++) out |= FP_T[b][(ip >> (56 - 8 * b)) & 0xFF];
    return out;
}

/* Convert a hexadecimal character to its value. */
static int hexval(int c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

/* Read a key from a file. */
static int read_key(const char* name, u64* key)
{
    u8 buf[64];
    size_t n, i;
    FILE* f = fopen(name, "rb");
    if (!f) return 0;
    n = fread(buf, 1, sizeof buf, f);
    fclose(f);

    if (n == 8) {
        u64 k = 0;
        for (i = 0; i < 8; i++) k = (k << 8) | buf[i];
        *key = k;
        return 1;
    }
    if (n >= 16) {
        u64 k = 0;
        for (i = 0; i < 16; i++) {
            int h = hexval(buf[i]);
            if (h < 0) return 0;
            k = (k << 4) | (u64)h;
        }
        *key = k;
        return 1;
    }
    return 0;
}

#define BUF_SIZE (1 << 20)          /* 1 MiB, multiple of 8 */
static u8 buffer[BUF_SIZE];

/* Encrypt or decrypt a sequence of 8-byte blocks in place. */
static void crypt_blocks(u8* b, size_t n, int decrypt)
{
    size_t i;
    for (i = 0; i < n; i += 8) {
        u64 x = ((u64)b[i] << 56) | ((u64)b[i + 1] << 48) |
            ((u64)b[i + 2] << 40) | ((u64)b[i + 3] << 32) |
            ((u64)b[i + 4] << 24) | ((u64)b[i + 5] << 16) |
            ((u64)b[i + 6] << 8) | (u64)b[i + 7];
        x = des_block(x, decrypt);
        b[i] = (u8)(x >> 56); b[i + 1] = (u8)(x >> 48);
        b[i + 2] = (u8)(x >> 40); b[i + 3] = (u8)(x >> 32);
        b[i + 4] = (u8)(x >> 24); b[i + 5] = (u8)(x >> 16);
        b[i + 6] = (u8)(x >> 8); b[i + 7] = (u8)x;
    }
}

/* Determine the size of an open binary file. */
static int input_size(FILE* f, long* size)
{
    long s;
    if (fseek(f, 0L, SEEK_END) != 0) return 0;
    s = ftell(f);
    if (fseek(f, 0L, SEEK_SET) != 0) return -1;
    if (s < 0) return 0;
    *size = s;
    return 1;
}

#ifdef _WIN32
__declspec(dllexport)
#endif
unsigned long long des_ref_c(unsigned long long data, unsigned long long key, int enc)
{
    static int ready = 0;
    if (!ready) {
        init_tables();
        ready = 1;
    }
    key_schedule(key);
    return des_block(data, enc ? 0 : 1);
}

#ifndef DES_NO_MAIN
int main(int argc, char** argv)
{
    int decrypt, st;
    u64 key;
    long size = 0;
    FILE* in, * out;
    size_t n;

    if (argc != 5 || !((argv[1][0] == 'e' || argv[1][0] == 'd') && !argv[1][1])) {
        fprintf(stderr, "Usage: %s \"e\"|\"d\" key input output\n", argv[0]);
        return 1;
    }
    decrypt = (argv[1][0] == 'd');

    if (!read_key(argv[2], &key)) {
        fprintf(stderr, "Error: cannot read a valid key from %s\n", argv[2]);
        return 1;
    }

    in = fopen(argv[3], "rb");
    if (!in) { fprintf(stderr, "Error: cannot open %s\n", argv[3]); return 1; }

    /* Reject an invalid length BEFORE creating the output file. */
    st = input_size(in, &size);
    if (st < 0) {
        fprintf(stderr, "Error: cannot read %s\n", argv[3]);
        fclose(in);
        return 1;
    }
    if (st == 1 && size % 8 != 0) {
        fprintf(stderr, "Error: %s is %ld bytes; the length must be a multiple of 8 "
            "(no padding is used)\n", argv[3], size);
        fclose(in);
        return 1;
    }

    out = fopen(argv[4], "wb");
    if (!out) {
        fprintf(stderr, "Error: cannot create %s\n", argv[4]);
        fclose(in);
        return 1;
    }

    init_tables();
    key_schedule(key);
    /* 	Read, encrypt or decrypt, and write the file in blocks. */
    while ((n = fread(buffer, 1, BUF_SIZE, in)) > 0) {
        if (n & 7) {
            fprintf(stderr, "Error: %s ends with an incomplete block (%u extra byte(s)); "
                "the length must be a multiple of 8\n",
                argv[3], (unsigned)(n & 7));
            fclose(in); fclose(out);
            return 1;
        }
        crypt_blocks(buffer, n, decrypt);
        if (fwrite(buffer, 1, n, out) != n) {
            fprintf(stderr, "Error: write failed\n");
            fclose(in); fclose(out);
            return 1;
        }
    }
    if (ferror(in)) {
        fprintf(stderr, "Error: read failed on %s\n", argv[3]);
        fclose(in); fclose(out);
        return 1;
    }

    fclose(in);
    if (fclose(out) != 0) {
        fprintf(stderr, "Error: write failed\n");
        return 1;
    }
    return 0;
}
#endif /* DES_NO_MAIN */
