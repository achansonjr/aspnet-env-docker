using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace simple_web_app
{
  public partial class Default : System.Web.UI.Page
  {
    public string connectionString { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
      connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString.ToString();
      String pageTitle = System.Configuration.ConfigurationManager.AppSettings["PageTitle"].ToString();
      Page.Title = string.Format(pageTitle + " :: {0:d}", DateTime.Now);
    }
  }
}