<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VentasForms.aspx.cs" Inherits="Presentacion.VentasForms" %>

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
                                <div class="mt-4 max-h-40 overflow-y-auto">
                                    <asp:GridView ID="gvClientes" runat="server" AutoGenerateColumns="false" DataKeyNames="IDCliente" OnSelectedIndexChanged="gvClientes_SelectedIndexChanged" CssClass="w-full text-sm text-left text-slate-700 dark:text-slate-300" HeaderStyle-CssClass="text-xs text-slate-500 uppercase bg-slate-100 dark:bg-slate-800 p-3" RowStyle-CssClass="bg-white dark:bg-slate-900/50 border-b border-slate-200 dark:border-slate-800" SelectedRowStyle-CssClass="bg-primary/20" EmptyDataText="No se encontraron clientes.">
                                        <Columns>
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnSeleccionar" runat="server" CommandName="Select" CssClass="bg-primary/20 text-primary text-xs font-semibold px-2 py-1 rounded-md" CausesValidation="false">Seleccionar</asp:LinkButton>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="100px" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                                            <asp:BoundField DataField="DNI" HeaderText="DNI" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="md:col-span-8 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 bg-slate-50 dark:bg-slate-800/50 p-4 rounded-lg">
                                <div class="md:col-span-1">
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Nombre y Apellido</label>
                                    <asp:TextBox ID="txtClientName" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Dirección</label>
                                    <asp:TextBox ID="txtClientAddress" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Localidad</label>
                                    <asp:TextBox ID="txtClientCity" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">DNI</label>
                                    <asp:TextBox ID="txtClientDNI" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Teléfono</label>
                                    <asp:TextBox ID="txtClientPhone" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
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
                            <div class="flex items-end gap-4">
                                <div class="flex-1">
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
                                    <div class="mt-4 max-h-40 overflow-y-auto">
                                        <asp:GridView ID="gvProductos" runat="server" AutoGenerateColumns="false" DataKeyNames="IDArticulo" OnSelectedIndexChanged="gvProductos_SelectedIndexChanged" CssClass="w-full text-sm text-left text-slate-700 dark:text-slate-300" HeaderStyle-CssClass="text-xs text-slate-500 uppercase bg-slate-100 dark:bg-slate-800 p-3 sticky top-0" RowStyle-CssClass="bg-white dark:bg-slate-900/50 border-b border-slate-200 dark:border-slate-800 cursor-pointer" SelectedRowStyle-CssClass="bg-primary/20" EmptyDataText="No se encontraron productos." ShowHeader="true">
                                            <Columns>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnSeleccionarProducto" runat="server" CommandName="Select" CssClass="bg-primary/20 text-primary text-xs font-semibold px-2 py-1 rounded-md" CausesValidation="false">Seleccionar</asp:LinkButton>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" Width="100px" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="IDArticulo" HeaderText="SKU" />
                                                <asp:BoundField DataField="Descripcion" HeaderText="Producto" />
                                                <asp:BoundField DataField="PrecioVentaCalculado" HeaderText="Precio" DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" />
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                                <asp:LinkButton ID="btnAddProduct" runat="server" CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-11 px-5 bg-primary/20 text-primary gap-2 text-base font-bold" OnClick="btnAddProduct_Click">
                                    <span class="material-symbols-outlined">add_shopping_cart</span>
                                    <span class="truncate">Añadir Producto</span>
                                </asp:LinkButton>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="txtBuscarProductos" EventName="TextChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>

                <asp:UpdatePanel ID="upDetalleVenta" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="px-6">
                            <asp:GridView ID="gvDetallePedido" runat="server" AutoGenerateColumns="false" DataKeyNames="IDArticulo" CssClass="w-full text-left" HeaderStyle-CssClass="text-xs font-semibold uppercase text-slate-500 dark:text-slate-400 grid grid-cols-12 gap-4 py-4 border-b border-slate-200 dark:border-slate-800 sticky top-0 bg-white dark:bg-slate-900/50" RowStyle-CssClass="grid grid-cols-12 gap-4 items-center py-4 divide-y divide-slate-200 dark:divide-slate-800" GridLines="None" ShowHeader="true" OnRowCommand="gvDetallePedido_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="Producto">
                                        <ItemTemplate>
                                            <div class="col-span-5 flex items-center gap-3">
                                                <div>
                                                    <p class="font-bold text-slate-900 dark:text-white"><%# Eval("Descripcion") %></p>
                                                    <p class="text-sm text-slate-500 dark:text-slate-400">SKU: <%# Eval("IDArticulo") %></p>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="col-span-5" />
                                        <HeaderStyle CssClass="col-span-5" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Cantidad">
                                        <ItemTemplate>
                                            <div class="col-span-3 flex items-center justify-center gap-2">
                                                <asp:LinkButton ID="btnDecreaseQty" runat="server" CommandName="Restar" CommandArgument='<%# Eval("IDArticulo") %>' CssClass="flex items-center justify-center size-8 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300" Text="-" CausesValidation="false" />
                                                <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Cantidad") %>' CssClass="w-12 text-center bg-transparent border border-slate-300 dark:border-slate-700 rounded-lg h-8 p-1" ReadOnly="true" />
                                                <asp:LinkButton ID="btnIncreaseQty" runat="server" CommandName="Sumar" CommandArgument='<%# Eval("IDArticulo") %>' CssClass="flex items-center justify-center size-8 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300" Text="+" CausesValidation="false" />
                                            </div>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="col-span-3 text-center" />
                                        <HeaderStyle CssClass="col-span-3 text-center" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio Unitario" DataFormatString="{0:C}">
                                        <ItemStyle CssClass="col-span-2 text-right font-medium text-slate-600 dark:text-slate-300" />
                                        <HeaderStyle CssClass="col-span-2 text-right" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="TotalParcial" HeaderText="Parcial" DataFormatString="{0:C}">
                                        <ItemStyle CssClass="col-span-2 text-right font-bold text-slate-900 dark:text-white" />
                                        <HeaderStyle CssClass="col-span-2 text-right" />
                                    </asp:BoundField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("IDArticulo") %>' CssClass="text-red-500 hover:text-red-700" CausesValidation="false">
                                                <span class="material-symbols-outlined text-base">close</span>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Width="20px" />
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle CssClass="!bg-white dark:!bg-slate-900/50" />
                                <RowStyle CssClass="!bg-transparent" />
                            </asp:GridView>
                        </div>

                        <div class="p-6 bg-background-light dark:bg-background-dark border-t border-slate-200 dark:border-slate-800 mt-auto">
                            <div class="grid grid-cols-12 gap-x-6 items-end">
                                <div class="col-span-7">
                                    <asp:LinkButton ID="btnFinalizarVenta" runat="server"
                                        CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-11 px-5 bg-primary text-white gap-2 text-base font-bold tracking-wide"
                                        OnClick="btnFinalizarVenta_Click"
                                        CausesValidation="false"
                                        OnClientClick="this.disabled = true; this.innerHTML = 'Procesando...';">>

                                        <span class="material-symbols-outlined" style="font-size: 20px;">shopping_cart_checkout</span>
                                        <span class="truncate">Finalizar Venta</span>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-span-5">
                                    <div class="flex flex-col gap-1 text-sm">
                                        <div class="flex justify-between items-center text-slate-600 dark:text-slate-300">
                                            <span>Subtotal</span>
                                            <asp:Label ID="lblSubtotal" runat="server" CssClass="font-medium" Text="$$$.$$"></asp:Label>
                                        </div>
                                        <div class="flex justify-between items-center text-slate-600 dark:text-slate-300">
                                            <span>IVA (16%)</span>
                                            <asp:Label ID="lblIVA" runat="server" CssClass="font-medium" Text="$$$.$$"></asp:Label>
                                        </div>
                                        <div class="flex justify-between items-center text-slate-900 dark:text-white text-base font-bold pt-2 border-t border-slate-300 dark:border-slate-700 mt-1">
                                            <span>Total Final</span>
                                            <asp:Label ID="lblTotalFinal" runat="server" Text="$$$.$$"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAddProduct" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="gvProductos" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="gvDetallePedido" EventName="RowCommand" />

                        <asp:PostBackTrigger ControlID="btnFinalizarVenta" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </main>
    </div>
</asp:Content>
