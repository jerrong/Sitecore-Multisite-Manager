using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Threading;
using System.Web;
using Sitecore;
using Sitecore.Data.Engines;
using Sitecore.Data.Items;
using Sitecore.Data.Proxies;
using Sitecore.Diagnostics;
using Sitecore.Globalization;
using Sitecore.Install.Files;
using Sitecore.Install.Framework;
using Sitecore.Install.Items;
using Sitecore.Install.Utils;
using Sitecore.SecurityModel;
using Sitecore.Shell.Framework.Commands;
using Sitecore.Text;
using Sitecore.Web.UI.Sheer;
using Sitecore.Web.UI.XamlSharp;

namespace SiteManager.Code.Commands
{
    public class ImportProject : Command
    {
        public override void Execute(CommandContext context)
        {


            //using (new SecurityDisabler())
            //{
            //    using (new ProxyDisabler())
            //    {
            //        using (new SyncOperationContext())
            //        {
            //            IProcessingContext processingContext = new SimpleProcessingContext();
            //            IItemInstallerEvents events = new DefaultItemInstallerEvents(new BehaviourOptions(InstallMode.Overwrite, MergeMode.Undefined));
            //            processingContext.AddAspect(events);
            //            IFileInstallerEvents events1 = new DefaultFileInstallerEvents(true);
            //            processingContext.AddAspect(events1);

            //            Sitecore.Install.Installer installer = new Sitecore.Install.Installer();
            //            installer.InstallPackage(MainUtil.MapPath("INSERT PACKAGE PATH INCLUDING THE FILE NAME"), processingContext);
            //        }
            //    }
            //}

            Assert.ArgumentNotNull(context, "context");
            if (context.Items.Length == 1)
            {
                Item item = context.Items[0];
                NameValueCollection parameters = new NameValueCollection();
                parameters["id"] = item.ID.ToString();
                parameters["language"] = item.Language.ToString();
                parameters["version"] = item.Version.ToString();
                parameters["load"] = StringUtil.GetString(new string[] { context.Parameters["load"] });
                parameters["edit"] = StringUtil.GetString(new string[] { context.Parameters["edit"] });
                parameters["tofolder"] = StringUtil.GetString(new string[] { context.Parameters["tofolder"] });
                Context.ClientPage.Start(this, "Run", parameters);
            }


        }

        public override CommandState QueryState(CommandContext context)
        {
            //Assert.ArgumentNotNull(context, "context");
            //if (UIUtil.UseFlashUpload())
            //{
            //    return CommandState.Hidden;
            //}
            //if (context.Items.Length != 1)
            //{
            //    return CommandState.Hidden;
            //}
            //Item item = context.Items[0];
            //if ((item.Access.CanCreate() && item.Access.CanRead()) && item.Access.CanWrite())
            //{
            //    return base.QueryState(context);
            //}
            //return CommandState.Disabled;

            return CommandState.Enabled;

        }

        protected void Run(ClientPipelineArgs args)
        {
            Assert.ArgumentNotNull(args, "args");
            string str = args.Parameters["id"];
            string name = args.Parameters["language"];
            string str3 = args.Parameters["version"];
            string str4 = args.Parameters["tofolder"];
            Item item = Client.ContentDatabase.Items[str, Language.Parse(name), Sitecore.Data.Version.Parse(str3)];
            if (item == null)
            {
                SheerResponse.Alert("Item not found.", new string[0]);
            }
            else
            {
                if (str4 == "1")
                {
                    Item parent = item;
                    while (((parent != null) && (parent.TemplateID != TemplateIDs.Folder)) && (((parent.TemplateID != TemplateIDs.Node) && (parent.TemplateID != TemplateIDs.MediaFolder)) && (parent.ID != ItemIDs.MediaLibraryRoot)))
                    {
                        parent = parent.Parent;
                    }
                    if (parent != null)
                    {
                        item = parent;
                    }
                }
                if (args.IsPostBack)
                {
                    if (args.HasResult)
                    {
                        if (args.Parameters["load"] == "1")
                        {
                            Context.ClientPage.SendMessage(this, "item:load(id=" + args.Result + ")");
                        }
                        else
                        {
                            Context.ClientPage.SendMessage(this, "media:refresh");
                        }
                    }


                    Sitecore.Shell.Applications.Dialogs.ProgressBoxes.ProgressBox.Execute(
"Importing Site",
"Step 1 : Setting Rollback Snapshot\n Step2: Importing Items\n Step 3: Updating Databases\n Step 4: Merging Files",
new Sitecore.Shell.Applications.Dialogs.ProgressBoxes
.ProgressBoxMethod(StartProcess),
new object[] { item.ID.ToString() });
                }
                else
                {
                    if (UIUtil.UseFlashUpload())
                    {
                        UrlString str5 = new UrlString(ControlManager.GetControlUrl(new ControlName("Sitecore.Shell.Applications.FlashUpload.Simple")));
                        str5.Add("uri", item.Uri.ToString());
                        str5.Add("edit", args.Parameters["edit"]);
                        SheerResponse.ShowModalDialog(str5.ToString(), "450", "140", string.Empty, true);
                    }
                    else
                    {
                        UrlString urlString = new UrlString("/sitecore/shell/Applications/Media/Upload Media/UploadMedia.aspx");
                        item.Uri.AddToUrlString(urlString);
                        urlString.Append("edit", args.Parameters["edit"]);
                        SheerResponse.ShowModalDialog(urlString.ToString(), "450", "140", string.Empty, true);
                    }
                    args.WaitForPostBack();
                }
            }
        }


        public void StartProcess(params object[] parameters)
        {
            //Get the upload and inspect the nuget package
            //Install Update Package
            //Set Snapshot point
            //Merge Files

            var packageDeatilsItem = parameters[0];



            //var proc = new LongProcess();
            //proc.Execute((int)parameters[0]);
        }
    }
    public class LongProcess
    {
        public void Execute(int iterations)
        {
            for (var i = 0; i < iterations; i++)
            {
                Thread.Sleep(200);
                if (Sitecore.Context.Job != null)
                {
                    Sitecore.Context.Job.Status.Processed = i;
                    Sitecore.Context.Job.Status.Messages.Add("Exported item " + i);
                }
            }
        }
    }
}

