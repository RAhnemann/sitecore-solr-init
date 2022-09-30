docker build -t rahnemann/solr-init:1.0-1809 --build-arg BASE_IMAGE=mcr.microsoft.com/windows/servercore:1809 .
docker build -t rahnemann/solr-init:1.0-1909 --build-arg BASE_IMAGE=mcr.microsoft.com/windows/servercore:1909  .
docker build -t rahnemann/solr-init:1.0-2004 --build-arg BASE_IMAGE=mcr.microsoft.com/windows/servercore:2004  .
docker build -t rahnemann/solr-init:1.0-20H2 --build-arg BASE_IMAGE=mcr.microsoft.com/windows/servercore:20H2  .
docker build -t rahnemann/solr-init:1.0-ltsc2019 --build-arg BASE_IMAGE=mcr.microsoft.com/windows/servercore:ltsc2019 .
docker build -t rahnemann/solr-init:1.0-ltsc2022 --build-arg BASE_IMAGE=mcr.microsoft.com/windows/servercore:ltsc2022 .