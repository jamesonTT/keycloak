FROM quay.io/keycloak/keycloak:25.0.2 AS builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENV KC_DB=postgres \
KC_DB_URL_HOST=postgres \
KC_DB_URL_DATABASE=keycloak \
KC_DB_SCHEMA=public
ENV KC_DB_USERNAME=keycloak_user
ENV KC_DB_PASSWORD=password
ENV KC_LOG_LEVEL=INFO \
KEYCLOAK_ADMIN=admin \
KEYCLOAK_ADMIN_PASSWORD=password \
KC_HOSTNAME=localplaydates.auth
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]