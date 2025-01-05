#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include <windows.h> // For dynamic loading

#define HELIUS_RPC_URL "https://rpc.helius.xyz/v1/your-api-key" // Replace with your Helius API URL
#define AUTH_HEADER "Authorization: your-api-key"              // Replace with your API key

// Structure to hold API response
struct response_data {
    char *data;
    size_t size;
};

// Callback function for CURL response
size_t write_callback(void *contents, size_t size, size_t nmemb, void *userp) {
    size_t total_size = size * nmemb;
    struct response_data *res = (struct response_data *)userp;

    char *ptr = realloc(res->data, res->size + total_size + 1);
    if (ptr == NULL) {
        fprintf(stderr, "Failed to allocate memory for response data.\n");
        return 0;
    }

    res->data = ptr;
    memcpy(&(res->data[res->size]), contents, total_size);
    res->size += total_size;
    res->data[res->size] = '\0';

    return total_size;
}

void sign_and_send_transaction() {
    CURL *curl;
    CURLcode res;
    struct response_data helius_response = {NULL, 0};
    struct curl_slist *headers = NULL;

    // Load Rust DLL
    HMODULE rust_lib = LoadLibrary("solana_sdk_wrapper.dll");
    if (!rust_lib) {
        fprintf(stderr, "Failed to load solana_sdk_wrapper.dll.\n");
        return;
    }

    // Get the Rust sign_transaction function
    typedef char *(*SignTransactionFn)(const unsigned char *, size_t, const char *, const char *);
    SignTransactionFn sign_transaction = (SignTransactionFn)GetProcAddress(rust_lib, "sign_transaction");
    if (!sign_transaction) {
        fprintf(stderr, "Failed to load function 'sign_transaction'.\n");
        FreeLibrary(rust_lib);
        return;
    }

    // Example unsigned transaction payload
    unsigned char unsigned_tx[] = {/* Unsigned transaction bytes here */};
    size_t unsigned_tx_len = sizeof(unsigned_tx);

    // Step 1: Sign the transaction using the Rust library
    char *signed_transaction = sign_transaction(
        unsigned_tx,
        unsigned_tx_len,
        "your-mint-private-key",  // Replace with Base58 private key
        "your-creator-private-key" // Replace with Base58 private key
    );

    if (!signed_transaction || strncmp(signed_transaction, "Error:", 6) == 0) {
        fprintf(stderr, "Failed to sign transaction: %s\n", signed_transaction);
        FreeLibrary(rust_lib);
        return;
    }
    printf("Signed Transaction:\n%s\n", signed_transaction);

    // Step 2: Forward the signed transaction to Helius RPC
    char helius_payload[2048];
    snprintf(helius_payload, sizeof(helius_payload),
             "{\n"
             "  \"jsonrpc\": \"2.0\",\n"
             "  \"id\": 1,\n"
             "  \"method\": \"sendTransaction\",\n"
             "  \"params\": [\n"
             "    \"%s\",\n"
             "    {\n"
             "      \"encoding\": \"base58\"\n"
             "    }\n"
             "  ]\n"
             "}",
             signed_transaction);

    printf("Payload Sent to Helius RPC:\n%s\n", helius_payload);

    curl = curl_easy_init();
    if (curl) {
        headers = curl_slist_append(headers, AUTH_HEADER);
        headers = curl_slist_append(headers, "Content-Type: application/json");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
        curl_easy_setopt(curl, CURLOPT_URL, HELIUS_RPC_URL);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, helius_payload);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)&helius_response);

        res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            fprintf(stderr, "Failed to send transaction to Helius RPC: %s\n", curl_easy_strerror(res));
        } else {
            printf("Helius Response:\n%s\n", helius_response.data);
        }

        if (signed_transaction) free(signed_transaction);
        if (headers) curl_slist_free_all(headers);
        if (helius_response.data) free(helius_response.data);
        curl_easy_cleanup(curl);
        FreeLibrary(rust_lib);
    }
}

int main() {
    sign_and_send_transaction();
    return 0;
}
