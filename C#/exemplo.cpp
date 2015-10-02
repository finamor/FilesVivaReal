using System;

using System.Xml;
 
namespace VivaRealExport
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			XmlWriterSettings settings = new XmlWriterSettings ();
			settings.Indent = true;
 
			using (XmlWriter writer = XmlWriter.Create(Console.Out, settings)) {
				writer.WriteStartDocument ();
 
				writer.WriteStartElement ("ListingDataFeed", "http://www.vivareal.com/schemas/1.0/VRSync");
				writer.WriteAttributeString ("xmlns", "xsi", null, "http://www.w3.org/2001/XMLSchema-instance");
				writer.WriteAttributeString ("xsi", "schemaLocation", null, "http://www.vivareal.com/schemas/1.0/VRSync");
 
				WriteHeader (writer);
 
				WriteListings (writer);
 
				writer.WriteEndElement ();
 
				writer.WriteEndDocument ();
			}
		}
 
		public static void WriteHeader (XmlWriter writer)
		{
			writer.WriteStartElement ("Header");
			writer.WriteElementString ("Provider", "Fornecedor do Feed Brasil");
			writer.WriteElementString ("Email", "contacto@fornecedor.com");
			writer.WriteElementString ("ContactName", "Nome para Contato");
			writer.WriteElementString ("Telephone", "(41)3216-2795 (11)9669-2395");
			writer.WriteElementString ("PublishDate", "2009-08-10T11:17:14");
			writer.WriteElementString ("Logo", "http://www.fornecedor.com.br/logo.jpg");
			writer.WriteEndElement ();
		}
 
		static void WriteListings (XmlWriter writer)
		{
			writer.WriteStartElement ("Listings");
			WriteListing (writer);
			writer.WriteEndElement ();
		}
 
		public static void WriteListing (XmlWriter writer)
		{
			writer.WriteStartElement ("Listing");
			writer.WriteElementString ("ListingID", "1005434");
			writer.WriteElementString ("Title", "Venda Sobrado Curitiba PR Brasil");
			writer.WriteElementString ("TransactionType", "For Sale");
			writer.WriteElementString ("Featured", "true");
			writer.WriteElementString ("ListDate", "2012-05-07T15:30:00");
			writer.WriteElementString ("LastUpdateDate", "2012-05-07T03:05:00");
			writer.WriteElementString ("DetailViewUrl", "http://www.fornecedor.com.br/imoveis");
			writer.WriteElementString ("TrackingCode", "TrackingCode");
			writer.WriteElementString ("VirtualTourUrl", "VirtualTourUrl");
 
			writer.WriteStartElement ("Media");
			WriteImage (writer, "http://www.fornecedor.com.br/image.jpg", "Quarto do Imóvel", true);
			WriteImage (writer, "http://www.fornecedor.com.br/image1.jpg", "Banheiro do Imóvel");
			WriteImage (writer, "http://www.fornecedor.com.br/image2.jpg", "Sala");
			WriteImage (writer, "http://www.fornecedor.com.br/image3.jpg", "Exterior");
			writer.WriteEndElement ();
 
			writer.WriteStartElement ("Status");
			writer.WriteElementString ("PropertyStatus", "Available");
			writer.WriteElementString ("StatusDate", "2001-12-31T12:00:00");
			writer.WriteStartElement ("ClosingPrice");
			writer.WriteAttributeString ("currency", "BRL");
			writer.WriteString ("0");
			writer.WriteEndElement ();
			writer.WriteEndElement ();
 
			writer.WriteStartElement ("Details");
 
			writer.WriteElementString ("PropertyType", "Residential / Condo");
 
			writer.WriteElementString ("Description", "<![CDATA[Sobrados novos com 03 pavimentos contendo em cada nivel os seguintes ambientes: TÉRREO: Sala de estar, Sala de jantar, lavabo, Copa/Cozinha, Área de serviço, Churrasquei ra, quintal fundos, Central a Gás, garagem para 2 carros sendo 1 coberto, PAVIMENTO SUPERIOR: 03 dormitórios sendo um suite com hidromassagem e sacada, banheiro social, circulação.]]>");
			writer.WriteStartElement ("ListPrice");
			writer.WriteAttributeString ("currency", "BRL");
			writer.WriteString ("105000");
			writer.WriteEndElement ();
 
			writer.WriteStartElement ("RentalPrice");
			writer.WriteAttributeString ("currency", "BRL");
			writer.WriteString ("880");
			writer.WriteEndElement ();
 
			writer.WriteElementString ("AvailableDate", "2001-12-31T12:00:00");
 
			writer.WriteStartElement ("PropertyAdministrationFee");
			writer.WriteAttributeString ("currency", "BRL");
			writer.WriteAttributeString ("period", "Daily");
			writer.WriteString ("100");
			writer.WriteEndElement ();
 
			writer.WriteStartElement ("ConstructedArea");
			writer.WriteAttributeString ("unit", "square metres");
			writer.WriteString ("145");
			writer.WriteEndElement ();
 
			writer.WriteStartElement ("LotArea");
			writer.WriteAttributeString ("unit", "square metres");
			writer.WriteString ("145");
			writer.WriteEndElement ();
 
			writer.WriteStartElement ("LivingArea");
			writer.WriteAttributeString ("unit", "square metres");
			writer.WriteString ("145");
			writer.WriteEndElement ();
 
			writer.WriteElementString ("DevelopmentLevel", "Under Construction");
 
			writer.WriteElementString ("YearBuilt", "0");
 
			writer.WriteElementString ("Bedrooms", "1");
 
			writer.WriteElementString ("Bathrooms", "1");
 
			writer.WriteElementString ("Suites", "0");
 
			writer.WriteStartElement ("Garage");
			writer.WriteAttributeString ("type", "Garage");
			writer.WriteString ("0");
			writer.WriteEndElement ();
 
			writer.WriteElementString ("Estrato", "1");
 
			writer.WriteElementString ("UnitNumber", "Apto 405");
 
			writer.WriteStartElement ("Features");
			writer.WriteElementString ("Feature", "Fully Wired");
			writer.WriteElementString ("Feature", "Bar");
			writer.WriteElementString ("Feature", "24 Hour Security");
			writer.WriteElementString ("Feature", "Air Conditioning");
			writer.WriteEndElement ();
 
			writer.WriteEndElement ();
 
			WriteLocation (writer);
 
			WriteContactInfo (writer);
 
			writer.WriteEndElement ();
		}
 
		static void WriteMedia (XmlWriter writer, String url, String caption, Boolean primary, String medium)
		{
			writer.WriteStartElement ("Item");
			writer.WriteAttributeString ("medium", medium);
			writer.WriteAttributeString ("caption", caption);
			writer.WriteAttributeString ("primary", primary ? "true" : "false");
			writer.WriteString (url);
			writer.WriteEndElement ();
		}
 
		static void WriteImage (XmlWriter writer, String url, String caption, Boolean primary)
		{
			WriteMedia (writer, "image", caption, primary, url);
		}
 
		static void WriteImage (XmlWriter writer, String url, String caption)
		{
			WriteMedia (writer, "image", caption, false, url);
		}
 
		static void WriteLocation (XmlWriter writer)
		{
			writer.WriteStartElement ("Location");
			writer.WriteStartElement ("Country");
			writer.WriteAttributeString ("abbreviation", "BR");
			writer.WriteString ("Brasil");
			writer.WriteEndElement ();
			writer.WriteStartElement ("State");
			writer.WriteAttributeString ("abbreviation", "SP");
			writer.WriteString ("Sao Paulo");
			writer.WriteEndElement ();
			writer.WriteElementString ("City", "Florianopolis");
			writer.WriteElementString ("Zone", "Zona Leste");
			writer.WriteElementString ("Neighborhood", "Bras");
			writer.WriteStartElement ("Address");
			writer.WriteAttributeString ("publiclyVisible", "true");
			writer.WriteString ("R. Guarandi");
			writer.WriteEndElement ();
			writer.WriteElementString ("Latitude", "-25.4188");
			writer.WriteElementString ("Longitude", "-25.4188");
			writer.WriteEndElement ();
		}
 
		static void WriteContactInfo (XmlWriter writer)
		{
			writer.WriteStartElement ("ContactInfo");
			writer.WriteElementString ("Name", "Fornecedor do Feed Brasil");
			writer.WriteElementString ("Email", "fornecedor@brasil.com.br");
			writer.WriteElementString ("Telephone", "(41)3216-2795 (11)9669-2395");
			writer.WriteElementString ("Photo", "Photo");
			writer.WriteElementString ("Logo", "logo");
			writer.WriteElementString ("OfficeName", "OfficeName");
			WriteLocation (writer);
			writer.WriteEndElement ();
		}
	}
}