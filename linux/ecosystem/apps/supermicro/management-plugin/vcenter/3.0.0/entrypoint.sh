#!/bin/bash
set -euo pipefail

: ${SMP_USERNAME:='admin'}
: ${SMP_PASSWORD:='$2a$12$Omxs7WJA5fqNkgEkmTTfYemT4cdlLMSZ8kN41DamFgVEjVTDsJcMi'}  #password
: ${SMP_AES_KEY:='key'}

java -jar ${SMP_DIR}/app/app.jar --app.security.key="${SMP_AES_KEY}" --app.security.username="${SMP_USERNAME}" --app.security.password="${SMP_PASSWORD}"
