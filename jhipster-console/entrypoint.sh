#!/bin/bash

cp /tmp/jhipster-console.svg /Users/Tensor/kibana-4.6.1-darwin-x86_64/optimize/bundles/src/ui/public/images/kibana.svg
ELASTICSEARCH_URL=localhost:9200
# Wait for the Elasticsearch container to be ready before starting Kibana.
echo "Waiting for Elasticsearch to startup"
while true; do
    curl ${ELASTICSEARCH_URL} 2>/dev/null && break
    sleep 1
done

echo "Creating Mapping for Timelion"
curl -XPUT http://localhost:9200/.kibana/_mapping/timelion-sheet -d '{"timelion-sheet":{"properties":{"title":{"type":"string"},"hits":{"type":"long"},"description":{"type":"string"},"timelion_sheet":{"type":"string"},"timelion_interval":{"type":"string"},"timelion_other_interval":{"type":"string"},"timelion_chart_height":{"type":"integer"},"timelion_columns":{"type":"integer"},"timelion_rows":{"type":"integer"},"version":{"type":"long"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}}}}}'

echo "Loading dashboards"
cd /tmp
./load.sh

[ ! -f /tmp/.initialized ] && echo "Configuring default settings" && curl -XPUT http://${ELASTICSEARCH_URL}/.kibana/config/4.4.1 -d '{"dashboard:defaultDarkTheme": true, "defaultIndex": "logstash-*"}' && touch /tmp/.initialized

echo "Starting Kibana connecting to ${ELASTICSEARCH_URL}"
exec kibana -e http://${ELASTICSEARCH_URL}
