# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy all .csproj files for each project in the solution
COPY ["Withdraw.Cash.Api/Withdraw.Cash.Api.csproj", "Withdraw.Cash.Api/"]
COPY ["Withdraw.Cash.Contracts/Withdraw.Cash.Contracts.csproj", "Withdraw.Cash.Contracts/"]
COPY ["Withdraw.Cash.Domain/Withdraw.Cash.Domain.csproj", "Withdraw.Cash.Domain/"]
COPY ["Withdraw.Cash.Application/Withdraw.Cash.Application.csproj", "Withdraw.Cash.Application/"]

RUN dotnet nuget locals all --clear

# Restore dependencies (this makes sure all referenced projects are restored)
RUN dotnet restore "Withdraw.Cash.Api/Withdraw.Cash.Api.csproj"

# Copy the rest of the project files
COPY . .

# Build the app
RUN dotnet publish "Withdraw.Cash.Api/Withdraw.Cash.Api.csproj" -c Release -o /out

# Use the .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /out ./

# Expose the port (you can change the port if needed)
EXPOSE 8080

# Start the API
ENTRYPOINT ["dotnet", "Withdraw.Cash.Api.dll"]
