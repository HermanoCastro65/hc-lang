#include <stdio.h>

int main()
    int a = 20
    int b = 5
    int operation = 3
    int result = 0

    printf("Calculator Example\n")
    printf("a = %d, b = %d\n", a, b)

    switch (operation)
        case 1:
            result = a + b
            printf("Addition selected\n")
            break
        case 2:
            result = a - b
            printf("Subtraction selected\n")
            break
        case 3:
            result = a * b
            printf("Multiplication selected\n")
            break
        case 4:
            result = a / b
            printf("Division selected\n")
            break
        default:
            printf("Invalid operation\n")
            return 1

    printf("Result = %d\n", result)

    return 0