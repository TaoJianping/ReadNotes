int A[5][3];

typedef int row3_t[3];
row3_t A[5];

#define N 16
typedef int fix_matrix[N][N];

/* Compute i, k of fixed matrix product */
int fix_prod_ele(fix_matrix A, fix_matrix B, long i, long k) {
    long j;
    int result = 0;

    for (j = 0; j < N; j++)
    {
        result += A[i][j] * B[j][k];
    }

    return result;
}