using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace ConfigurationTransform
{
    public static class Common
    {
        public static string XSLTComparisonTransform(string Compare, string CompareAgainst)
        {
            var copyCompareXSLT = File.ReadAllText("Turbo.xslt");
            var indexOfDocument = copyCompareXSLT.IndexOf(@"document('");
            copyCompareXSLT = copyCompareXSLT.Replace(copyCompareXSLT.Substring(indexOfDocument, (copyCompareXSLT.IndexOf("')", indexOfDocument)+ 2) - indexOfDocument ), "document('" + CompareAgainst + "')");
            var compareFileName = "Comparison-" + Guid.NewGuid().ToString() + ".xslt";
            File.WriteAllText(compareFileName, copyCompareXSLT);
            XPathDocument myXPathDoc = new XPathDocument(Compare);
            XslCompiledTransform myXslTrans = new XslCompiledTransform();
            XmlUrlResolver resolver = new XmlUrlResolver()
            {
                
            };

            var settings = new XsltSettings()
            {
                 EnableDocumentFunction = true
            };
            myXslTrans.Load(compareFileName, settings, resolver);
            if (File.Exists("result.xml"))
            {
                File.Delete("result.xml");
            }

            XmlTextWriter myWriter = new XmlTextWriter("result.xml", null)
            {
                Formatting = Formatting.Indented
            };
            myXslTrans.Transform(myXPathDoc, null, myWriter);
            myWriter.Close();
            string result;
            using (StreamReader sr = new StreamReader("result.xml"))
            {
                result = sr.ReadToEnd();
                sr.Close();
                sr.Dispose();
            }
            myWriter.Dispose();
            if (File.Exists(compareFileName))
            {
                File.Delete(compareFileName);
            }
            return result;
        }

        public static String PrintXML(String XML)
        {
            String Result = "";

            MemoryStream mStream = new MemoryStream();
            XmlTextWriter writer = new XmlTextWriter(mStream, Encoding.Unicode);
            XmlDocument document = new XmlDocument();

            try
            {
                // Load the XmlDocument with the XML.
                document.LoadXml(XML);

                writer.Formatting = Formatting.Indented;

                // Write the XML into a formatting XmlTextWriter
                document.WriteContentTo(writer);
                writer.Flush();
                mStream.Flush();

                // Have to rewind the MemoryStream in order to read
                // its contents.
                mStream.Position = 0;

                // Read MemoryStream contents into a StreamReader.
                StreamReader sReader = new StreamReader(mStream);

                // Extract the text from the StreamReader.
                String FormattedXML = sReader.ReadToEnd();

                Result = FormattedXML.Replace(" ", "&nbsp;");
            }
            catch (XmlException ex)
            {
                throw (ex);
            }

            mStream.Close();
            writer.Close();

            return Result;
        }

        private static bool IsEmptyResult(string result)
        {
            return (File.ReadAllText("./empty.xml") == result);
        }
    }
    
}
