<%@ Page Title="Listado de Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductosListados.aspx.cs" Inherits="Presentacion.ProductosListados" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-7xl mx-auto">

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Listado de Productos</h1>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Busca, visualiza y administra tus productos.</p>
            </div>
            <asp:Button ID="btnNuevo" runat="server" Text="➕ Agregar Producto"
                PostBackUrl="~/ProductosForms.aspx"
                CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90" />
        </div>

        <asp:UpdatePanel ID="upnlGrillaProductos" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                
                <div class="flex flex-col sm:flex-row items-center justify-between gap-4 mb-4">
                    <div class="relative w-full sm:max-w-xs">
                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                            <span class="material-symbols-outlined text-slate-400">search</span>
                        </div>
                        
                        <asp:TextBox ID="txtBuscar" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-10 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-10 pr-4 text-sm font-normal leading-normal"
                            placeholder="Buscar por SKU o Descripción..."
                            AutoPostBack="true" 
                            OnTextChanged="txtBuscar_TextChanged" />
                            <%-- Los atributos 'onfocus' y 'style' los agregamos desde el C# (CodeBehind) --%>
                    </div>
                </div>

                <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60 overflow-hidden">
                    <div class="overflow-x-auto">
                        
                        <asp:GridView ID="gvProductos" runat="server"
                            AutoGenerateColumns="False"
                            DataKeyNames="IDArticulo" 
                            OnRowCommand="gvProductos_RowCommand"
                            CssClass="w-full text-sm text-left text-slate-500 dark:text-slate-400"
                            GridLines="None"
                            AllowPaging="True" PageSize="10">

                            <HeaderStyle CssClass="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-700/50" />
                            <RowStyle CssClass="bg-white dark:bg-slate-800 border-b dark:border-slate-700/60 hover:bg-slate-50 dark:hover:bg-slate-700/40" />
                            <PagerStyle CssClass="flex items-center justify-between p-4" />

                            <Columns>

                                <asp:BoundField DataField="IDArticulo" HeaderText=" SKU"
                                    HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />

                                <asp:BoundField DataField="Descripcion" HeaderText="Descripción"
                                    HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />

                                <asp:BoundField DataField="Marca.Descripcion" HeaderText="Marca" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />

                                <asp:BoundField DataField="Categorias.descripcion" HeaderText="Categoría" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />

                                <asp:BoundField DataField="PrecioVenta" HeaderText="Precio Venta" DataFormatString="$ {0:N2}" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 text-right font-bold text-green-600" />

                                <asp:BoundField DataField="StockActual" HeaderText="Stock" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center font-bold" />

                                <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center">
                                    <ItemTemplate>
                                        <div class="flex justify-center gap-2">

                                            <asp:HyperLink ID="lnkEditarStock" runat="server"
                                                NavigateUrl='<%# "~/GestionStock.aspx?id=" + Eval("IDArticulo") %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-primary/10 hover:text-primary dark:hover:bg-primary/20">
                                                <span class="material-symbols-outlined text-lg">edit</span>
                                            </asp:HyperLink>

                                            <asp:LinkButton ID="btnEliminar" runat="server"
                                                CommandName="EliminarProducto" CommandArgument='<%# Eval("IDArticulo") %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-red-500/10 hover:text-red-500 dark:hover:bg-red-500/20"
                                                OnClientClick="return confirm('¿Está seguro de que desea eliminar este producto?');">
                                                <span class="material-symbols-outlined text-lg">delete</span>
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                    </div>
                </div>

            </ContentTemplate>
            
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="txtBuscar" EventName="TextChanged" />
            </Triggers>

        </asp:UpdatePanel>
        </div>
</asp:Content>