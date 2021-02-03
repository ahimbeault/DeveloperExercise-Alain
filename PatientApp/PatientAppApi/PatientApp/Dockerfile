#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["PatientApp.csproj", "PatientApp_build/"]
COPY ["patientapp.pfx", "PatientApp_build"]
RUN dotnet restore "PatientApp_build/PatientApp.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "PatientApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PatientApp.csproj" -c Release -o /app/publish


FROM base AS final

EXPOSE 2001

ARG BACKENDENVIRONMENT="Development"
ARG CERTIFICATE="patientapp.pfx"

ENV ASPNETCORE_URLS=https://+:444
ENV ASPNETCORE_HTTPS_PORT=2001
ENV ASPNETCORE_ENVIRONMENT=$BACKENDENVIRONMENT
ENV ASPNETCORE_Kestrel__Certificates__Default__Password=sekrit
ENV ASPNETCORE_Kestrel__Certificates__Default__Path=$CERTIFICATE


WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PatientApp.dll"]