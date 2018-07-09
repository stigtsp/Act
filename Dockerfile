FROM stigtsp/mod_perl1:centos

RUN yum -y install perl-DBD-Pg perl-Module-Install perl-XML-LibXML perl-XML-SAX gmp-devel perl-XML-Simple

# These modules appear to be needed
#RUN cpanm Module::Install DateTime::Format::Strptime DateTime DateTime::Format::Pg


WORKDIR /tmp

COPY Makefile.PL /act_deps/Makefile.PL
COPY lib /act_deps/lib

WORKDIR /act_deps
RUN cpanm --verbose --installdeps .

COPY . /act
RUN perl Makefile.PL
RUN make && make install

