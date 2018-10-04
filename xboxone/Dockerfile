ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Copy data for add-on
COPY run.sh /
COPY xboxone.py /
RUN chmod a+x /run.sh

# Install requirements for add-on
RUN apk add --no-cache jq gcc musl-dev python3-dev libffi-dev openssl-dev python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN pip3 install xbox-smartglass-rest==0.9.6

CMD [ "/run.sh" ]
