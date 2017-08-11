FROM       scratch
MAINTAINER Andreas Bucksteeg <andreas@bucksteeg.de>
ADD        envcontroller envcontroller
ENTRYPOINT ["/envcontroller"]