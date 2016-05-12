FROM kibana:5.0.0

RUN apt-get update
RUN apt-get -y install curl

COPY kibana.yml /opt/kibana/config/kibana.yml
COPY jhipster-console.svg /tmp/jhipster-console.svg
COPY dashboards /tmp/dashboards/
COPY load.sh /tmp/load.sh
RUN chmod +x /tmp/load.sh
RUN sed -i -e 's/\r$//' /tmp/load.sh

ENV SET_CONTAINER_TIMEZONE false
ENV ELASTALERT_VERSION 0.0.80
ENV CONTAINER_TIMEZONE America/Los_Angeles
ENV ELASTALERT_URL https://github.com/Yelp/elastalert/archive/v${ELASTALERT_VERSION}.tar.gz

ENV ELASTALERT_HOME /opt/elastalert
ENV RULES_DIRECTORY /opt/elastalert/rules

ENV ELASTICSEARCH_HOST http://elk-elasticsearch
ENV ELASTICSEARCH_PORT 9200
ENV ELASTICSEARCH_USERNAME ""
ENV ELASTICSEARCH_PASSWORD ""

RUN apt-get update && \
    apt-get install tar curl python-dev build-essential tzdata -y

RUN curl -Lo get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN mkdir -p /opt/elastalert

RUN curl -Lo elastalert.tar.gz ${ELASTALERT_URL} && \
    tar xvf *.tar.gz -C ${ELASTALERT_HOME} --strip-components 1 && \
    rm *.tar.gz

WORKDIR /opt/elastalert

RUN mkdir rules

RUN python setup.py install && \
    pip install -e .

COPY ./start-elastalert.sh /opt/start-elastalert.sh
RUN chmod +x /opt/start-elastalert.sh
RUN sed -i -e 's/\r$//' /opt/start-elastalert.sh

RUN curl -Lo elastalert.tar.gz ${ELASTALERT_URL} && \
    tar xvf *.tar.gz -C ${ELASTALERT_HOME} --strip-components 1 && \
    rm *.tar.gz

COPY ./entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh
RUN sed -i -e 's/\r$//' /tmp/entrypoint.sh

#RUN kibana-plugin install timelion

CMD ["/tmp/entrypoint.sh"]
