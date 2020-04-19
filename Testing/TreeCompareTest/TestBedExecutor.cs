using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Xml;
using System.Xml.Xsl;
using ConfigurationTransform;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace TreeCompareTest
{
    [TestClass]
    public class TestBedExecutor
    {
        [TestMethod]
        public void IdentityCompare1()
        {
            var result = Regex.Replace(Common.XSLTComparisonTransform("./IdentityCompare1/left.xml", "./IdentityCompare1/right.xml"), @"\s+", "");
            var expected = Regex.Replace(File.ReadAllText("./IdentityCompare1/result.xml"), @"\s+", "");
            Assert.AreEqual(expected, result);
        }

        [TestMethod]
        public void BranchSymmetry1()
        {
            var result = Regex.Replace(Common.XSLTComparisonTransform("./BranchSymmetry1/left.xml", "./BranchSymmetry1/right.xml"), @"\s+", "");
            var expected = Regex.Replace(File.ReadAllText("./BranchSymmetry1/result.xml"), @"\s+", "");
            Assert.AreEqual(expected, result);
        }

        [TestMethod]
        public void DifferenceCompare1()
        {
            var result = Regex.Replace(Common.XSLTComparisonTransform("./DifferenceCompare1/left.xml", "./DifferenceCompare1/right.xml"), @"\s+", ""); ;
            var expected = Regex.Replace(File.ReadAllText("./DifferenceCompare1/result.xml"), @"\s+", ""); ;
            Assert.AreEqual(expected, result);
        }

        [TestMethod]
        public void BranchSymmetry2()
        {
            var result = Regex.Replace(Common.XSLTComparisonTransform("./BranchSymmetry2/left.xml", "./BranchSymmetry2/right.xml"), @"\s+", "");
            var expected = Regex.Replace(File.ReadAllText("./BranchSymmetry2/result.xml"), @"\s+", "");
            Assert.AreEqual(expected, result);
        }

        [TestMethod]
        public void OrphanTwinning1()
        {
            var result = Regex.Replace(Common.XSLTComparisonTransform("./OrphanTwinning1/left.xml", "./OrphanTwinning1/right.xml"), @"\s+", ""); ;
            var expected = Regex.Replace(File.ReadAllText("./OrphanTwinning1/result.xml"), @"\s+", ""); ;
            Assert.AreEqual(expected, result);
        }
    }
}
