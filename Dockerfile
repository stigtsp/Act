FROM stigtsp/mod_perl1:centos

RUN yum -y install perl-DBD-Pg perl-Module-Install perl-XML-LibXML perl-XML-SAX gmp-devel perl-XML-Simple

# Copy lib and Makefile.PL to separate directory to avoid rebuild of deps when . changes.
WORKDIR /act_deps
COPY Makefile.PL /act_deps/Makefile.PL
COPY lib/Act.pm /act_deps/lib/Act.pm
RUN cpanm --verbose --installdeps .
RUN rm -r /act_deps

ENV ACTHOME /act/docker/pts2018
ENV PERL5LIB /act/lib/

COPY . /act
WORKDIR /act
#RUN perl Makefile.PL && make && make install

COPY docker/apache.conf /usr/local/apache/conf/httpd.conf
EXPOSE 8080

CMD /usr/local/apache/bin/httpd -X -F

# Make test requires a DB connection
