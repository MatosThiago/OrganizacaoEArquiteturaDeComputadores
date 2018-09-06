#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define MEM_SIZE 4096
int32_t mem[MEM_SIZE];

void specification_test();
void other_test();

void sw(uint32_t address, int16_t kte, int32_t dado);
void sh(uint32_t address, int16_t kte, int16_t dado);
void sb(uint32_t address, int16_t kte, int8_t dado);
int32_t  lw(uint32_t address, int16_t kte);
int32_t  lh(uint32_t address, int16_t kte);
uint32_t lhu(uint32_t address, int16_t kte);
int32_t  lb(uint32_t address, int16_t kte);
uint32_t lbu(uint32_t address, int16_t kte);
void dump_mem(uint32_t add, uint32_t size);

int main() {

    printf("\tSPECIFICATION TEST\n\n");
    specification_test();
    printf("\n\tOTHER TEST\n\n");
    other_test();

    return 0;
}

void specification_test() {
    memset(mem, 0, MEM_SIZE);

    sb(0, 0, 0x04); sb(0, 1, 0x03); sb(0, 2, 0x02); sb(0, 3, 0x01);
    sb(4, 0, 0xFF); sb(4, 1, 0xFE); sb(4, 2, 0xFD); sb(4, 3, 0xFC);
    sh(8, 0, 0xFFF0); sh(8, 2, 0x8C);
    sw(12, 0, 0xFF);
    sw(16, 0, 0xFFFF);
    sw(20, 0, 0xFFFFFFFF);
    sw(24, 0, 0x80000000);

    dump_mem(0, 28);

    printf("\n");

    lb(0,0); lb(0,1); lb(0,2); lb(0,3);
    lb(4,0); lb(4,1); lb(4,2); lb(4,3);
    lbu(4,0); lbu(4,1); lbu(4,2); lbu(4,3);
    lh(8,0); lh(8,2);
    lhu(8,0); lhu(8,2);
    lw(12,0); lw(16, 0); lw(20,0);
}

void other_test() {
    memset(mem, 0, MEM_SIZE);

    int32_t l;

    sw(0, 1, 0xFFFF7777);
    sw(0, 0, 0xFFFF7777);
    l = lw(0, 0);
    sw(4, 0, l);

    sh(8, 1, 0xFFFF);
    sh(8, 2, 0xFFFF);
    l = lh(8, 2);
    sh(8, 0, l);

    sb(12, 1, 0x55);
    l = lb(12, 1);
    sb(12, 3, l);

    dump_mem(0, 16);
}

void sw(uint32_t address, int16_t kte, int32_t dado) {
    address += kte;

    if(address % 4 != 0) {
        printf("Endereco Invalido\n");
        return;
    }

    mem[address/4] = dado;
}

void sh(uint32_t address, int16_t kte, int16_t dado) {
    address += kte;

    if(address % 2 != 0) {
        printf("Endereco Invalido\n");
        return;
    }

    int32_t result;
    uint16_t aux;

    if(address % 4 != 0) {
        aux = mem[address/4];
        result = (dado << 16) | aux;
        mem[address/4] = result;
        return;
    }
    
    aux = mem[address/4] >> 16;
    result = (aux << 16) | dado;
    mem[address/4] = result;
}

void sb(uint32_t address, int16_t kte, int8_t dado) {
    address += kte;

    int32_t result;
    uint8_t a,
            b,
            c,
            d;
    
    a = mem[address/4] >> 24;
    b = mem[address/4] >> 16;
    c = mem[address/4] >> 8;
    d = mem[address/4];

    if(kte == 0) {
        result = (a << 24) | (b << 16) | (c << 8) | dado;
    } else if(kte == 1) {
        result = (a << 24) | (b << 16) | (dado << 8) | d;
    } else if(kte == 2) {
        result = (a << 24) | (dado << 16) | (c << 8) | d;
    } else {
        result = (dado << 24) | (b << 16) | (c << 8) | d;
    }

    mem[address/4] = result;
}

int32_t lw(uint32_t address, int16_t kte) {
    int32_t result;
    address += kte;

    if(address % 4 != 0) {
        printf("Endereco Invalido\n");
        return result;
    }

    result = mem[address/4];
    printf("lw(%d, %d) = 0x%.8x ou %d\n", (address - kte), kte, result, result);
    return result;
}

int32_t lh(uint32_t address, int16_t kte) {
    uint16_t result;
    address += kte;

    if(address % 2 != 0) {
        printf("Endereco Invalido\n");
    } else {
        if(address % 4 != 0) {
            result = mem[address/4] >> 16;
        } else {
            result = mem[address/4];
        }
        printf("lh(%d, %d) = 0x%.4x ou %d\n", (address - kte), kte, result, (int16_t)result);
    }
    
    return (int32_t)result;
}

uint32_t lhu(uint32_t address, int16_t kte) {
    uint16_t result;
    address += kte;

    if(address % 2 != 0) {
        printf("Endereco Invalido\n");
    } else {
        if(address % 4 != 0) {
            result = mem[address/4] >> 16;
        } else {
            result = mem[address/4];
        }
        printf("lhu(%d, %d) = %d\n", (address - kte), kte, result);
    }

    return (uint32_t)result;
}

int32_t lb(uint32_t address, int16_t kte) {
    uint8_t result;
    address += kte;

    if(kte == 0) {
        result = mem[address/4];
    } else if(kte == 1) {
        result = mem[address/4] >> 8;
    } else if(kte == 2) {
        result = mem[address/4] >> 16;
    } else {
        result = mem[address/4] >> 24;
    }
    
    printf("lb(%d, %d) = 0x%.2x ou %d\n", (address - kte), kte, result, (int8_t)result);
    return (int32_t)result;
}

uint32_t lbu(uint32_t address, int16_t kte) {
    uint8_t result;
    address += kte;

    if(kte == 0) {
        result = mem[address/4];
    } else if(kte == 1) {
        result = mem[address/4] >> 8;
    } else if(kte == 2) {
        result = mem[address/4] >> 16;
    } else {
        result = mem[address/4] >> 24;
    }
    
    printf("lbu(%d, %d) = %d\n", (address - kte), kte, result);
    return (uint32_t)result;
}

void dump_mem(uint32_t add, uint32_t size) {
    for(int i = add; i < add + size; i += 4) {
        printf("mem[%d] = %.8x\n", i/4, mem[i/4]);
    }
}
