#include <stdio.h>

int attachbelow = 0;  // Начальное значение: 0 (отключено)

void loadAttachBelow() {
    FILE *file = fopen(".cache/dwm/attachbelow_state", "r");  // Файл состояния в текущей директории
    if (file) {
        fscanf(file, "%d", &attachbelow);
        fclose(file);
    }
}

void saveAttachBelow() {
    FILE *file = fopen(".cache/dwm/attachbelow_state", "w");  // Файл состояния в текущей директории
    if (file) {
        fprintf(file, "%d", attachbelow);
        fclose(file);
    }
}

