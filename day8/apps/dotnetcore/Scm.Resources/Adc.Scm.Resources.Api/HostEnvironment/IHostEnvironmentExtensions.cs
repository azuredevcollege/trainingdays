namespace Microsoft.Extensions.Hosting
{
    public static class IHostEnvironmentExtensions
    {
        public static bool IsKubernetesDevelopment(this IHostEnvironment env)
        {
            return env.EnvironmentName == "KubernetesDevelopment";
        }
    }
}