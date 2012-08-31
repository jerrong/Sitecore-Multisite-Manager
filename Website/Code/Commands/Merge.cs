using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Sitecore.Data.Items;

namespace SiteManager.Code.Commands
{
    public class Merge : Sitecore.Shell.Framework.Commands.Command
    {
        public override void Execute(Sitecore.Shell.Framework.Commands.CommandContext context)
        {
            var currentItem = context.Items[0];

            var contentStub = currentItem.Axes.GetDescendant("content").Children[0];
            contentStub.CloneTo(Sitecore.Context.ContentDatabase.GetItem(Sitecore.ItemIDs.ContentRoot));
            var layoutStubs = currentItem.Children["layout"].Children;
            foreach (Item child in layoutStubs)
            {
                child.Children.First().CloneTo(Sitecore.Context.ContentDatabase.GetItem(Sitecore.ItemIDs.LayoutRoot).Children[child.Name]);
            }

            var mediaStubs = currentItem.Axes.GetDescendant("media library").Children;
            foreach (Item child in mediaStubs)
            {
                child.CloneTo(Sitecore.Context.ContentDatabase.GetItem(Sitecore.ItemIDs.MediaLibraryRoot));
            }

            var templateStubs = currentItem.Axes.GetDescendant("templates").Children;
            foreach (Item child in mediaStubs)
            {
                child.CloneTo(Sitecore.Context.ContentDatabase.GetItem(Sitecore.ItemIDs.TemplateRoot));
            }
        }
    }
}