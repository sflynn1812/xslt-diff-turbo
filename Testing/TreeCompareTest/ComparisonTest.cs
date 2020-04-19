using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using System.Xml.XPath;
using System.Xml;
using System.Xml.Xsl;
using System.Diagnostics;

namespace ConfigurationTransform.Comparison.Test
{
    [TestClass]
    public class ComparisonTest
    {
        [TestMethod]
        public void IdentityComparison()
        {
            var result = Common.XSLTComparisonTransform("./IdentityComparison/lefthand.xml", "./IdentityComparison/righthand.xml");
            var expected = File.ReadAllText("./IdentityComparison/result.xml");
            Assert.AreEqual(expected, result);
        }
        [TestMethod]
        public void BranchSymmetry()
        {
            var result = Common.XSLTComparisonTransform("./BranchSymmetry/lefthand.xml", "./BranchSymmetry/righthand.xml");
            var expected = File.ReadAllText("./BranchSymmetry/result.xml");
            Assert.AreEqual(expected, result);
        }
        [TestMethod]
        public void OrphanedBranch()
        {
            var result = Common.XSLTComparisonTransform("./OrphanedBranch/lefthand.xml", "./OrphanedBranch/righthand.xml");
            var expected = File.ReadAllText("./OrphanedBranch/result.xml");
            Assert.AreEqual(expected, result);
        }
        [TestMethod]
        public void TwinOrphaned()
        {
            var result = Common.XSLTComparisonTransform("./TwinOrphan/lefthand.xml", "./TwinOrphan/righthand.xml");
            var expected = File.ReadAllText("./TwinOrphan/result.xml");
            Assert.AreEqual(expected, result);
        }
        [TestMethod]
        public void ComplexExample()
        {
            var result = Common.XSLTComparisonTransform("./ComplexExample/lefthand.xml", "./ComplexExample/righthand.xml");
            var expected = File.ReadAllText("./ComplexExample/result.xml");
            Assert.AreEqual(expected.Replace(" ","").Replace("\r","").Replace("\n",""), result.Replace(" ","").Replace(" ", "").Replace("\r", "").Replace("\n", ""));
        }
        [TestMethod]
        public void TextComparison()
        {
            var result = Common.XSLTComparisonTransform("./TextComparison/lefthand.xml", "./TextComparison/righthand.xml");
            var expected = File.ReadAllText("./TextComparison/result.xml");
            Assert.AreEqual(expected.Replace(" ", "").Replace("\r", "").Replace("\n", ""), result.Replace(" ", "").Replace(" ", "").Replace("\r", "").Replace("\n", ""));
        }

        [TestMethod]
        public void NewLineText()
        {
            var result = Common.XSLTComparisonTransform("./NewLineText/lefthand.xml", "./NewLineText/righthand.xml");
            var expected = File.ReadAllText("./NewLineText/result.xml");
            Assert.AreEqual(expected, result);
        }
        [TestMethod]
        public void LiveComparison()
        {
            var result = Common.XSLTComparisonTransform("./LiveComparison/lefthand.xml", "./LiveComparison/righthand.xml");
            var expected = File.ReadAllText("./LiveComparison/result.xml");
            Assert.AreEqual(expected.Replace(" ", "").Replace("\r", "").Replace("\n", ""), result.Replace(" ", "").Replace(" ", "").Replace("\r", "").Replace("\n", ""));
        }

        [TestMethod]
        public void CommandLine()
        {
            var startInfo = new ProcessStartInfo()
            {
                Arguments = @"CommandLineA CommandLineA",
                WorkingDirectory = Path.GetFullPath(Path.Combine(Directory.GetCurrentDirectory(), "..")),
                FileName = @"ConfigComparisonCommand.exe",
                UseShellExecute = true
            };
            var p = Process.Start(startInfo);
            p.WaitForExit();
            Assert.AreEqual(p.ExitCode, 0); 
        }

        [TestMethod]
        public void CommandLineNegative()
        {
            var startInfo = new ProcessStartInfo()
            {
                Arguments = @"CommandLineB CommandLineA",
                WorkingDirectory = Path.GetFullPath(Path.Combine(Directory.GetCurrentDirectory(), "..")),
                FileName = @"ConfigComparisonCommand.exe",
                UseShellExecute = true
            };
            var p = Process.Start(startInfo);
            p.WaitForExit();
            Assert.AreEqual(p.ExitCode, -1);
        }
    }
}
