PROJECT ?= libcompute-sanitizer.so
SRCS := $(wildcard *.cc)

CUDA_PATH      ?= /usr/local/cuda
SANITIZER_PATH ?= $(CUDA_PATH)/compute-sanitizer

HOST_COMPILER  ?= g++
NVCC           := $(CUDA_PATH)/bin/nvcc -ccbin $(HOST_COMPILER)

INCLUDE_FLAGS  := -I$(CUDA_PATH)/include -I$(SANITIZER_PATH)/include

LINK_FLAGS     := -L$(SANITIZER_PATH) -fPIC -shared

LINK_LIBS      := -lsanitizer-public

################################################################################

# Target rules
all: sanitizer-build app-build

sanitizer-build:
	$(HOST_COMPILER) $(INCLUDE_FLAGS) $(LINK_FLAGS) -o $(PROJECT) $(SRCS) $(LINK_LIBS)

app-build:
	$(NVCC) -o add_vector_managed add_vector_managed.cu

clean:
	rm -rf $(PROJECT) add_vector_managed

clobber: clean
