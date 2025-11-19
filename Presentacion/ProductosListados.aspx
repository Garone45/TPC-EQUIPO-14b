<%@ Page Title="Listado de Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductosListados.aspx.cs" Inherits="Presentacion.ProductosListados" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/jquery-3.7.0.min.js"></script>
    <script src="Scripts/bootstrap.bundle.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-7xl mx-auto">

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Gestión de Productos</h1>
            </div>
            <asp:Button ID="btnNuevo" runat="server" Text="➕ Agregar Producto"
                PostBackUrl="~/ProductosForms.aspx"
                CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90" />
        </div>

        <asp:UpdatePanel ID="upnlGrillaProductos" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:HiddenField ID="hfIdProducto" runat="server" />
                <asp:Button ID="btnEliminarServer" runat="server" OnClick="btnEliminarServer_Click" style="display:none;" ClientIDMode="Static" />

                <div class="flex flex-col sm:flex-row items-center justify-between gap-4 mb-4">
                    <div class="relative w-full sm:max-w-xs">
                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                            <span class="material-symbols-outlined text-slate-400">search</span>
                        </div>
                        <asp:TextBox ID="txtBuscar" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-10 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-10 pr-4 text-sm font-normal leading-normal"
                            placeholder="Buscar por SKU o Descripción..."
                            onkeyup="delayPostback(this);"
                            OnTextChanged="txtBuscar_TextChanged" />
                    </div>
                </div>

                <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60 overflow-hidden">
                    <div class="overflow-x-auto">
                        <asp:GridView ID="gvProductos" runat="server"
                            AutoGenerateColumns="False"
                            DataKeyNames="IDArticulo" 
                            CssClass="w-full text-sm text-left text-slate-500 dark:text-slate-400"
                            GridLines="None"
                            AllowPaging="True" PageSize="10"
                            OnPageIndexChanging="gvProductos_PageIndexChanging">

                            <HeaderStyle CssClass="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-700/50" />
                            <RowStyle CssClass="bg-white dark:bg-slate-800 border-b dark:border-slate-700/60 hover:bg-slate-50 dark:hover:bg-slate-700/40" />
                            <PagerStyle CssClass="flex items-center justify-between p-4" />

                            <Columns>
                                <asp:BoundField DataField="IDArticulo" HeaderText="SKU" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />
                                <asp:BoundField DataField="Descripcion" HeaderText="Descripción" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />
                                <asp:BoundField DataField="Marca.Descripcion" HeaderText="Marca" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Categorias.descripcion" HeaderText="Categoría" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="PrecioVentaCalculado" HeaderText="Precio Venta" DataFormatString="$ {0:N2}" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 text-right font-bold text-green-600" />
                                <asp:BoundField DataField="StockActual" HeaderText="Stock" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center font-bold" />

                                <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center">
                                    <ItemTemplate>
                                        <div class="flex justify-center gap-2">
                                            <asp:HyperLink ID="lnkEditar" runat="server"
                                                NavigateUrl='<%# "~/ProductosForms.aspx?id=" + Eval("IDArticulo") %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-primary/10 hover:text-primary dark:hover:bg-primary/20">
                                                <span class="material-symbols-outlined text-lg">edit</span>
                                            </asp:HyperLink>

                                            <a href="javascript:void(0);" 
                                               onclick="abrirModalEliminar(<%# Eval("IDArticulo") %>);"
                                               class="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-red-500/10 hover:text-red-500 dark:hover:bg-red-500/20 cursor-pointer">
                                                <span class="material-symbols-outlined text-lg">delete</span>
                                            </a>
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

        <div class="modal fade" id="modalEliminar" tabindex="-1" aria-hidden="true" style="display: none;">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold">⚠️ Confirmar Eliminación</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center py-4">
                        <p class="mb-1 fs-5 text-dark">¿Estás seguro de que deseas eliminar este producto?</p>
                        <small class="text-muted">Esta acción realizará una baja lógica.</small>
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                       <button type="button" class="btn btn-primary fw-bold" onclick="confirmarEliminar()">Sí, Eliminar</button>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <script type="text/javascript">
        // 1. Función para abrir el modal
        function abrirModalEliminar(id) {
            // Guardamos el ID
            var hf = document.getElementById('<%= hfIdProducto.ClientID %>');
            hf.value = id;

            // Abrimos el modal usando jQuery (que ahora SÍ está cargado)
            $('#modalEliminar').modal('show');
        }

        // 2. Función para confirmar
        function ejecutarBorradoServer() {
            // Ocultamos el modal
            $('#modalEliminar').modal('hide');
            
            // Hacemos click en el botón invisible del servidor
            document.getElementById('btnEliminarServer').click();
        }

        // --- Funciones de Búsqueda (No tocar) ---
        var delayTimer;
        function delayPostback(source) {
            clearTimeout(delayTimer);
            delayTimer = setTimeout(function () { __doPostBack(source.name, ''); }, 500);
        }
        function setFocusAfterUpdate() {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function (sender, args) {
                if (args.get_error() == null) {
                    var focusedControl = $get('<%= txtBuscar.ClientID %>');
                    if (focusedControl) {
                        var val = focusedControl.value;
                        focusedControl.focus();
                        focusedControl.value = ''; focusedControl.value = val;
                    }
                }
            });
        }
        try { if (typeof Sys !== 'undefined') setFocusAfterUpdate(); } catch (e) { }
    </script>
</asp:Content>