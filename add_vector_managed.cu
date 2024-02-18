#include <cuda_runtime.h>
#include <iostream>

__global__ void vectorAdd(float *a, float *b, float *c, int n) {
    int i = threadIdx.x + blockDim.x * blockIdx.x;
    if (i < n)
        c[i] = a[i] + b[i];
}

int main() {
    float *a, *b, *c;
    int n = 1 << 20;

    // Allocate managed memory
    cudaMallocManaged(&a, n * sizeof(float));
    std::cout << "Managed memory allocated: a" << std::endl;

    cudaMallocManaged(&b, n * sizeof(float));
    std::cout << "Managed memory allocated: b" << std::endl;

    cudaMallocManaged(&c, n * sizeof(float));
    std::cout << "Managed memory allocated: c" << std::endl;

    // Initialize vectors
    for (int i = 0; i < n; i++) {
        a[i] = i;
        b[i] = i;
    }

    // Define grid and block dimensions
    int blockSize = 256;
    int gridSize = (n + blockSize - 1) / blockSize;

    // Launch kernel
    vectorAdd<<<gridSize, blockSize>>>(a, b, c, n);

    // Wait for GPU to finish
    cudaDeviceSynchronize();

    // Check for errors
    cudaError_t error = cudaGetLastError();
    if(error != cudaSuccess) {
        fprintf(stderr, "Error: %s\n", cudaGetErrorString(error));
        return -1;
    }

    // Free memory
    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
    std::cout << "Done!" << std::endl;

    return 0;
}
