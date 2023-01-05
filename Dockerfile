
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["AspNetCoreTests.Web/AspNetCoreTests.Web.csproj", "AspNetCoreTests.Web/"]
RUN dotnet restore "AspNetCoreTests.Web/AspNetCoreTests.Web.csproj"
COPY . .
WORKDIR "/src/AspNetCoreTests.Web"
RUN dotnet build "AspNetCoreTests.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AspNetCoreTests.Web.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AspNetCoreTests.Web.dll"]