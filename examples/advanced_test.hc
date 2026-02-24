#include <stdio.h>

enum Color
    RED
    GREEN
    BLUE

typedef enum Status
    SUCCESS
    FAILURE
Status

static int global_counter = 0

int get_square(int x)
    return x * x

int main()
    const int size = 3
    int numbers[size]

    numbers[0] = 10
    numbers[1] = 20
    numbers[2] = 30

    enum Color favorite = GREEN
    Status result = SUCCESS

    for (int i = 0; i < size; i++)
        printf("Square of %d is %d\n", numbers[i], get_square(numbers[i]))

    printf("Favorite color enum value: %d\n", favorite)
    printf("Status enum value: %d\n", result)

    int value = (size > 2) ? 100 : 50
    printf("Ternary result: %d\n", value)

    printf("Size of numbers array: %lu\n", sizeof(numbers))

    return 0