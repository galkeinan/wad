#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

#include <libwebsockets.h>

#define WA_EVENT_PROTOCOL_NAME "wa-event" // TODO extract to ENV

static int 
callback_http(struct lws *wsi, enum lws_callback_reasons reason, void *user, void *in, size_t len) 
{
    return 0;
}

static int 
callback_websocket_wa_event(struct lws *wsi, enum lws_callback_reasons reason, void *user, void *in, size_t len)
{
    switch (reason) {
        case LWS_CALLBACK_ESTABLISHED:
            puts("connection established\n");
            break;
        case LWS_CALLBACK_RECEIVE: {
            char* substr = malloc(len);
            strncpy(substr,  (char *) in, len);
            printf("[%ld] %s\n", len, substr);
            // TODO handle_event; filter & save event into DB
            // lws_write(wsi, &buf[LWS_SEND_BUFFER_PRE_PADDING], len, LWS_WRITE_TEXT);
            free(substr);
            break;
        }
        default:
            break;
    }

    return 0;
}

// Globals
static struct lws_protocols protocols[] = {
    { "http-only", callback_http, 0 },
    { WA_EVENT_PROTOCOL_NAME, callback_websocket_wa_event, 0 },
    { NULL, NULL, 0 }
};

struct lws_context *context;

static void cleanup(int signo_ignored) {
    puts("[-] Cleanup");
    lws_context_destroy(context);
}

int main(void) {
    const char* port = getenv("WSPORT");
    if (port == NULL) {
        fputs("[!] getenv returned NULL\n", stderr);
        return EXIT_FAILURE;
    }

    struct lws_context_creation_info context_info = {
        .port = 9000, .iface = NULL, .protocols = protocols, .extensions = NULL,
        .ssl_cert_filepath = NULL, .ssl_private_key_filepath = NULL, .ssl_ca_filepath = NULL,
        .gid = -1, .uid = -1, .options = 0, NULL, .ka_time = 0, .ka_probes = 0, .ka_interval = 0
    };

    context = lws_create_context(&context_info);

    if (context == NULL) {
        fprintf(stderr, "[!] lws init failed\n");
        return EXIT_FAILURE;
    }

    puts("[-] Starting server\n");

    if (signal(SIGTERM, cleanup) == SIG_ERR) {
        fputs("[!] An error occurred while handling SIGTERM.\n", stderr);
        return EXIT_FAILURE;
    }

    while (1) {
        lws_service(context, 0);
    }

    return EXIT_SUCCESS;
}
