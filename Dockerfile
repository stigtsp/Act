FROM stigtsp/mod_perl1:centos

RUN yum -y install perl-DBD-Pg perl-Module-Install perl-XML-LibXML perl-XML-SAX gmp-devel perl-XML-Simple

# Copy lib and Makefile.PL to separate directory to avoid rebuild of deps when . changes.
WORKDIR /act_deps
COPY Makefile.PL /act_deps/Makefile.PL
COPY lib /act_deps/lib
RUN cpanm --verbose --installdeps .
RUN rm -r /act_deps

COPY . /act
WORKDIR /act
RUN perl Makefile.PL && make && make install


EXPOSE 8080
CMD /usr/local/apache/bin/httpd -X -F -C "User nobody" -C "Group nobody" -C "Listen 8080" -C "ErrorLog /dev/stderr" -C  "TransferLog /dev/stdout" -f /act/eg/conf/httpd.conf
# Make test requires a DB connection
