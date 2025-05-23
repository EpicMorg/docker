# nginx quic

Experimental QUIC support for nginx
-----------------------------------

1. Introduction
2. Installing
3. Configuration
4. Clients
5. Troubleshooting
6. Contributing
7. Links

1. Introduction

    This is an experimental QUIC [1] / HTTP/3 [2] support for nginx.

    The code is developed in a separate "quic" branch available
    at https://hg.nginx.org/nginx-quic.  Currently it is based
    on nginx mainline 1.21.x.  We merge new nginx releases into
    this branch regularly.

    The project code base is under the same BSD license as nginx.

    The code is currently at a beta level of quality and should not
    be used in production.

    We are working on improving HTTP/3 support with the goal of
    integrating it to the main NGINX codebase.  Expect frequent
    updates of this code and don't rely on it for whatever purpose.

    We'll be grateful for any feedback and code submissions however
    we don't bear any responsibilities for any issues with this code.

    You can always contact us via nginx-devel mailing list [3].

    What works now:

    Currently we support IETF-QUIC draft-29 through final RFC documents.
    Earlier drafts are NOT supported as they have incompatible wire format.

    nginx should be able to respond to HTTP/3 requests over QUIC and
    it should be possible to upload and download big files without errors.

    + The handshake completes successfully
    + One endpoint can update keys and its peer responds correctly
    + 0-RTT data is being received and acted on
    + Connection is established using TLS Resume Ticket
    + A handshake that includes a Retry packet completes successfully
    + Stream data is being exchanged and ACK'ed
    + An H3 transaction succeeded
    + One or both endpoints insert entries into dynamic table and
      subsequently reference them from header blocks
    + Version Negotiation packet is sent to client with unknown version
    + Lost packets are detected and retransmitted properly
    + Clients may migrate to new address

     Not (yet) supported features:

    - Explicit Congestion Notification (ECN) as specified in quic-recovery [5]
    - A connection with the spin bit succeeds and the bit is spinning
    - Structured Logging

    Since the code is experimental and still under development,
    a lot of things may not work as expected, for example:

    - Flow control mechanism is basic and intended to avoid CPU hog and make
      simple interactions possible

    - Not all protocol requirements are strictly followed; some of checks are
      omitted for the sake of simplicity of initial implementation

2. Installing

    You will need a BoringSSL [4] library that provides QUIC support

    $ hg clone -b quic https://hg.nginx.org/nginx-quic
    $ cd nginx-quic
    $ ./auto/configure --with-debug --with-http_v3_module       \
                       --with-cc-opt="-I../boringssl/include"   \
                       --with-ld-opt="-L../boringssl/build/ssl  \
                                      -L../boringssl/build/crypto"
    $ make

    When configuring nginx, you can enable QUIC and HTTP/3 using the
    following new configuration options:

        --with-http_v3_module     - enable QUIC and HTTP/3
        --with-http_quic_module   - enable QUIC for older HTTP versions
        --with-stream_quic_module - enable QUIC in Stream

3. Configuration

    The HTTP "listen" directive got two new options: "http3" and "quic".
    The "http3" option enables HTTP/3 over QUIC on the specified port.
    The "quic" option enables QUIC for older HTTP versions on this port.

    The Stream "listen" directive got a new option "quic" which enables
    QUIC as client transport protocol instead of TCP or plain UDP.

    Along with "http3" or "quic", you also have to specify "reuseport"
    option [6] to make it work properly with multiple workers.

    A number of directives were added that specify transport parameter values:

        quic_max_idle_timeout
        quic_max_ack_delay
        quic_max_udp_payload_size
        quic_initial_max_data
        quic_initial_max_stream_data_bidi_local
        quic_initial_max_stream_data_bidi_remote
        quic_initial_max_stream_data_uni
        quic_initial_max_streams_bidi
        quic_initial_max_streams_uni
        quic_ack_delay_exponent
        quic_disable_active_migration
        quic_active_connection_id_limit

    To enable address validation:

        quic_retry on;

    To enable 0-RTT:

        ssl_early_data on;

    Make sure that TLS 1.3 is configured which is required for QUIC:

        ssl_protocols TLSv1.3;

    To enable GSO (Generic Segmentation Offloading):

        quic_gso on;

    By default this Linux-specific optimization [8] is disabled.
    Enable if your network interface is configured to support GSO.

    A number of directives were added that configure HTTP/3:

        http3_max_table_capacity
        http3_max_blocked_streams
        http3_max_concurrent_pushes
        http3_push
        http3_push_preload

    An additional variable is available: $quic.
    The value of $quic is "quic" if QUIC connection is used,
    or an empty string otherwise.

Example configuration:

    http {
        log_format quic '$remote_addr - $remote_user [$time_local] '
                        '"$request" $status $body_bytes_sent '
                        '"$http_referer" "$http_user_agent" "$quic"';

        access_log logs/access.log quic;

        server {
            # for better compatibility it's recommended
            # to use the same port for quic and https
            listen 8443 http3 reuseport;
            listen 8443 ssl;

            ssl_certificate     certs/example.com.crt;
            ssl_certificate_key certs/example.com.key;
            ssl_protocols       TLSv1.3;

            location / {
                # required for browsers to direct them into quic port
                add_header Alt-Svc 'h3=":8443"; ma=86400';
            }
        }
    }

4. Clients

    * Browsers

        Known to work: Firefox 80+ and Chrome 85+ (QUIC draft 29+)

        Beware of strange issues: sometimes browser may decide to ignore QUIC
        Cache clearing/restart might help.  Always check access.log and
        error.log to make sure you are using HTTP/3 and not TCP https.

        + to enable QUIC in Firefox, set the following in 'about:config':
          network.http.http3.enabled = true

        + to enable QUIC in Chrome, enable it on command line and force it
          on your site:

        $ ./chrome --enable-quic --quic-version=h3-29 \
                       --origin-to-force-quic-on=example.com:8443

    * Console clients

        Known to work: ngtcp2, firefox's neqo and chromium's console clients:

        $ examples/client 127.0.0.1 8443 https://example.com:8443/index.html

        $ ./neqo-client https://127.0.0.1:8443/

        $ chromium-build/out/my_build/quic_client http://example.com:8443 \
                  --quic_version=h3-29 \
                  --allow_unknown_root_cert \
                  --disable_certificate_verification


   If you've got it right, in the access log you should see something like:

   127.0.0.1 - - [24/Apr/2020:11:27:29 +0300] "GET / HTTP/3" 200 805 "-"
                                         "nghttp3/ngtcp2 client" "quic"


5. Troubleshooting

    Here are some tips that may help you to identify problems:

    + Ensure you are building with proper SSL library that supports QUIC

    + Ensure you are using the proper SSL library in runtime
      (`nginx -V` will show you what you are using)

    + Ensure your client is actually sending QUIC requests
      (see "Clients" section about browsers and cache)

      We recommend to start with simple console client like ngtcp2
      to ensure you've got server configured properly before trying
      with real browsers that may be very picky with certificates,
      for example.

    + Build nginx with debug support [7] and check your debug log.
      It should contain all details about connection and why it
      failed. All related messages contain "quic " prefix and can
      be easily filtered out.

    + If you want to investigate deeper, you may want to enable
      additional debugging in src/event/quic/ngx_event_quic_connection.h:

        #define NGX_QUIC_DEBUG_PACKETS
        #define NGX_QUIC_DEBUG_FRAMES
        #define NGX_QUIC_DEBUG_ALLOC
        #define NGX_QUIC_DEBUG_CRYPTO

6. Contributing

    If you are willing to contribute, please refer to
    http://nginx.org/en/docs/contributing_changes.html

7. Links

    [1] https://datatracker.ietf.org/doc/html/rfc9000
    [2] https://datatracker.ietf.org/doc/html/draft-ietf-quic-http
    [3] https://mailman.nginx.org/mailman/listinfo/nginx-devel
    [4] https://boringssl.googlesource.com/boringssl/
    [5] https://datatracker.ietf.org/doc/html/rfc9002
    [6] https://nginx.org/en/docs/http/ngx_http_core_module.html#listen
    [7] https://nginx.org/en/docs/debugging_log.html
    [8] http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf


# Compose example

```yml
services:
  balancer:
    image: epicmorg/balancer
    restart: unless-stopped
    ports:
      - "0.0.0.0:80:80"
      - "0.0.0.0:443:443"
    volumes:
      - /etc/localtime:/etc/localtime
      - /etc/timezone:/etc/timezone
      - /etc/letsencrypt:/etc/letsencrypt
      - nginx:/etc/nginx
      - nginx-usr:/usr/share/nginx/html
      - /var/lib/nginx
#    extra_hosts:
#      - "example.com:192.168.0.11"
    depends_on:
      - websites
    tmpfs:
      - /tmp
volumes:
  nginx:
    external: true
  nginx-usr:
    external: true
```
