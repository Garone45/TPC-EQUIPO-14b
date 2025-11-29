<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VentasForms.aspx.cs" Inherits="Presentacion.VentasForms" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script type="text/javascript">
        // ... (Tu código JavaScript se mantiene igual, no afecta el diseño) ...
        var delayTimer;
        var postBackElementId = "";
        function delayPostback(source) {
            clearTimeout(delayTimer);
            delayTimer = setTimeout(function () {
                __doPostBack(source.name, '');
            }, 500);
        }
        function onBeginRequest(sender, args) {
            postBackElementId = args.get_postBackElement().id;
        }
        function onEndRequestFocusCliente(sender, args) {
            var searchBoxClientID = '<%= txtBuscarCliente.ClientID %>';
            if (args.get_error() == null && postBackElementId === searchBoxClientID) {
                var focusedControl = $get(searchBoxClientID);
                if (focusedControl) {
                    focusedControl.focus();
                    var temp = focusedControl.value;
                    focusedControl.value = '';
                    focusedControl.value = temp;
                }
            }
        }
        function onEndRequestFocusProduct(sender, args) {
            var searchProductClientID = '<%= txtBuscarProductos.ClientID %>';
            if (args.get_error() == null && postBackElementId === searchProductClientID) {
                var focusedControl = $get(searchProductClientID);
                if (focusedControl) {
                    focusedControl.focus();
                    var temp = focusedControl.value;
                    focusedControl.value = '';
                    focusedControl.value = temp;
                }
            }
            postBackElementId = "";
        }
        function setFocusAfterUpdate() {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.remove_beginRequest(onBeginRequest);
            prm.remove_endRequest(onEndRequestFocusCliente);
            prm.remove_endRequest(onEndRequestFocusProduct);
            prm.add_beginRequest(onBeginRequest);
            prm.add_endRequest(onEndRequestFocusCliente);
            prm.add_endRequest(onEndRequestFocusProduct);
        }
        function pageLoad(sender, args) {
            setFocusAfterUpdate();
            var searchBoxClientID = '<%= txtBuscarCliente.ClientID %>';
            var $searchBox = $('#' + searchBoxClientID);
            $searchBox.off('keyup').on('keyup', function (e) {
                if (e.key === 'Enter' || e.keyCode === 13) {
                    return;
                }
                delayPostback(this);
            });
            var searchProductClientID = '<%= txtBuscarProductos.ClientID %>';
            var $searchProduct = $('#' + searchProductClientID);
            $searchProduct.off('keyup').on('keyup', function (e) {
                if (e.key === 'Enter' || e.keyCode === 13) {
                    __doPostBack(this.name, '');
                    return;
                }
                delayPostback(this);
            });
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <div class="relative flex w-full flex-col group/design-root">

        <main class="flex flex-col p-6 gap-6">
            <asp:UpdatePanel ID="updMensajes" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="mb-4">
                        <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" class="p-4 rounded-lg block border"></asp:Label>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

            <asp:UpdatePanel ID="upCliente" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="bg-white dark:bg-slate-900/50 rounded-xl shadow-sm p-6 flex-shrink-0">
                        <div class="grid grid-cols-1 md:grid-cols-12 gap-6">
                            <div class="md:col-span-4">
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2" for="txtSearchClient">Buscar Cliente</label>
                                <div class="relative">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="material-symbols-outlined text-slate-400">search</span>
                                    </div>
                                    <asp:TextBox ID="txtBuscarCliente" runat="server"
                                        CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 placeholder:text-slate-500 dark:placeholder:text-slate-400 px-4 pl-10 text-base"
                                        placeholder="Buscar por nombre..."
                                        AutoPostBack="true"
                                        OnTextChanged="txtBuscarCliente_TextChanged"
                                        CausesValidation="false"></asp:TextBox>
                                </div>


                                <div class="mt-4 h-72 overflow-y-auto custom-scrollbar space-y-2">

                                    <asp:Repeater ID="rptClientes" runat="server" OnItemCommand="rptClientes_ItemCommand">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnSeleccionarCliente" runat="server"
                                                CommandName="Seleccionar"
                                                CommandArgument='<%# Eval("IDCliente") %>'
                                                CausesValidation="false"
                                                CssClass="block w-full text-left group">
                
                                                <div class="p-3 rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 hover:border-primary/50 hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-all duration-200">
                                                    <div class="flex justify-between items-center">
                                                        <div>
                                                            <p class="text-sm font-semibold text-slate-800 dark:text-slate-200 group-hover:text-primary">
                                                                <%# Eval("Nombre") %> <%# Eval("Apellido") %>
                                                            </p>
                                                            <p class="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                                                                <span class="material-symbols-outlined text-[14px] align-text-bottom mr-1">badge</span><%# Eval("Dni") %> 
                                                                <span class="mx-2">•</span> 
                                                                <span class="material-symbols-outlined text-[14px] align-text-bottom mr-1">location_on</span><%# Eval("Localidad") %>
                                                            </p>
                                                        </div>
                        
                                                        <div class="opacity-0 group-hover:opacity-100 transition-opacity text-primary">
                                                            <span class="material-symbols-outlined">arrow_forward</span>
                                                        </div>
                                                    </div>
                                                </div>

                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>

                                    <asp:Panel ID="pnlSinResultados" runat="server" Visible="false" CssClass="text-center p-4 text-slate-500 text-sm">
                                        No se encontraron clientes con ese criterio.
   
                                    </asp:Panel>

                                </div>


                            </div>



                            <div class="md:col-span-8 grid grid-cols-1 gap-6">

                                <div class="bg-white dark:bg-slate-800 p-4 rounded-lg shadow-md border border-slate-200 dark:border-slate-700">

                                    <div class="flex justify-between items-start gap-4">

                                        <div class="flex-1 min-w-0">
                                            <div class="flex flex-col">
                                                <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Cliente Seleccionado</label>
                                                <div class="flex items-center">
                                                    <span class="material-symbols-outlined text-2xl text-primary mr-2">person_pin</span>
                                                    <asp:TextBox ID="txtClientName" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white text-lg font-bold" ReadOnly="true"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="flex-shrink-0 text-right">
                                            <div class="flex flex-col">
                                                <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">DNI</label>
                                                <asp:TextBox ID="txtClientDNI" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white text-lg font-bold whitespace-nowrap" ReadOnly="true"></asp:TextBox>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-slate-800/50 p-4 rounded-lg border border-slate-200 dark:border-slate-700/50">
                                    <h4 class="text-sm font-semibold text-slate-700 dark:text-slate-300 mb-3 flex items-center">
                                        <span class="material-symbols-outlined text-base mr-1">call</span>
                                        Información de Contacto
                                    </h4>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">

                                        <div>
                                            <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Teléfono</label>
                                            <div class="flex items-center">
                                                <asp:TextBox ID="txtClientPhone" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                            </div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Email</label>
                                            <div class="flex items-center">
                                                <asp:TextBox ID="txtClientEmail" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-slate-800/50 p-4 rounded-lg border border-slate-200 dark:border-slate-700/50">
                                    <h4 class="text-sm font-semibold text-slate-700 dark:text-slate-300 mb-3 flex items-center">
                                        <span class="material-symbols-outlined text-base mr-1">home</span>
                                        Ubicación de Entrega
                                    </h4>
                                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">

                                        <div class="sm:col-span-2">
                                            <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Dirección (Calle y Altura)</label>
                                            <asp:TextBox ID="txtClientAddress" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Localidad</label>
                                            <asp:TextBox ID="txtClientCity" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                        </div>

                                    </div>
                                </div>

                            </div>



                        </div>



                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

            <div class="bg-white dark:bg-slate-900/50 rounded-xl shadow-sm flex flex-col">


                <div class="p-6 border-b border-slate-200 dark:border-slate-800">
                    <asp:UpdatePanel ID="upProductos" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="flex flex-col gap-4">

                                <div>
                                    <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Buscar Producto</label>
                                    <div class="relative">
                                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                            <span class="material-symbols-outlined text-slate-400">search</span>
                                        </div>
                                        <asp:TextBox ID="txtBuscarProductos" runat="server"
                                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 placeholder:text-slate-500 dark:placeholder:text-slate-400 px-4 pl-10 text-base"
                                            placeholder="Escanear o buscar por nombre/código..."
                                            AutoPostBack="true"
                                            OnTextChanged="txtBuscarProductos_TextChanged"
                                            CausesValidation="false"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="h-60 overflow-y-auto custom-scrollbar border border-slate-100 dark:border-slate-700/50 rounded-lg p-1 bg-slate-50/50 dark:bg-slate-800/20">

                                    <asp:Repeater ID="rptProductos" runat="server" OnItemCommand="rptProductos_ItemCommand">
                                        <ItemTemplate>
                                            <div class="group flex items-center justify-between p-3 mb-1 rounded-lg border border-transparent bg-white dark:bg-slate-800 hover:border-primary/30 hover:shadow-sm transition-all duration-200">

                                                <div class="flex-1 min-w-0 pr-4">
                                                    <div class="flex items-center gap-2">
                                                        <p class="font-bold text-slate-800 dark:text-slate-200 truncate"><%# Eval("Descripcion") %></p>
                                                        <span class="inline-flex items-center rounded-md bg-slate-100 dark:bg-slate-700 px-2 py-0.5 text-xs font-medium text-slate-600 dark:text-slate-400 ring-1 ring-inset ring-slate-500/10">
                                                            <%# Eval("IDArticulo") %>
                                    </span>
                                                    </div>
                                                    <div class="flex items-center mt-1 text-xs text-slate-500">
                                                        <span>Stock: </span>
                                                        <span class="font-medium ml-1 <%# (int)Eval("StockActual") > 0 ? "text-green-600" : "text-red-500" %>">
                                                            <%# Eval("StockActual") %> u.
                                    </span>
                                                    </div>
                                                </div>

                                                <div class="flex items-center gap-3 shrink-0">
                                                    <p class="text-lg font-bold text-slate-900 dark:text-white">
                                                        <%# Eval("PrecioVentaCalculado", "{0:C}") %>
                                                    </p>

                                                    <asp:LinkButton ID="btnAgregarDirecto" runat="server"
                                                        CommandName="AgregarCarrito"
                                                        CommandArgument='<%# Eval("IDArticulo") %>'
                                                        CausesValidation="false"
                                                        CssClass="flex items-center justify-center w-8 h-8 rounded-full bg-primary/10 text-primary hover:bg-primary hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-xl">add</span>
                                </asp:LinkButton>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>

                                    <asp:Panel ID="pnlSinProductos" runat="server" Visible="true" CssClass="h-full flex flex-col items-center justify-center text-slate-400 text-sm">
                                        <span class="material-symbols-outlined text-3xl mb-2 opacity-50">search_off</span>
                                        <p>Busca un producto para añadir...</p>
                                    </asp:Panel>
                                </div>

                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="txtBuscarProductos" EventName="TextChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>

                <div class="bg-white dark:bg-slate-900/50 rounded-xl shadow-lg border border-slate-200 dark:border-slate-800 flex flex-col h-full overflow-hidden">

                    <asp:UpdatePanel ID="upDetalleVenta" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>

                            <div class="px-6 py-4 border-b border-slate-100 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-800/30 flex justify-between items-center">
                                <h3 class="font-bold text-slate-800 dark:text-white flex items-center gap-2 text-lg">
                                    <span class="material-symbols-outlined text-primary">receipt_long</span>
                                    Detalle de Venta
                                </h3>
                                <span class="text-xs font-medium px-2.5 py-0.5 rounded-full bg-primary/10 text-primary">En curso
                                </span>
                            </div>

                            <div class="flex-1 overflow-y-auto custom-scrollbar min-h-[300px] relative">

                                <asp:GridView ID="gvDetallePedido" runat="server" 
                                    AutoGenerateColumns="false"
                                    DataKeyNames="IDArticulo"
                                    CssClass="w-full text-left border-collapse"
                                    GridLines="None"
                                    ShowHeader="true"
                                    OnRowCommand="gvDetallePedido_RowCommand"
                                    OnRowDataBound="gvDetallePedido_RowDataBound">

                                    <HeaderStyle CssClass="text-xs font-bold uppercase text-slate-500 dark:text-slate-400 bg-white dark:bg-slate-900 sticky top-0 z-10 border-b border-slate-100 dark:border-slate-800" Height="40px" />
                                    <RowStyle CssClass="border-b border-slate-50 dark:border-slate-800/50 hover:bg-slate-50/50 dark:hover:bg-slate-800/30 transition-colors" />

                                    <Columns>
                                        <asp:TemplateField HeaderText="Producto">
                                            <HeaderStyle CssClass="pl-6 py-3 text-left" />
                                            <ItemStyle CssClass="pl-6 py-4" />
                                            <ItemTemplate>
                                                <div class="flex flex-col">
                                                    <span class="font-bold text-slate-800 dark:text-slate-200 text-sm">
                                                        <%# Eval("Descripcion") %>
                                                    </span>
                                                    <span class="text-xs text-slate-400 font-mono mt-0.5">SKU: <%# Eval("IDArticulo") %>
                                                    </span>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Cant.">
                                            <HeaderStyle CssClass="text-center py-3" />
                                            <ItemStyle CssClass="py-4" />
                                            <ItemTemplate>
                                                <div class="flex items-center justify-center">
                                                    <div class="flex items-center bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg h-8 shadow-sm">
                                                        <asp:LinkButton ID="btnDecreaseQty" runat="server" CommandName="Restar" CommandArgument='<%# Eval("IDArticulo") %>'
                                                            CssClass="w-8 h-full flex items-center justify-center text-slate-500 hover:text-primary hover:bg-slate-50 dark:hover:bg-slate-700 rounded-l-lg transition-colors"
                                                            CausesValidation="false">
                                            <span class="text-lg leading-none">-</span>
                                                        </asp:LinkButton>

                                                        <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Cantidad") %>'
                                                            CssClass="w-10 text-center bg-transparent border-x border-slate-100 dark:border-slate-700 text-sm font-semibold text-slate-700 dark:text-slate-300 focus:outline-none"
                                                            ReadOnly="true" />

                                                        <asp:LinkButton ID="btnIncreaseQty" runat="server" CommandName="Sumar" CommandArgument='<%# Eval("IDArticulo") %>'
                                                            CssClass="w-8 h-full flex items-center justify-center text-slate-500 hover:text-primary hover:bg-slate-50 dark:hover:bg-slate-700 rounded-r-lg transition-colors"
                                                            CausesValidation="false">
                                            <span class="text-lg leading-none">+</span>
                                                        </asp:LinkButton>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="PrecioUnitario" HeaderText="Unitario" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="text-right py-3 hidden sm:table-cell" />
                                            <ItemStyle CssClass="text-right py-4 text-sm text-slate-500 hidden sm:table-cell" />
                                        </asp:BoundField>

                                        <asp:BoundField DataField="TotalParcial" HeaderText="Total" DataFormatString="{0:C}">
                                            <HeaderStyle CssClass="text-right py-3 pr-2" />
                                            <ItemStyle CssClass="text-right py-4 pr-2 font-bold text-slate-800 dark:text-slate-200" />
                                        </asp:BoundField>

                                        <asp:TemplateField>
                                            <HeaderStyle CssClass="w-10 pr-6" />
                                            <ItemStyle CssClass="pr-6 text-right" />
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("IDArticulo") %>'
                                                    CssClass="group flex items-center justify-center size-8 rounded-full hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors"
                                                    CausesValidation="false" ToolTip="Quitar del carrito">
                                    <span class="material-symbols-outlined text-slate-400 group-hover:text-red-500 text-lg">delete</span>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>

                                    <EmptyDataTemplate>
                                        <div class="flex flex-col items-center justify-center h-64 text-slate-400">
                                            <div class="bg-slate-50 dark:bg-slate-800 p-4 rounded-full mb-3">
                                                <span class="material-symbols-outlined text-4xl opacity-50">shopping_cart</span>
                                            </div>
                                            <p class="font-medium text-slate-500 dark:text-slate-400">El carrito está vacío</p>
                                            <p class="text-xs mt-1 opacity-70">Añade productos desde el buscador</p>
                                        </div>
                                    </EmptyDataTemplate>

                                </asp:GridView>
                            </div>

                            <div class="p-6 bg-white dark:bg-slate-900 border-t border-slate-100 dark:border-slate-800 mt-auto shadow-[0_-5px_15px_rgba(0,0,0,0.02)] z-20">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-center">

                                    <div class="order-2 md:order-1">
                                        <asp:LinkButton ID="btnFinalizarVenta" runat="server"
                                            CssClass="w-full md:w-auto flex items-center justify-center gap-2 bg-primary hover:bg-primary/90 text-white shadow-lg shadow-primary/30 h-12 px-8 rounded-xl font-bold text-base transition-all transform active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed"
                                            OnClick="btnFinalizarVenta_Click"
                                            CausesValidation="false"
                                            OnClientClick="this.disabled = true; this.innerHTML = '<span class=\'material-symbols-outlined animate-spin mr-2\'>sync</span>Procesando...';">
                            <span class="material-symbols-outlined">check_circle</span>
                            <span>Confirmar Venta</span>
                                        </asp:LinkButton>
                                    </div>

                                    <div class="order-1 md:order-2">
                                        <div class="space-y-2">
                                            <div class="flex justify-between text-sm text-slate-500">
                                                <span>Subtotal</span>
                                                <asp:Label ID="lblSubtotal" runat="server" CssClass="font-medium text-slate-700 dark:text-slate-300" Text="$0.00"></asp:Label>
                                            </div>
                                            <div class="flex justify-between text-sm text-slate-500">
                                                <span>IVA (21%)</span>
                                                <asp:Label ID="lblIVA" runat="server" CssClass="font-medium text-slate-700 dark:text-slate-300" Text="$0.00"></asp:Label>
                                            </div>
                                            <div class="flex justify-between items-center pt-3 border-t border-slate-100 dark:border-slate-800">
                                                <span class="text-base font-bold text-slate-800 dark:text-white">Total a Pagar</span>
                                                <asp:Label ID="lblTotalFinal" runat="server" CssClass="text-2xl font-black text-primary" Text="$0.00"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvDetallePedido" EventName="RowCommand" />
                            <asp:PostBackTrigger ControlID="btnFinalizarVenta" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </main>
    </div>
</asp:Content>
