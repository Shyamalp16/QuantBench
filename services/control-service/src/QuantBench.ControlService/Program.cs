using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using QuantBench.ControlService;

HostApplicationBuilder builder = Host.CreateApplicationBuilder(args);
builder.Services.AddWindowsService(options => options.ServiceName = ServiceMetadata.DisplayName);

using IHost host = builder.Build();
await host.RunAsync();

