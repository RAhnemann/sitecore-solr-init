ARG BASE_IMAGE  

FROM ${BASE_IMAGE} AS base

WORKDIR /data
COPY data .

ENTRYPOINT ["powershell.exe", ".\\Start.ps1"]
