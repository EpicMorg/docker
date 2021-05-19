namespace Epicmorg.DockerGenerator
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Runtime.InteropServices;
    using System.Text.Json;
    using System.Threading.Tasks;

    class Program
    {
        /// <summary>
        /// EpicMorg docker build script generator
        /// </summary>
        /// <param name="workdir">Working directory</param>
        /// <param name="json">Atlassian product JSON</param>
        /// <param name="product">Product name</param>
        /// <param name="force">Overwrite existing directories</param>
        /// <param name="archiveType">Overwrite archive type</param>
        /// <param name="ignoreVersionsWithoutTemplates">Silently ignore versions without templates</param>
        /// <returns></returns>
        public static async Task Main(DirectoryInfo workdir, FileInfo json, string product, bool force = false, bool ignoreVersionsWithoutTemplates = false,string archiveType = ".tar.gz")
        {
            var jsonData = File.ReadAllText(json.FullName)["downloads(".Length..^1];
            var items = JsonSerializer.Deserialize<ResponseItem[]>(jsonData, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            foreach (var item in items.Where(a=>a.ZipUrl.ToString().EndsWith(archiveType) && !a.ZipUrl .ToString().Contains("-war")))
            {
                var majorVersion = item.Version.Split(".").First();
                var templatePath = Path.Combine(workdir.FullName, product, "templates", majorVersion);
                if (!Directory.Exists(templatePath))
                {
                    if (!ignoreVersionsWithoutTemplates)
                    {
                        Console.Error.WriteLine("Failed to find template for the major version {0}. Exiting", majorVersion);
                        return;
                    }
                    else
                    {
                        Console.Error.WriteLine("Failed to find template for the major version {0}. Skipping", majorVersion);
                        continue;
                    }
                }

                var localPath = Path.Combine(product, majorVersion, item.Version);
                var outputPath = Path.Combine(workdir.FullName, localPath);
                if (Directory.Exists(outputPath))
                {
                    if (!force)
                    {
                        Console.Error.WriteLine("Directory '{0}' already exists, skipping", localPath);
                        continue;
                    }
                    else
                    {
                        Console.Error.WriteLine("Directory '{0}' already exists, overwriting", localPath);
                        Directory.Delete(outputPath, true);
                    }
                }
                Directory.CreateDirectory(outputPath);
                CopyFilesRecursively(new DirectoryInfo(templatePath), new DirectoryInfo(outputPath));
                File.WriteAllText(
                    Path.Combine(outputPath, ".env"),
                    @$"
RELEASE={item.Version}
DOWNLOAD_URL={item.ZipUrl}
"
                );
            }

        }

        private static void CopyFilesRecursively(DirectoryInfo source, DirectoryInfo target)
        {
            foreach (DirectoryInfo dir in source.GetDirectories())
                CopyFilesRecursively(dir, target.CreateSubdirectory(dir.Name));
            foreach (FileInfo file in source.GetFiles())
                file.CopyTo(Path.Combine(target.FullName, file.Name));
        }

        public partial class ResponseItem
        {
            public string Description { get; set; }
            public string Edition { get; set; }
            public Uri ZipUrl { get; set; }
            public string TarUrl { get; set; }
            public string Md5 { get; set; }
            public string Size { get; set; }
            public string Released { get; set; }
            public string Type { get; set; }
            public string Platform { get; set; }
            public string Version { get; set; }
            public Uri ReleaseNotes { get; set; }
            public Uri UpgradeNotes { get; set; }
        }
    }
}
