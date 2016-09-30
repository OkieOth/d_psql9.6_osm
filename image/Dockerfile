FROM postgres:9.6
RUN apt-get update && apt-get install -y --force-yes osm2pgsql

COPY scripts/import_osm.sh /import_osm.sh
COPY pgtune-0.9.3.tar.gz /opt

RUN cd /opt; tar -xzf pgtune-0.9.3.tar.gz; ln -s pgtune-0.9.3 pgtune

ENTRYPOINT ["/import_osm.sh"]
CMD ["postgres"]



