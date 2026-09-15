namespace QuantBench.ControlService.Tests;

using QuantBench.ControlService;
using Xunit;

public sealed class ServiceMetadataTests
{
    [Fact]
    public void PhaseOneServiceHasNoTradingAuthority()
    {
        Assert.False(ServiceMetadata.HasOperationalTradingAuthority);
        Assert.Equal("QuantBench Control Service", ServiceMetadata.DisplayName);
    }
}

