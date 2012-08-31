using System.Collections.Generic;
using System.Collections.ObjectModel;
using Sitecore.Pipelines.PreprocessRequest;

namespace SiteManager.Code.Processors
{

    public abstract class SitePreprocessRequestProcessor : PreprocessRequestProcessor
    {
        // Fields
        private readonly ICollection<string> _sitesFilter = new Collection<string>();

        public void ResolveSite(string siteName)
        {
            this._sitesFilter.Add(siteName);
        }

        public override void Process(PreprocessRequestArgs args)
        {

            if (!_sitesFilter.Contains(Sitecore.Context.Site.Name))
            {
                SiteProcess(args);
            }
        }

        public abstract void SiteProcess(PreprocessRequestArgs args);

    }
}