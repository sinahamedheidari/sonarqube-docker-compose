#!/usr/bin/env bash

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

# Parse Docker env vars to customize SonarQube
#
# e.g. Setting the env var sonar.jdbc.username=foo
#
# will cause SonarQube to be invoked with -Dsonar.jdbc.username=foo

declare -a sq_opts

if [ -n "$SONARQUBE_JDBC_USERNAME" ]
then
    sq_opts+=("-Dsonar.jdbc.username=$SONARQUBE_JDBC_USERNAME")
fi
if [ -n "$SONARQUBE_JDBC_PASSWORD" ]
then
    sq_opts+=("-Dsonar.jdbc.password=$SONARQUBE_JDBC_PASSWORD")
fi
if [ -n "$SONARQUBE_JDBC_URL" ]
then
    sq_opts+=("-Dsonar.jdbc.url=$SONARQUBE_JDBC_URL")
fi

while IFS='=' read -r envvar_key envvar_value
do
    if [[ "$envvar_key" =~ sonar.* ]] || [[ "$envvar_key" =~ ldap.* ]]; then
        sq_opts+=("-D${envvar_key}=${envvar_value}")
    fi
done < <(env)

exec tail -F ./logs/es.log & # this tail on the elasticsearch logs is a temporary workaround, see https://github.com/docker-library/official-images/pull/6361#issuecomment-516184762
# Allow the container to be started with `--user`
    if [[ "$(id -u)" = '0' ]]; then
        chown -R sonarqube:sonarqube "${SQ_DATA_DIR}" "${SQ_EXTENSIONS_DIR}" "${SQ_LOGS_DIR}" "${SQ_TEMP_DIR}"
        exec su-exec sonarqube java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "${sq_opts[@]}" \
  "$@"
fi
