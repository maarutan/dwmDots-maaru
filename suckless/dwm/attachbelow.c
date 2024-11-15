#include <stdio.h>

int attachbelow = 0;  // Начальное значение: 0 (отключено)

void loadAttachBelow() {
    FILE *file = fopen("/tmp/attachbelow.txt", "r");  // Файл состояния в текущей директории
    if (file) {
        fscanf(file, "%d", &attachbelow);
        fclose(file);
    }
}

void saveAttachBelow() {
    FILE *file = fopen("/tmp/attachbelow.txt", "w");  // Файл состояния в текущей директории
    if (file) {
        fprintf(file, "%d", attachbelow);
        fclose(file);
    }
}

