void switch2(long x, long *dest) {
    long val = 0;
    switch (x)
    {
    case /* constant-expression */:
        /* code */
        break;
    
    default:
        break;
    }
}

void switcher(long a, long b, long c, long *dest)
{
    long val;
    switch (a) {
        case 5:
            c = b ^ 0x15; 
        case 0:
            val = c + 112;
            break;
        case 2:
        case 7:
            val = (b + c) << 2;
            break;
        default:
            val = b;
    }
    *dest = val;
}

long rfun(unsigned long x) {
    if (x == 0) 
        return 0;
    unsigned long nx = x >> 2;
    long rv = rfun(nx);
    return x + rv;
}