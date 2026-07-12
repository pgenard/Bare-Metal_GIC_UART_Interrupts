#include "string.h"

unsigned int strlen(const char *s)
{
    unsigned int n = 0;

    while (*s++)
        n++;

    return n;
}

int strcmp(const char *s1, const char *s2)
{
    while (*s1 && (*s1 == *s2))
    {
        s1++;
        s2++;
    }

    return (unsigned char)*s1 - (unsigned char)*s2;
}

int strncmp(const char *s1, const char *s2, unsigned int n)
{
    while (n--) {
        unsigned char c1 = *s1++;
        unsigned char c2 = *s2++;

        if (c1 != c2)
            return c1 - c2;

        if (c1 == '\0')
            return 0;
    }

    return 0;
}
