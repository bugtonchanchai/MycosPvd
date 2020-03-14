<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" MasterPageFile="~/Main.Master" Inherits="MycosPvd.Home" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="scipt01" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="udp" runat="server">
        <ContentTemplate>
            <div class="row">
                <div class="col-12">
                    <asp:Button ID="btnRefresh" runat="server" CssClass="btn btn-sm btn-primary" Text="Refresh" OnClick="btnRefresh_Click" />
                    <br />
                    <br />
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <asp:GridView ID="gridResult"
                        CssClass="table table-bordered table-hover"
                        runat="server"
                        DataKeyNames="ID"
                        OnRowEditing="gridResult_RowEditing"
                        OnRowCancelingEdit="gridResult_RowCancelingEdit"
                        OnRowUpdating="gridResult_RowUpdating"
                        OnRowDeleting="gridResult_RowDeleting"
                        OnRowDataBound="gridResult_RowDataBound"
                        EmptyDataText="No data founded"
                        ShowFooter="true"
                        AutoGenerateColumns="false"
                        HeaderStyle-HorizontalAlign="Center"
                        RowStyle-HorizontalAlign="Center"
                        FooterStyle-HorizontalAlign="Center">
                        <Columns>
                            <asp:CommandField
                                ButtonType="Link"
                                ShowEditButton="true"
                                ShowDeleteButton="true"
                                ShowInsertButton="false"
                                ItemStyle-HorizontalAlign="Center" />
                            <asp:TemplateField HeaderText="First name">
                                <ItemTemplate>
                                    <asp:Label ID="lblFirstName" runat="server" Text='<%# Eval("FNAME") %>' />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtFirstName" CssClass="form-control-sm" runat="server" Text='<%# Eval("FNAME") %>' AutoCompleteType="None" autocomplete="off" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="txtFirstName" CssClass="form-control-sm" runat="server" placeholder="enter first name" AutoCompleteType="None" autocomplete="off" />
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Last name">
                                <ItemTemplate>
                                    <asp:Label ID="lblLastName" runat="server" Text='<%# Eval("LNAME") %>' />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtLastName" CssClass="form-control-sm" runat="server" Text='<%# Eval("LNAME") %>' AutoCompleteType="None" autocomplete="off" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="txtLastName" CssClass="form-control-sm" runat="server" placeholder="enter last name" AutoCompleteType="None" autocomplete="off" />
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Birth date">
                                <ItemTemplate>
                                    <asp:Label ID="lblBirthDate" runat="server" Text='<%# Eval("BIRTHDATE") %>' />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtBirthDate" TextMode="Date" CssClass="form-control-sm" runat="server" Text='<%# Eval("BIRTHDATE") %>' AutoCompleteType="None" autocomplete="off" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="txtBirthDate" TextMode="Date" CssClass="form-control-sm" runat="server" Text='<%# DateTime.Now.ToString("yyyy-MM-dd") %>' AutoCompleteType="None" autocomplete="off" />
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Start date">
                                <ItemTemplate>
                                    <asp:Label ID="lblStartDate" runat="server" Text='<%# Eval("EMPLOYDATE") %>' />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtStartDate" TextMode="Date" CssClass="form-control-sm" runat="server" Text='<%# Eval("EMPLOYDATE") %>' AutoCompleteType="None" autocomplete="off" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="txtStartDate" TextMode="Date" CssClass="form-control-sm" runat="server" Text='<%# DateTime.Now.ToString("yyyy-MM-dd") %>' AutoCompleteType="None" autocomplete="off" />
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Salary">
                                <ItemTemplate>
                                    <asp:Label ID="lblSaraly" runat="server" Text='<%#  String.Format("{0:0,00}", Convert.ToDecimal(Eval("SALARY"))) %>' />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtSaraly" TextMode="Number" CssClass="form-control-sm" runat="server" Text='<%# Eval("SALARY") %>' AutoCompleteType="None" autocomplete="off" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="txtSaraly" TextMode="Number" CssClass="form-control-sm" runat="server" placeholder="85000" AutoCompleteType="None" autocomplete="off" />
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="PVD rate">
                                <ItemTemplate>
                                    <asp:Label ID="lblPvdRate" runat="server" Text='<%# Eval("PVDRATE") %>' />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtPvdRate" TextMode="Number" CssClass="form-control-sm" runat="server" Text='<%# Eval("PVDRATE") %>' AutoCompleteType="None" autocomplete="off" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="txtPvdRate" TextMode="Number" CssClass="form-control-sm" runat="server" placeholder="12" AutoCompleteType="None" autocomplete="off" />
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Years of service">
                                <ItemTemplate>
                                    <asp:Label ID="lblWorkAge" runat="server" Text='<%# int.Parse(Eval("WMONTH").ToString()) / 12 + "Y " + int.Parse(Eval("WMONTH").ToString()) % 12 + "M" %>' />
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Button ID="bthAdd" runat="server" CssClass="btn btn-sm btn-primary" Width="100%" Text="Add" OnClick="bthAdd_Click" />
                                </FooterTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="PVD (result)" ControlStyle-Font-Bold="true" HeaderStyle-BackColor="LightGray">
                                <ItemTemplate>
                                    <asp:Label ID="lblPvdTotal" runat="server" Text='<%# String.Format("{0:0,00}", Convert.ToDecimal(Eval("PVDTOTAL"))) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <asp:Label ID="lblError" runat="server" CssClass="text-danger"></asp:Label>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnRefresh" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
