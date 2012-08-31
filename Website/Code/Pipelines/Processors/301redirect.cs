using SiteManager.Code.Processors;
using Sitecore.Diagnostics;

namespace SiteManager.Code.Pipelines.Processors
{
    public class _301redirect : SiteHttpProcessor
    {
        public override void SiteProcess(Sitecore.Pipelines.HttpRequest.HttpRequestArgs args)
        {
            Log.Info(Sitecore.Context.Site.Name + " used the 301 redirect Pipeline", this);
        }
    }
}