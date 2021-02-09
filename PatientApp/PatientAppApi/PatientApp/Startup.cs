using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using PatientApp.Services;
using Newtonsoft.Json;

namespace PatientApp
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            ConfigureDatabaseConnection(services);
            ConfigureAppServices(services);
            // Configure MVC
            ConfigureMVC(services);
            // Configure CORs
            ConfigureCORs(services);
            services.AddControllers();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();
            app.UseCors();
            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }

        private void ConfigureDatabaseConnection(IServiceCollection services)
        {
            services.AddDbContext<DatabaseContext>(options =>
                options.UseNpgsql(Configuration.GetConnectionString("Local")));
        }

        private void ConfigureAppServices(IServiceCollection services)
        {
            services.AddScoped<PatientService>();
            services.AddScoped<PhoneService>();
        }

        private void ConfigureMVC(IServiceCollection services)
        {
            services.AddMvc()
            .AddNewtonsoftJson(options =>
            {
                // Here we remove the reference loop handling so when we serialize "many-to-many" entities, we will not get a run-time error
                options.SerializerSettings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore;

                // Special UTC datetime handling
                options.SerializerSettings.DateTimeZoneHandling = DateTimeZoneHandling.RoundtripKind;
            })
            .SetCompatibilityVersion(CompatibilityVersion.Version_3_0);
        }
        private void ConfigureCORs(IServiceCollection services)
        {
            // This list of origins will need to contain the URL of the finished front end project (ex. www.furious7.com)
            string[] origins = {
                "http://localhost:56168",
                "http://172.18.0.1:4201",
                "http://172.18.0.2:4201",
                "http://172.18.0.3:4201",
                "http://50.72.17.235:4201",
                "https://localhost:4201",
                "https://172.18.0.1:4201",
                "https://172.18.0.2:4201",
                "https://172.18.0.3:4201",
                "https://50.72.17.235:4201"
            };


            services.AddCors(options =>
            {
                options.AddDefaultPolicy(builder =>
                {
                    builder.AllowCredentials();
                    builder.AllowAnyHeader();
                    builder.AllowAnyMethod();
                    builder.WithOrigins(origins);

                });
            });
        }

    }
}
