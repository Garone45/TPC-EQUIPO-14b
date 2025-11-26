<%@ Page Title="Listado de Ventas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VentasListado.aspx.cs" Inherits="Presentacion.VentasListado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/jquery-3.7.0.min.js"></script>
    <script src="Scripts/bootstrap.bundle.min.js"></script>

    <script type="text/javascript">
        var delayTimer;
        function delayPostback(source) {
            clearTimeout(delayTimer);
            delayTimer = setTimeout(function () {
                __doPostBack(source.name, '');
            }, 500);
        }

        function setFocusAfterUpdate() {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function (sender, args) {
                if (args.get_error() == null) {
                    var focusedControl = $get('<%= txtBuscar.ClientID %>');
                    if (focusedControl) {
                        focusedControl.focus();
                        var temp = focusedControl.value;
                        focusedControl.value = '';
                        focusedControl.value = temp;
                    }
                }
            });
        }
        window.onload = setFocusAfterUpdate;
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-7xl mx-auto">

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Gestión de Ventas</h1>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Historial de pedidos realizados.</p>
            </div>
            <div class="flex items-center gap-4">
                <asp:HyperLink ID="btnNuevaVenta" runat="server" NavigateUrl="~/VentasForms.aspx"
                    CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90 gap-2">
                    <span class="material-symbols-outlined text-base">add_shopping_cart</span>
                    <span class="truncate">Nueva Venta</span>
                </asp:HyperLink>
            </div>
        </div>

        <asp:UpdatePanel ID="updVentas" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                
                <asp:HiddenField ID="IdVenta" runat="server" />
                <asp:Button ID="btnEliminarServer" runat="server" OnClick="btnEliminarServer_Click" style="display:none;" ClientIDMode="Static" />

                <div class="flex justify-between items-center gap-4 mb-4">
                    <div class="relative w-full sm:max-w-xs">
                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                            <span class="material-symbols-outlined text-slate-400">search</span>
                        </div>
                        <asp:TextBox ID="txtBuscar" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-10 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-10 pr-4 text-sm font-normal leading-normal" 
                            placeholder="Buscar por ID o Cliente..."
                            onkeyup="delayPostback(this);"
                            OnTextChanged="txtBuscar_TextChanged" />
                    </div>
                </div>
                
                <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60 overflow-hidden">
                    <div class="overflow-x-auto">
                        
                        <asp:GridView ID="gvPedidos" runat="server" 
                            AutoGenerateColumns="False" 
                            DataKeyNames="IDPedido"
                            CssClass="w-full text-sm text-left text-slate-500 dark:text-slate-400"
                            GridLines="None" 
                            AllowPaging="True" PageSize="10" 
                            OnPageIndexChanging="gvPedidos_PageIndexChanging">
                            
                            <HeaderStyle CssClass="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-700/50" />
                            <RowStyle CssClass="bg-white dark:bg-slate-800 border-b dark:border-slate-700/60 hover:bg-slate-50 dark:hover:bg-slate-700/40" />
                            <PagerStyle CssClass="flex items-center justify-between p-4" />

                            <Columns>
                                <asp:BoundField DataField="IDPedido" HeaderText="#" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-bold" />
                                <asp:BoundField DataField="NombreCliente" HeaderText="Cliente" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:C}" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-bold text-green-600" />
                                
                                <asp:TemplateField HeaderText="Estado" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4">
                                    <ItemTemplate>
                                        <span class='<%# GetEstadoClass(Eval("Estado").ToString()) %>'>
                                            <%# Eval("Estado") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center">
                                    <ItemTemplate>
                                        <div class="flex justify-center gap-2">
                                            
                                            <asp:HyperLink ID="btnVer" runat="server" 
                                                NavigateUrl='<%# "~/VentasForms.aspx?id=" + Eval("IDPedido") %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-primary/10 hover:text-primary dark:hover:bg-primary/20">
                                                <span class="material-symbols-outlined text-lg">visibility</span>
                                            </asp:HyperLink>
                                            
                                            <a href="javascript:void(0);" 
                                               onclick="abrirModalEliminar(<%# Eval("IDPedido") %>);"
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
                <asp:AsyncPostBackTrigger ControlID="gvPedidos" EventName="PageIndexChanging" />
            </Triggers>
        </asp:UpdatePanel>

        <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true" style="display: none;">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold">Confirmar Cancelación</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center py-4">
                        <p class="mb-1 fs-5 text-dark">¿Estás seguro de que deseas cancelar esta venta?</p>
                        <small class="text-muted">El estado pasará a 'Cancelado'.</small>
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Volver</button>
                        <button type="button" class="btn btn-primary fw-bold" onclick="confirmarEliminar()">Sí, Cancelar</button>
                    </div>
                </div>  
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function abrirModalEliminar(id) {
            var hf = document.getElementById('<%= IdVenta.ClientID %>');
            if (hf) hf.value = id;

            var el = document.getElementById('deleteModal');

            if (window.bootstrap && window.bootstrap.Modal) {
                var myModal = bootstrap.Modal.getOrCreateInstance(el);
                myModal.show();
            } else if (window.jQuery) {
                $('#deleteModal').modal('show');
            } else {
                if (confirm("¿Cancelar venta?")) {
                    document.getElementById('btnEliminarServer').click();
                }
            }
        }

        function confirmarEliminar() {
            try {
                var el = document.getElementById('deleteModal');
                if (window.bootstrap) {
                    var myModal = bootstrap.Modal.getInstance(el);
                    if (myModal) myModal.hide();
                } else if (window.jQuery) {
                    $('#deleteModal').modal('hide');
                }
            } catch (e) { }
            document.getElementById('btnEliminarServer').click();
        }
    </script>
</asp:Content>