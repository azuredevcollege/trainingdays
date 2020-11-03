FROM alpine

RUN apk add --update --no-cache py-pip && \
    pip3 install --upgrade pip setuptools httpie && \
    rm -r /root/.cache

CMD ["sh"]