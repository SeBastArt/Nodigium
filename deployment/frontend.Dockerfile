#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine-arm64v8 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine-arm64v8 AS build

WORKDIR /src
COPY ["Service.Frontend/Service.Frontend.csproj", "Service.Frontend/"]
RUN dotnet restore "Service.Frontend/Service.Frontend.csproj"
COPY . .
WORKDIR "/src/Service.Frontend"
RUN dotnet build "Service.Frontend.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Service.Frontend.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Service.Frontend.dll"]