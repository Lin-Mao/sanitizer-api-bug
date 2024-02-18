#include <sanitizer.h>
#include <iostream>


void sanitizer_handle_callbacks(
    void* userdata,
    Sanitizer_CallbackDomain domain,
    Sanitizer_CallbackId cbid,
    const void* cbdata) {

    switch (domain) {
        case SANITIZER_CB_DOMAIN_RESOURCE:
            switch (cbid)
            {
                case SANITIZER_CBID_RESOURCE_DEVICE_MEMORY_ALLOC:
                {
                    Sanitizer_ResourceMemoryData *md = (Sanitizer_ResourceMemoryData *)cbdata;
                    std::cout << "md-flags: " << md->flags << std::endl;
                    if (md->flags == SANITIZER_MEMORY_FLAG_MANAGED) {
                        // This branch should be taken.
                        // SANITIZER_MEMORY_FLAG_MANAGED is 0x2, but md-flags == 0x6, no flags == 0x06 in the header file.
                        std::cout << "Allocating managed memory" << std::endl;
                    }
                    break;
                }
                default:
                        break;
            }
            break;
        default:
            break;

    }
}


int InitializeInjection()
{
    Sanitizer_SubscriberHandle handle;

    sanitizerSubscribe(&handle, sanitizer_handle_callbacks, nullptr);

    sanitizerEnableDomain(1, handle, SANITIZER_CB_DOMAIN_RESOURCE);

    return 0;
}


int __global_initializer__ = InitializeInjection();
