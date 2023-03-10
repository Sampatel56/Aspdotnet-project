FROM mcr.microsoft.com/dotnet/sdk:6.0 AS sdk
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

FROM sdk AS build
COPY . /src
WORKDIR "/src/AspNetCoreTests/AspNetCoreTests.Web/"

RUN dotnet restore
RUN dotnet build

FROM build AS publish
WORKDIR "/src/AspNetCoreTests/AspNetCoreTests.Web/"
RUN dotnet publish -c Release -o /app

FROM runtime AS final
WORKDIR "/app"
COPY --from=publish /app .

EXPOSE 80

ENTRYPOINT ["dotnet", "AspNetCoreTests.Web.dll", "--urls", "http://*:80"]