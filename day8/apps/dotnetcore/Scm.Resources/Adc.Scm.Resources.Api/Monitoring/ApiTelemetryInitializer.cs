using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;

namespace Adc.Scm.Resources.Api.Monitoring
{
    public class ApiTelemetryInitializer : ITelemetryInitializer
    {
        public void Initialize(ITelemetry telemetry)
        {
            telemetry.Context.Cloud.RoleName = "SCM Resources Api";
            telemetry.Context.Cloud.RoleInstance = "SCM Resources Api";

            // Set application version
            telemetry.Context.Component.Version = "1.0";
        }
    }
}
