# Use a multi-stage build to optimize the resulting Docker image to be a little
# lighter for deployment
#
# Stage 1: Build the ASP.NET Sample Application
ARG TAG=4.8-windowsservercore-ltsc2019
FROM mcr.microsoft.com/dotnet/framework/sdk:${TAG} AS build

# copy csproj and restore as distinct layers
WORKDIR /app
COPY simple_web_app/*.sln ./simple_web_app/
COPY simple_web_app/*.csproj ./simple_web_app/
COPY simple_web_app/*.config ./simple_web_app/
WORKDIR /app/simple_web_app
RUN nuget restore

# copy everything else and build app
WORKDIR /app
COPY simple_web_app/. ./simple_web_app/
WORKDIR /app/simple_web_app
RUN msbuild /p:Configuration=Release

# Stage 2: Run the ASP.NET Sample Application
FROM mcr.microsoft.com/dotnet/framework/aspnet:${TAG} AS runtime

SHELL ["powershell"]

WORKDIR /
RUN $ProgressPreference = 'SilentlyContinue'; \
    Invoke-WebRequest https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile \Windows\nuget.exe; \
    $ProgressPreference = 'Continue'; \
    \Windows\nuget.exe install WebConfigTransformRunner -Version 1.0.0.1

RUN md c:\aspnet-startup
COPY . c:/aspnet-startup
ENTRYPOINT ["powershell.exe", "c:\\aspnet-startup\\Startup.ps1"]

# Copy application
COPY --from=build /app/simple_web_app/. /inetpub/wwwroot
