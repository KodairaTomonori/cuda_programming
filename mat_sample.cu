#include <stdio.h>
#include <stdlib.h>

#define N 2

__global__ void matMul(int A[][N], int B[][N], int *C){
    int i = threadIdx.x;
    int j = threadIdx.y;

    C[i] += A[i][j] * B[i][j];
}


int main(){

  int A[N][N] = {{1,2},{3,4}};
  int B[N][N] = {{5,6},{7,8}};
  int C[N] = {0,0};    

  int (*pA)[N], (*pB)[N], (*pC);

  cudaMalloc((void**)&pA, (N*N)*sizeof(int));
  cudaMalloc((void**)&pB, (N*N)*sizeof(int));
  cudaMalloc((void**)&pC, (N*N)*sizeof(int));

  cudaMemcpy(pA, A, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(pB, B, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(pC, C, (N)*sizeof(int), cudaMemcpyHostToDevice);

  int numBlocks = 1;
  dim3 threadsPerBlock(N,N);
  matMul<<<numBlocks,threadsPerBlock>>>(pA,pB, pC);

  cudaMemcpy(C, pC, (N)*sizeof(int), cudaMemcpyDeviceToHost);

  int i; printf("C = \n");
  for(i=0;i<N;i++){
    printf("%d ", C[i]);
  }
  printf("\n");

  cudaFree(pA); 
  cudaFree(pB); 
  cudaFree(pC);

  printf("\n");

  return 0;
}
