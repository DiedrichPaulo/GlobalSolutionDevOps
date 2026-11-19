
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY ["citizentech-dotnet/CitizenTech.Api.csproj", "./"]

RUN dotnet restore "CitizenTech.Api.csproj"

COPY citizentech-dotnet/ .

RUN dotnet publish "CitizenTech.Api.csproj" \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_HTTP_PORTS=8080

EXPOSE 8080

USER $APP_UID

ENTRYPOINT ["dotnet", "CitizenTech.Api.dll"]
