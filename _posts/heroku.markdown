---
---
ASP.NET Core on Heroku with Postgres
1.
New website template
a.
Web application, enable docker support (linux)
2.
Modify docker file
a.
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch AS build
WORKDIR /src
COPY ["HerokuTest1.csproj", "HerokuTest1/"]
RUN dotnet restore "HerokuTest1/HerokuTest1.csproj"
COPY . "./HerokuTest1"
WORKDIR "/src/HerokuTest1"
RUN dotnet build "HerokuTest1.csproj" -c Release -o /app
FROM build AS publish
RUN dotnet publish "HerokuTest1.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .
CMD dotnet HerokuTest1.dll
3.
Modify program.cs
a.
Add the following:
b.
public static class WebHostBuilderExtensions
{
    public static IWebHostBuilder UsePort(this IWebHostBuilder builder)
    {
        var port = Environment.GetEnvironmentVariable("PORT");
        if (string.IsNullOrEmpty(port))
            return builder;
        return builder.UseUrls($"http://+:{port}");
    }
}
c.
Add ".UsePort()" after .UseStartup<Startup>()
4.
Add heroku.yml in repository root (note the space after the colon)
a.
build:
    docker:
        web: HerokuTest1/Dockerfile
5.
Push to github
6.
Create app in heroku
7.
Change heroku stack to container
Docker run -it --name docker-cli ubuntu
apt-get update && apt-get -y install sudo curl
curl 
https://cli-assets.heroku.com/install.sh | sh
Heroku login --interactive
Heroku apps
Heroku stack:set container --app yourappname
0.
Link github to heroku
a.
Deploy -> Deployment Method - select GitHub and locate your project.
b.
Enable automatic deploys from master
1.
Push to github again, check activity and view build logs
2.
Create postgres add-on
a.
Resources -> Add-ons, type "postgres" and click on "Heroku Postgres"
b.
Click on the newly created database, then go to its Settings and view credentials
3.
Copy the databsae_url to your local secrets file
a.
Right click on project, click 'manage user secrets'
b.
Your secrets file should look like this:
{  
  "DATABASE_URL": "paste in the value from heroku"
}
12.
Install EntityFrameworkCore
a.
Add package "Npgsql.EntityFrameworkCore.PostgreSQL"
b.
Note: If your website is using .Net Core 2.1 then use the 2.1 version of the packages. 
c.
Add a class for your data type (e.g. TestItem with int Id and string Value properties)
d.
Add a new "Data" folder under Pages; right click and add new razor page, using CRUD
e.
Select the TestItem model class, click the plus to create a new DataContext
13.
Add the following class to your code:
a.
public class PostgresUrlParser
{
    public PostgresUrlParser(string database_url)
    {
        if (!database_url.StartsWith("postgres://"))
            throw new ArgumentOutOfRangeException(nameof(database_url), "database_url should start with postgres://");
        var words = database_url.Split(':', '@', '/');
        var user = words[3];
        var password = words[4];
        var host = words[5];
        var port = words[6];
        var database = words[7];
        HerokuDatabaseUrl = database_url;
        DotNetConnectionString = $"Server={host}; Port={port}; Database={database}; User ID={user}; Password={password}; SSL Mode=Require; Trust S
erver Certificate=True;";
        PsqlConnectionCommand = $"docker run -e PGPASSWORD={password} --rm -it postgres psql -h {host} -U {user} {database} --
set=sslmode=require";
    }
    public string HerokuDatabaseUrl { get; }
    public string DotNetConnectionString { get; }
    public string PsqlConnectionCommand { get; }
    public static string ParseConnectionString(string database_url)
    {
        var parser = new PostgresUrlParser(database_url);
        return parser.DotNetConnectionString;
    }
}
17.
Modify Startup.cs
services.AddDbContext<DataContext>(options =>
       options.UseNpgsql(PostgresUrlParser.ParseConnectionString(Configuration["DATABASE_URL"])));
18.
Update the database
dotnet ef migrations add InititalMigration
dotnet ef database update
0.
Git commit and push.  You should see the heroku app automatically rebuild, and once it's done you should be able to g