using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using Sitecore.Configuration;
using Sitecore.Data.Items;
using Sitecore.Pipelines;
using Sitecore.Shell.Applications.Dialogs.ProgressBoxes;
using Sitecore.Shell.Framework.Commands;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

namespace SiteManager.Code.Commands
{
    public class ExportProject : Sitecore.Shell.Framework.Commands.Command
    {
        public static void CopyAll(DirectoryInfo source, DirectoryInfo target, String RenameToken)
        {
            // Check if the target directory exists, if not, create it.
            if (Directory.Exists(target.FullName) == false)
            {
                Directory.CreateDirectory(target.FullName);
            }

            // Copy each file into it’s new directory.
            foreach (FileInfo fi in source.GetFiles())
            {
                Console.WriteLine(@"Copying {0}\{1}", target.FullName, fi.Name);

                var returnInfo = fi.CopyTo(Path.Combine(target.ToString(), fi.Name), true);

            }

            // Copy each subdirectory using recursion.
            foreach (DirectoryInfo diSourceSubDir in source.GetDirectories())
            {
                DirectoryInfo nextTargetSubDir =
                    target.CreateSubdirectory(diSourceSubDir.Name);
                CopyAll(diSourceSubDir, nextTargetSubDir, RenameToken);
            }
        }

        private static void RunPowershellScript(string scriptFilePath, string application, string scriptParameters)
        {
            Process proc = null;
            try
            {
                string targetDir = string.Format(scriptFilePath);//this is where mybatch.bat lies
                proc = new Process();
                proc.StartInfo.WorkingDirectory = targetDir;
                proc.StartInfo.FileName = targetDir + "\\" + application;
                proc.StartInfo.Arguments = string.Format(scriptParameters);//this is argument
                proc.StartInfo.CreateNoWindow = false;
                proc.StartInfo.RedirectStandardOutput = true;
                proc.StartInfo.RedirectStandardError = true;
                proc.EnableRaisingEvents = true;
                proc.StartInfo.UseShellExecute = false;
                // see below for output handler
             

                proc.Start();

                proc.BeginErrorReadLine();
                proc.BeginOutputReadLine();

                proc.WaitForExit();


            }
            catch (Exception ex)
            {

            }
        }

        public static void RenameAll(DirectoryInfo source, String RenameToken)
        {
            foreach (var fi in source.GetFiles())
            {
                fi.MoveTo(fi.FullName.Replace("SiteName", RenameToken));
                fi.MoveTo(fi.FullName.Replace("SiteEnvironment", RenameToken));
            }

            // Copy each subdirectory using recursion.
            foreach (DirectoryInfo diSourceSubDir in source.GetDirectories())
            {
                RenameAll(diSourceSubDir, RenameToken);
            }
        }

        public override void Execute(CommandContext context)
        {
            ProgressBox.Execute("Exporting Site", "Generating Configuration, Databases, Files, Update Packages", StartProcess, new object[] { context.Items[0].ID.ToString() });

            //Step 1: Move over empty deploy template
            //Step 2: Create Item Packages
            //Step 3: Move Project Output
            //Step 4: Fill in Deploy Scripts
            //Step 5: Generate Output
            //Step 6: Run Go.cmd to generate nuget package
            //Step 7: Deploy script to stop IIS install, and warm up.
            //Step 8: Hit site and warm cache
            //Step 9: Run Smoke Tests
            //Step 10: Send Deployment Confirmation Email.
            Sitecore.Data.Database db = Factory.GetDatabase("master");
            var items = context.Items[0];

             foreach (Item project in items.Children)
             {
                 RunPowershellScript(@"C:\Export\" + project.Name + "\\SiteName\\SiteEnvironment", "go.cmd", "package");
             }

        
        }
         


     

        public void StartProcess(params object[] parameters)
        {
            using (new Sitecore.SecurityModel.SecurityDisabler())
            {
                Sitecore.Data.Database db = Factory.GetDatabase("master");
                var document = new Sitecore.Install.PackageProject
                                   {Metadata = {PackageName = "package.update", Author = "Tim Ward"}};


                var source = new Sitecore.Install.Items.ExplicitItemSource {Name = "source"};
                    //Create source – source should be based on BaseSource
                var items = db.GetItem(parameters[0].ToString());

                foreach (Item project in items.Children)
                {
                    CopyAll(new DirectoryInfo(@"C:\SiteTemplate"), new DirectoryInfo(@"C:\Export\" + project.Name), project.Name);

                    foreach (var item in project.Axes.GetDescendants())
                    {
                        source.Entries.Add(new Sitecore.Install.Items.ItemReference(item.Uri, false).ToString());
                    }

                    document.Sources.Add(source);
                    document.SaveProject = true;

                    //path where the zip file package is saved
                    using (var writer = new Sitecore.Install.Zip.PackageWriter(@"C:\Export\" + project.Name + "\\SiteName\\SiteEnvironment\\items\\" + " package.update " + DateTime.Now.Ticks.ToString() + ".zip"))
                    {
                        Sitecore.Context.SetActiveSite("shell");

                        writer.Initialize(Sitecore.Install.Installer.CreateInstallationContext());

                        Sitecore.Install.PackageGenerator.GeneratePackage(document, writer);

                        Sitecore.Context.SetActiveSite("website");
                    }
                }

               
            }
        }
    }
}


