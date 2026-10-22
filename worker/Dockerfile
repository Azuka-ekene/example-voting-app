FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:10.0@sha256:747cbade5bfd918a175ac32f8f1d931edec2c7d0d5397a3de72eaef1ac1f66d2 AS build

ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

WORKDIR /source

COPY *.csproj .

RUN dotnet restore -a $TARGETARCH

COPY . .

RUN dotnet publish -c release -o /app -a $TARGETARCH --self-contained false --no-restore

FROM mcr.microsoft.com/dotnet/runtime:10.0@sha256:0cf09aaccf6a9f68900aed4c73fb28fe25bb59ec85de4dea08ba02240a8635f3

WORKDIR /app

COPY --from=build --chown=10001:10001 /app .

USER 10001:10001

ENTRYPOINT ["dotnet", "Worker.dll"]