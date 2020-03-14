using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace MycosPvd
{
    public partial class Home : System.Web.UI.Page
    {
        #region "EVENT"
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsPostBack)
                {
                    bindGridView();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.ToString();
                lblError.Visible = true;
            }
        }
        protected void gridResult_RowEditing(object sender, GridViewEditEventArgs e)
        {
            try
            {
                gridResult.EditIndex = e.NewEditIndex;
                bindGridView();
            }
            catch (Exception ex)
            {
                lblError.Text = ex.ToString();
                lblError.Visible = true;
            }
        }
        protected void gridResult_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            try
            {
                gridResult.EditIndex = -1;
                bindGridView();
            }
            catch (Exception ex)
            {
                lblError.Text = ex.ToString();
                lblError.Visible = true;
            }
        }
        protected void gridResult_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = gridResult.Rows[e.RowIndex];
                string strPrimaryKey = gridResult.DataKeys[e.RowIndex].Values[0].ToString();

                if (validate(row))
                {
                    updateData(strPrimaryKey, row);
                    gridResult.EditIndex = -1;
                    bindGridView();
                }                
            }
            catch (Exception ex)
            {
                lblError.Text = ex.ToString();
                lblError.Visible = true;
            }
        }
        protected void gridResult_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                string strPrimaryKey = gridResult.DataKeys[e.RowIndex].Values[0].ToString();

                deleteData(strPrimaryKey);

                gridResult.EditIndex = -1;
                bindGridView();
            }
            catch (Exception ex)
            {
                lblError.Text = ex.ToString();
                lblError.Visible = true;
            }
        }
        protected void gridResult_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.Header)
                {
                    e.Row.TableSection = TableRowSection.TableHeader;
                }
                else if (e.Row.RowType == DataControlRowType.DataRow)
                {
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.ToString();
                lblError.Visible = true;
            }
        }
        protected void bthAdd_Click(object sender, EventArgs e)
        {
            try
            {
                GridViewRow row = gridResult.FooterRow;
                if (validate(row))
                {
                    addData(row);
                    bindGridView();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.ToString();
                lblError.Visible = true;
            }
        }
        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            try
            {
                bindGridView();
            }
            catch (Exception ex)
            {
                lblError.Text = ex.ToString();
                lblError.Visible = true;
            }
        }
        #endregion


        #region "METHOD"        
        protected void bindGridView()
        {
            try
            {
                lblError.Text = "";
                DataTable dt, dtPvdCondition;
                string strSql = "select * FROM V_TRANSACTION WHERE 1=1 ORDER BY FNAME, LNAME";

                dt = Utils.getDataReturnDataTable(strSql, "DATA");
                dtPvdCondition = getPvdConditionReturnDataTable();

                //--- Calculate PVD ---//
                foreach (DataRow row in dt.Rows)
                {
                    int salary = 0;
                    int pvdrate = 0;
                    int wmonth = 0;
                    int companyrate = 0;
                    double pvdtotal = 0;

                    if (row["SALARY"] != null) { salary = int.Parse(row["SALARY"].ToString()); }
                    if (row["PVDRATE"] != null) { pvdrate = int.Parse(row["PVDRATE"].ToString()); }
                    if (row["WMONTH"] != null) { wmonth = int.Parse(row["WMONTH"].ToString()); }


                    DataRow[] drCondition = dtPvdCondition.Select("WORKMIN <= " + wmonth + " AND WORKMAX >= " + wmonth, "");
                    if (drCondition.Length != 1) { pvdtotal = 0; }
                    else
                    {
                        companyrate = int.Parse(drCondition[0]["PAIDPERCENT"].ToString());
                        if (companyrate != 0)
                        {
                            double companyPart = (salary * companyrate * 0.01) * (wmonth - 4);  // -3 for first 3 months, -1 for current month not yet to calculate salary
                            double employeePart = (salary * pvdrate * 0.01) * (wmonth - 4);     // -3 for first 3 months, -1 for current month not yet to calculate salary
                            pvdtotal = companyPart + employeePart;
                        }
                    }

                    row["PVDTOTAL"] = pvdtotal;
                }

                gridResult.DataSource = dt;
                gridResult.DataBind();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        protected void updateData(string strPrimaryKey, GridViewRow row)
        {
            try
            {
                string strFName = ((TextBox)row.FindControl("txtFirstName")).Text;
                string strLName = ((TextBox)row.FindControl("txtLastName")).Text;
                string strBirthDate = ((TextBox)row.FindControl("txtBirthDate")).Text;
                string strEmployDate = ((TextBox)row.FindControl("txtStartDate")).Text;
                string strSalary = ((TextBox)row.FindControl("txtSaraly")).Text;
                string strPvdRate = ((TextBox)row.FindControl("txtPvdRate")).Text;

                string strSql = "";
                strSql += " UPDATE EMPLOYEEDATA ";
                strSql += " SET FNAME = '" + strFName + "'";
                strSql += "     , LNAME = '" + strLName + "'";
                strSql += "     , BIRTHDATE = CAST('" + strBirthDate + "' AS DATE)";
                strSql += "     , EMPLOYDATE = CAST('" + strEmployDate + "' AS DATE)";
                strSql += "     , SALARY = '" + strSalary + "'";
                strSql += "     , PVDRATE = '" + strPvdRate + "'";
                strSql += " WHERE ID = '" + strPrimaryKey + "'";
                Utils.executeSQLCommand(strSql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        protected void addData(GridViewRow row)
        {
            try
            {
                string strFName = ((TextBox)row.FindControl("txtFirstName")).Text;
                string strLName = ((TextBox)row.FindControl("txtLastName")).Text;
                string strBirthDate = ((TextBox)row.FindControl("txtBirthDate")).Text;
                string strEmployDate = ((TextBox)row.FindControl("txtStartDate")).Text;
                string strSalary = ((TextBox)row.FindControl("txtSaraly")).Text;
                string strPvdRate = ((TextBox)row.FindControl("txtPvdRate")).Text;

                string strSql = " INSERT INTO EMPLOYEEDATA (ID ,FNAME ,LNAME ,BIRTHDATE ,EMPLOYDATE ,SALARY ,PVDRATE) ";
                strSql += " VALUES('" + Guid.NewGuid() + "',";
                strSql += " '" + strFName + "',";
                strSql += " '" + strLName + "',";
                strSql += " CAST('" + strBirthDate + "' AS DATE),";
                strSql += " CAST('" + strEmployDate + "' AS DATE),";
                strSql += " '" + strSalary + "',";
                strSql += " '" + strPvdRate + "') ";

                Utils.executeSQLCommand(strSql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        protected void deleteData(string strPrimaryKey)
        {
            try
            {
                string strSql = "";
                strSql += " DELETE EMPLOYEEDATA ";
                strSql += " WHERE ID = '" + strPrimaryKey + "'";
                Utils.executeSQLCommand(strSql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        protected bool validate(GridViewRow row)
        {
            string strFName = ((TextBox)row.FindControl("txtFirstName")).Text;
            string strLName = ((TextBox)row.FindControl("txtLastName")).Text;
            string strBirthDate = ((TextBox)row.FindControl("txtBirthDate")).Text;
            string strEmployDate = ((TextBox)row.FindControl("txtStartDate")).Text;
            string strSalary = ((TextBox)row.FindControl("txtSaraly")).Text;
            string strPvdRate = ((TextBox)row.FindControl("txtPvdRate")).Text;

            DataTable dtPvdCondition = getPvdConditionReturnDataTable();

            if (strFName == "")
            {
                lblError.Text = "Fist name invalid";
                return false;
            }

            if (strLName == "")
            {
                lblError.Text = "Last name invalid";
                return false;
            }

            if (strBirthDate == "")
            {
                lblError.Text = "Birth date invalid";
                return false;
            }

            if (strEmployDate == "")
            {
                lblError.Text = "Start date invalid";
                return false;
            }

            if (strSalary == "")
            {
                lblError.Text = "Salary invalid";
                return false;
            }
            else if (int.Parse(strSalary) < 0)
            {
                lblError.Text = "Salary must not below 0";
                return false;
            }

            if (strPvdRate == "")
            {
                lblError.Text = "PVD rate invalid";
                return false;
            }
            else if (int.Parse(strPvdRate) < 0)
            {
                lblError.Text = "PVD rate not below 0";
                return false;
            }

            int wmonth = (DateTime.Now - DateTime.Parse(strEmployDate)).Days / 30;
            DataRow[] drCondition = dtPvdCondition.Select("WORKMIN <= " + wmonth + " AND WORKMAX >= " + wmonth, "");
            if (drCondition.Length != 1)
            {
                lblError.Text = "Start date out of range";
                return false;
            }
            else
            {
                int maxPvdRateCond = int.Parse(drCondition[0]["MAXPVDRATE"].ToString());
                if (int.Parse(strPvdRate) > maxPvdRateCond)
                {
                    lblError.Text = "PVD rate out of range. (maximum is : " + maxPvdRateCond + "%)";
                    return false;
                }
            }

            return true;
        }
        protected DataTable getPvdConditionReturnDataTable()
        {
            try
            {
                string strSql = "select * FROM PVDCONFIG WHERE 1=1 ";

                return Utils.getDataReturnDataTable(strSql, "PVDCONFIG");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion       
    }


    public class Utils
    {
        public static string getConnectionString()
        {
            try
            {
                return ConfigurationManager.ConnectionStrings["myCosDb"].ConnectionString.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static DataTable getDataReturnDataTable(string strSql, string strTableName)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlConnection connection = new SqlConnection(getConnectionString());
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = new SqlCommand(strSql, connection);
                adapter.Fill(ds, strTableName);
                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public static void executeSQLCommand(string strSql)
        {
            try
            {
                SqlConnection connection = new SqlConnection(getConnectionString());
                SqlCommand command = new SqlCommand(strSql, connection);
                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
    }
}