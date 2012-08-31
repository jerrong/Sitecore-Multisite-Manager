using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Sitecore;
using Sitecore.Data;
using Sitecore.Data.Clones;
using Sitecore.Data.Items;
using Sitecore.Diagnostics;
using Sitecore.Events;
using Sitecore.Links;

namespace SiteManager.Code.Events
{
    public class Added
    {
        public void Execute(object sender, EventArgs args)
        {
            var item = Event.ExtractParameter(args, 0) as Item;
            Error.AssertItem(item, "Item");
            

            var notifications = item.Database.NotificationProvider.GetNotifications(typeof(ChildCreatedNotification));
            foreach (var notification in notifications)
            {
                notification.Processed = true;
            }


        }
    }
}