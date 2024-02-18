# Sanitizer API bug reproduce

## Description

[`Sanitizer_ResourceMemoryData::flags`](https://docs.nvidia.com/compute-sanitizer/SanitizerApi/modules.html#group__SANITIZER__CALLBACK__API_1g7bee77cc4075471b0397cf557c843c4a) is used to further describe an allocation.

Here is the possible values of `Sanitizer_ResourceMemoryData::flags` from the `sanitizer_callbacks.h` header file.
`SANITIZER_MEMORY_FLAG_MANAGED` == 0x2 in the header file, but the flag == 0x6 in the callback when it's a managed allocation. (No flags == 0x6 in the header file.)

```c
/**
 * \brief Flags describing a memory allocation.
 *
 * Flags describing a memory allocation. These values are to
 * be used in order to interpret the value of
 * \ref Sanitizer_ResourceMemoryData::flags
 */
typedef enum {
    /**
     * Empty flag.
     */
    SANITIZER_MEMORY_FLAG_NONE            = 0,

    /**
     * Specifies that the allocation is static scoped to a
     * module.
     */
    SANITIZER_MEMORY_FLAG_MODULE          = 0x1,

    /**
     * Specifies that the allocation is managed memory.
     */
    SANITIZER_MEMORY_FLAG_MANAGED         = 0x2,

    /**
     * Species that the allocation accessible from the
     * host.
     */
    SANITIZER_MEMORY_FLAG_HOST_MAPPED     = 0x4,

    /**
     * Specifies that the allocation is pinned on the host.
     */
    SANITIZER_MEMORY_FLAG_HOST_PINNED     = 0x8,

    /**
     * Specifies that the allocation is located on a peer GPU.
     */
    SANITIZER_MEMORY_FLAG_PEER            = 0x10,

    /**
     * Specifies that the allocation is located on a peer GPU
     * supporting native atomics. This implies that
     * SANITIZER_MEMORY_FLAG_PEER is set as well.
     */
    SANITIZER_MEMORY_FLAG_PEER_ATOMIC     = 0x20,

    /**
     * Specifies that the allocation is used by the
     * Cooperative Groups runtime functions.
     */
    SANITIZER_MEMORY_FLAG_CG_RUNTIME      = 0x40,

    /**
     * Specifies that this is an allocation used for
     * CUDA Dynamic Parallelism purposes.
     */
    SANITIZER_MEMORY_FLAG_CNP              = 0x80,

    SANITIZER_MEMORY_FLAG_FORCE_INT        = 0x7fffffff
} Sanitizer_ResourceMemoryFlags;
```


## Reproduce the bug

I was able to reproduce the bug in the latest CUDA (version 12.3).

```shell
make

./run_reproduce_bug.sh
```