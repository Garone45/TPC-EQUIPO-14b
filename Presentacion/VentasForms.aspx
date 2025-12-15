<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VentasForms.aspx.cs" Inherits="Presentacion.VentasForms" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script type="text/javascript">
        var delayTimer;
        var postBackElementId = "";

        // Función de retraso para escribir (debounce)
        function delayPostback(source) {
            clearTimeout(delayTimer);
            delayTimer = setTimeout(function () {
                __doPostBack(source.name, '');
            }, 500); // Espera 500ms después de dejar de escribir
        }

        // Captura quién inicia el request
        function onBeginRequest(sender, args) {
            postBackElementId = args.get_postBackElement().id;
        }

        // Restaura el foco después del UpdatePanel (Específico para Productos)
        function onEndRequestFocusProduct(sender, args) {
            var searchProductClientID = '<%= txtBuscarProductos.ClientID %>';

            // Verificamos si el postback vino del buscador O si fue un comando de agregar (para devolver el foco)
            // A veces el postback element cambia al botón del repeater, pero queremos el foco en el txt igual.

            if (args.get_error() == null) {
                var focusedControl = $get(searchProductClientID);
                if (focusedControl) {
                    // Truco para poner el cursor al final del texto si quedó algo escrito
                    var temp = focusedControl.value;
                    focusedControl.value = '';
                    focusedControl.value = temp;
                    focusedControl.focus();
                }
            }
        }

        // Configurar manejadores de Sys.WebForms
        function setFocusAfterUpdate() {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (!prm.get_isInAsyncPostBack()) {
                prm.add_beginRequest(onBeginRequest);
                prm.add_endRequest(onEndRequestFocusProduct);
            }
        }

        // Inicialización jQuery y eventos DOM
        function inicializarEventosBuscador() {
            var searchProductClientID = '<%= txtBuscarProductos.ClientID %>';
            var $searchProduct = $('#' + searchProductClientID);

            // Remover eventos previos para evitar duplicados tras updates parciales
            $searchProduct.off('keydown keyup');

            // Evento KEYDOWN: Para capturar el ENTER antes que nada
            $searchProduct.on('keydown', function (e) {
                var code = e.keyCode || e.which;
                if (code === 13) { // Enter
                    e.preventDefault(); // Evita el submit del form completo
                    clearTimeout(delayTimer); // Cancela el timer de espera
                    __doPostBack(this.name, ''); // Fuerza la búsqueda inmediata
                    return false;
                }
            });

            // Evento KEYUP: Para la escritura normal
            $searchProduct.on('keyup', function (e) {
                var code = e.keyCode || e.which;
                // Ignorar teclas de navegación, control y Enter (ya manejado en keydown)
                if ([9, 13, 16, 17, 18, 27, 37, 38, 39, 40].indexOf(code) > -1) {
                    return;
                }
                delayPostback(this);
            });

            // Clic fuera para cerrar
            $(document).off('click.cerrarBusqueda').on('click.cerrarBusqueda', function (e) {
                var contenedor = $('#contenedorBusquedaProductos');
                var panelResultados = $('#pnlResultadosProductos');

                // Si el clic NO fue en el contenedor ni en sus hijos
                if (contenedor.length > 0 && !contenedor.is(e.target) && contenedor.has(e.target).length === 0) {
                    // Solo ocultamos visualmente, no necesitamos ir al servidor
                    panelResultados.hide();
                }
                var contenedorCli = $('#contenedorBusquedaClientes');
                var panelCli = $('#pnlResultadosClientes'); // Este ID lo crearemos en el ASPX
                if (contenedorCli.length > 0 && !contenedorCli.is(e.target) && contenedorCli.has(e.target).length === 0) {
                    panelCli.hide();
                }
            });

            // Reactivar visualización si se vuelve a hacer clic en el input
            $searchProduct.on('focus click', function () {
                if ($(this).val().length >= 2) {
                    $('#pnlResultadosProductos').show();
                }
            });
        }

        // Ejecutar al carga de página y después de cada UpdatePanel
        $(document).ready(function () {
            setFocusAfterUpdate();
            inicializarEventosBuscador();

            // Re-inicializar eventos después de cada Partial Postback
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                inicializarEventosBuscador();
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


        <main class="flex flex-col p-6 gap-6 h-full">
            
            <asp:UpdatePanel ID="updMensajes" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="mb-0">
                        <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" class="p-4 rounded-lg block border mb-4 shadow-sm"></asp:Label>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

            <div class="grid grid-cols-1 md:grid-cols-12 gap-6 h-full items-start">

            <div id="columnaBusqueda" runat="server" class="md:col-span-4 flex flex-col gap-4 h-full">

                <asp:UpdatePanel ID="upCliente" runat="server" UpdateMode="Conditional" class="contents">
                    <ContentTemplate>

                        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-lg border border-slate-200 dark:border-slate-800 p-5 relative z-20">

                            <label class="block text-xs font-bold uppercase tracking-wider text-slate-500 mb-3 flex items-center gap-2">
                                <span class="material-symbols-outlined text-lg">person_search</span>
                                Cliente
               
                            </label>

                            <div class="relative" id="contenedorBusquedaClientes">

                                <div class="relative group">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="material-symbols-outlined text-slate-400 group-focus-within:text-primary transition-colors">search</span>
                                    </div>
                                    <asp:TextBox ID="txtBuscarCliente" runat="server"
                                        CssClass="form-input flex w-full rounded-lg border-slate-200 bg-slate-50 dark:bg-slate-800 dark:border-slate-700 pl-10 text-sm focus:border-primary focus:ring-primary h-10 transition-all placeholder:text-slate-400"
                                        placeholder="Buscar por nombre o DNI..."
                                        OnTextChanged="txtBuscarCliente_TextChanged"
                                        CausesValidation="false" autocomplete="on">
                        </asp:TextBox>
                                </div>

                                <div id="pnlResultadosClientes" runat="server" clientidmode="Static" visible="false"
                                    class="absolute left-0 right-0 z-50 mt-2 origin-top rounded-xl bg-white dark:bg-slate-800 shadow-xl ring-1 ring-black ring-opacity-5 focus:outline-none overflow-hidden max-h-64 overflow-y-auto custom-scrollbar animate-in fade-in slide-in-from-top-2 duration-100">

                                    <asp:Repeater ID="rptClientes" runat="server" OnItemCommand="rptClientes_ItemCommand">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnSeleccionarCliente" runat="server"
                                                CommandName="Seleccionar"
                                                CommandArgument='<%# Eval("IDCliente") %>'
                                                CausesValidation="false"
                                                CssClass="block w-full text-left px-4 py-3 hover:bg-primary/5 dark:hover:bg-slate-700 border-b border-slate-100 dark:border-slate-700/50 last:border-0 transition-colors group">
                                    
                                    <div class="flex justify-between items-center">
                                        <div>
                                            <p class="text-sm font-bold text-slate-700 dark:text-slate-200 group-hover:text-primary">
                                                <%# Eval("Nombre") + " " + Eval("Apellido") %>
                                            </p>
                                            <div class="flex items-center gap-2 mt-0.5">
                                                <span class="text-[10px] bg-slate-100 dark:bg-slate-700 text-slate-500 px-1.5 rounded">DNI</span>
                                                <p class="text-xs text-slate-500"><%# Eval("Dni") %></p>
                                            </div>
                                        </div>
                                        <span class="material-symbols-outlined text-slate-300 group-hover:text-primary text-lg">check_circle</span>
                                    </div>
                                </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>

                                    <asp:Panel ID="pnlSinResultadosClientes" runat="server" Visible="false" CssClass="text-center p-4 text-slate-400 text-xs">
                                        <span class="block mb-1">🤔</span>
                                        No encontrado.
                       
                                    </asp:Panel>
                                </div>

                            </div>
                        </div>

                        <div class="flex flex-col gap-3 relative z-10">

                            <div class="bg-white dark:bg-slate-900/50 p-4 rounded-xl border border-slate-200 dark:border-slate-800/50 relative overflow-hidden group hover:border-primary/30 transition-colors">
                                <div class="flex justify-between items-start relative z-10">
                                    <div class="w-full">
                                        <p class="text-[10px] uppercase font-bold text-slate-400 mb-1">Cliente Seleccionado</p>

                                        <asp:TextBox ID="txtClientName" runat="server" ReadOnly="true"
                                            CssClass="block w-full text-base font-bold text-slate-800 dark:text-white bg-transparent border-none p-0 focus:ring-0 truncate placeholder:text-slate-300"
                                            placeholder="---"></asp:TextBox>

                                        <asp:TextBox ID="txtClientDNI" runat="server" ReadOnly="true"
                                            CssClass="block w-full text-xs text-slate-500 bg-transparent border-none p-0 focus:ring-0 mt-0.5"
                                            placeholder="DNI: ---"></asp:TextBox>
                                    </div>
                                    <span class="material-symbols-outlined text-slate-200 group-hover:text-primary/20 text-3xl absolute right-2 top-2 transition-colors">id_card</span>
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-3">

                                <div class="bg-white dark:bg-slate-900/50 p-3 rounded-xl border border-slate-200 dark:border-slate-800/50 group hover:border-blue-400/30 transition-colors">
                                    <span class="material-symbols-outlined text-blue-500 mb-2">contact_phone</span>
                                    <p class="text-[10px] uppercase font-bold text-slate-400">Contacto</p>

                                    <asp:TextBox ID="txtClientPhone" runat="server" ReadOnly="true"
                                        CssClass="text-xs font-semibold text-slate-700 dark:text-slate-300 bg-transparent border-none p-0 focus:ring-0 w-full truncate"
                                        placeholder="-"></asp:TextBox>

                                    <asp:TextBox ID="txtClientEmail" runat="server" ReadOnly="true"
                                        CssClass="block mt-1 text-[10px] text-slate-500 dark:text-slate-400 bg-transparent border-none p-0 focus:ring-0 w-full truncate"
                                        placeholder="-"></asp:TextBox>
                                </div>

                                <div class="bg-white dark:bg-slate-900/50 p-3 rounded-xl border border-slate-200 dark:border-slate-800/50 group hover:border-green-400/30 transition-colors">
                                    <span class="material-symbols-outlined text-green-500 mb-2">location_on</span>
                                    <p class="text-[10px] uppercase font-bold text-slate-400">Zona</p>

                                    <asp:TextBox ID="txtClientCity" runat="server" ReadOnly="true"
                                        CssClass="text-xs font-semibold text-slate-700 dark:text-slate-300 bg-transparent border-none p-0 focus:ring-0 w-full truncate"
                                        placeholder="-"></asp:TextBox>

                                    <asp:TextBox ID="txtClientAddress" runat="server" ReadOnly="true"
                                        CssClass="block mt-1 text-[10px] text-slate-500 dark:text-slate-400 bg-transparent border-none p-0 focus:ring-0 w-full truncate"
                                        placeholder="-"></asp:TextBox>
                                </div>
                            </div>

                        </div>

                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>

                <div id="columnaDetalle" runat="server" class="md:col-span-8 h-full flex flex-col">
                    
                    <div class="bg-white dark:bg-slate-900 rounded-xl shadow-xl border border-slate-200 dark:border-slate-800 flex flex-col h-full overflow-hidden relative">

                        <div class="z-30 bg-white dark:bg-slate-900 border-b border-slate-100 dark:border-slate-800 shadow-sm">
                            <div class="px-6 py-4 flex justify-between items-center bg-slate-50/50 dark:bg-slate-800/50">
                                <h3 class="font-bold text-slate-800 dark:text-white flex items-center gap-2 text-xl">
                                    <span class="material-symbols-outlined text-primary">point_of_sale</span>
                                    Nueva Venta
                                </h3>
                                <div class="flex items-center gap-2">
                                    <span class="animate-pulse h-2 w-2 rounded-full bg-green-500"></span>
                                    <span class="text-xs font-bold text-green-600 dark:text-green-400 uppercase tracking-wide">Sistema Activo</span>
                                </div>
                            </div>

                            <div class="p-4 bg-slate-50 dark:bg-slate-800/30 border-t border-slate-100 dark:border-slate-700">
                                <asp:UpdatePanel ID="upProductos" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="relative w-full max-w-3xl mx-auto" id="contenedorBusquedaProductos">
                                            <div class="relative group">
                                                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 transition-colors group-focus-within:text-primary">
                                                    <span class="material-symbols-outlined text-slate-400">qr_code_scanner</span>
                                                </div>
                                                
                                                <asp:TextBox ID="txtBuscarProductos" runat="server"
                                                    CssClass="form-input flex w-full rounded-xl border-0 ring-1 ring-slate-200 dark:ring-slate-700 bg-white dark:bg-slate-800 py-3 pl-12 pr-4 text-base shadow-sm placeholder:text-slate-400 focus:ring-2 focus:ring-primary focus:shadow-md transition-all"
                                                    placeholder="Escanear código o buscar producto (Enter)..."
                                                    OnTextChanged="txtBuscarProductos_TextChanged"
                                                    CausesValidation="false" autocomplete="off"></asp:TextBox>
                                                
                                                <div class="absolute inset-y-0 right-0 flex items-center pr-3">
                                                    <kbd class="hidden sm:inline-block rounded border border-slate-200 bg-slate-100 px-2 py-0.5 text-xs font-sans font-medium text-slate-400">↵ Enter</kbd>
                                                </div>
                                            </div>

                                            <div id="pnlResultadosProductos" runat="server" clientidmode="Static" visible="false"
                                                class="absolute left-0 right-0 z-50 mt-2 origin-top-right rounded-xl bg-white dark:bg-slate-800 shadow-2xl ring-1 ring-black ring-opacity-5 focus:outline-none overflow-hidden animate-in fade-in zoom-in-95 duration-100">
                                                
                                                <div class="max-h-80 overflow-y-auto custom-scrollbar">
                                                    <asp:Repeater ID="rptProductos" runat="server" OnItemCommand="rptProductos_ItemCommand">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnAgregarDirecto" runat="server"
                                                                CommandName="AgregarCarrito" CommandArgument='<%# Eval("IDArticulo") %>' CausesValidation="false"
                                                                CssClass="block w-full text-left px-4 py-3 hover:bg-slate-50 dark:hover:bg-slate-700/50 border-b border-slate-100 last:border-0 transition-colors group">
                                                                
                                                                <div class="flex items-center justify-between">
                                                                    <div class="flex-1 min-w-0 pr-4">
                                                                        <div class="flex items-center gap-2">
                                                                             <span class="inline-flex items-center rounded-md bg-slate-100 dark:bg-slate-700 px-1.5 py-0.5 text-[10px] font-medium text-slate-500 font-mono">
                                                                                <%# Eval("IDArticulo") %>
                                                                            </span>
                                                                            <p class="font-bold text-slate-800 dark:text-slate-200 truncate text-sm"><%# Eval("Descripcion") %></p>
                                                                        </div>
                                                                        <div class="flex items-center mt-1 text-xs text-slate-500">
                                                                            <span>Stock: </span>
                                                                            <span class="font-bold ml-1 <%# (int)Eval("StockActual") > 0 ? "text-green-600" : "text-red-500" %>">
                                                                                <%# Eval("StockActual") %> u.
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="text-right">
                                                                         <span class="block text-lg font-bold text-primary"><%# Eval("PrecioVentaCalculado", "{0:C}") %></span>
                                                                         <span class="text-[10px] text-slate-400 font-medium opacity-0 group-hover:opacity-100 transition-opacity">Agregar +</span>
                                                                    </div>
                                                                </div>
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:Repeater>

                                                    <asp:Panel ID="pnlSinProductos" runat="server" Visible="false" CssClass="flex flex-col items-center justify-center p-6 text-slate-500">
                                                        <span class="material-symbols-outlined text-3xl mb-2 opacity-50">search_off</span>
                                                        <span class="text-sm">No encontramos ese producto.</span>
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="txtBuscarProductos" EventName="TextChanged" />
                                        <asp:AsyncPostBackTrigger ControlID="rptProductos" EventName="ItemCommand" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </div>
                        </div>

                        <div class="flex-1 overflow-y-auto custom-scrollbar bg-white relative">
                            <asp:UpdatePanel ID="upDetalleVenta" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    
                                    <asp:GridView ID="gvDetallePedido" runat="server"
                                        AutoGenerateColumns="false" DataKeyNames="IDArticulo"
                                        CssClass="w-full text-left border-collapse"
                                        GridLines="None" ShowHeader="true"
                                        OnRowCommand="gvDetallePedido_RowCommand" OnRowDataBound="gvDetallePedido_RowDataBound">

                                        <HeaderStyle CssClass="text-xs font-bold uppercase tracking-wider text-slate-500 bg-slate-50/80 backdrop-blur sticky top-0 z-10 border-b border-slate-100" Height="45px" />
                                        <RowStyle CssClass="border-b border-slate-50 hover:bg-slate-50/40 transition-colors group" />

                                        <Columns>
                                            <asp:TemplateField HeaderText="Producto">
                                                <HeaderStyle CssClass="pl-6 py-3 text-left" />
                                                <ItemStyle CssClass="pl-6 py-4" />
                                                <ItemTemplate>
                                                    <div class="flex flex-col">
                                                        <span class="font-bold text-slate-800 text-sm"><%# Eval("Descripcion") %></span>
                                                        <span class="text-xs text-slate-400 font-mono mt-0.5">COD: <%# Eval("IDArticulo") %></span>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Cantidad">
                                                <HeaderStyle CssClass="text-center py-3" />
                                                <ItemTemplate>
                                                    <div class="flex items-center justify-center">
                                                        <div class="flex items-center bg-white border border-slate-200 rounded-lg shadow-sm h-8">
                                                            <asp:LinkButton ID="btnDecreaseQty" runat="server" CommandName="Restar" CommandArgument='<%# Eval("IDArticulo") %>'
                                                                CssClass="w-8 h-full flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-l-lg transition-colors">
                                                                <span class="text-lg leading-none">-</span>
                                                            </asp:LinkButton>

                                                            <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Cantidad") %>'
                                                                CssClass="w-10 text-center border-none p-0 text-sm font-bold text-slate-700 focus:ring-0" ReadOnly="true" />

                                                            <asp:LinkButton ID="btnIncreaseQty" runat="server" CommandName="Sumar" CommandArgument='<%# Eval("IDArticulo") %>'
                                                                CssClass="w-8 h-full flex items-center justify-center text-slate-400 hover:text-green-500 hover:bg-green-50 rounded-r-lg transition-colors">
                                                                <span class="text-lg leading-none">+</span>
                                                            </asp:LinkButton>
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio U." DataFormatString="{0:C}">
                                                <HeaderStyle CssClass="text-right py-3 hidden sm:table-cell" />
                                                <ItemStyle CssClass="text-right py-4 text-sm text-slate-500 hidden sm:table-cell" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="TotalParcial" HeaderText="Subtotal" DataFormatString="{0:C}">
                                                <HeaderStyle CssClass="text-right py-3 pr-6" />
                                                <ItemStyle CssClass="text-right py-4 pr-6 font-bold text-slate-800" />
                                            </asp:BoundField>

                                            <asp:TemplateField>
                                                <HeaderStyle CssClass="w-10" />
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("IDArticulo") %>'
                                                        CssClass="flex items-center justify-center size-8 rounded-full text-slate-300 hover:text-red-500 hover:bg-red-50 transition-colors mx-auto"
                                                        ToolTip="Quitar">
                                                        <span class="material-symbols-outlined text-lg">delete</span>
                                                    </asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>

                                        <EmptyDataTemplate>
                                            <div class="flex flex-col items-center justify-center h-[300px] text-slate-300">
                                                <span class="material-symbols-outlined text-6xl mb-4 text-slate-200">shopping_cart_checkout</span>
                                                <p class="font-medium text-slate-400 text-lg">El carrito está vacío</p>
                                                <p class="text-sm mt-1">Usa el buscador superior para agregar productos.</p>
                                            </div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="gvDetallePedido" EventName="RowCommand" />
                                    <asp:PostBackTrigger ControlID="btnFinalizarVenta" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>

                        <div class="z-20 bg-white border-t border-slate-200 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.05)] p-6">
                            <asp:UpdatePanel ID="upTotales" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 items-center">
                                        
                                        <div class="order-2 lg:order-1">
                                            <asp:LinkButton ID="btnFinalizarVenta" runat="server"
                                                CssClass="group w-full lg:w-auto min-w-[200px] flex items-center justify-center gap-3 bg-slate-900 hover:bg-primary text-white shadow-lg shadow-slate-900/20 hover:shadow-primary/40 h-14 px-8 rounded-xl font-bold text-lg transition-all transform active:scale-95"
                                                OnClick="btnFinalizarVenta_Click" CausesValidation="false">
                                                <span>Confirmar Venta</span>
                                                <span class="material-symbols-outlined group-hover:translate-x-1 transition-transform">arrow_forward</span>
                                            </asp:LinkButton>
                                        </div>

                                        <div class="order-1 lg:order-2">
                                            <div class="flex flex-col gap-2 max-w-sm ml-auto">
                                                <div class="flex justify-between text-sm text-slate-500">
                                                    <span>Subtotal Neto</span>
                                                    <asp:Label ID="lblSubtotal" runat="server" CssClass="font-medium text-slate-700" Text="$0.00"></asp:Label>
                                                </div>
                                                <div class="flex justify-between text-sm text-slate-500">
                                                    <span>Impuestos (IVA 21%)</span>
                                                    <asp:Label ID="lblIVA" runat="server" CssClass="font-medium text-slate-700" Text="$0.00"></asp:Label>
                                                </div>
                                                <div class="my-2 border-t border-dashed border-slate-200"></div>
                                                <div class="flex justify-between items-end">
                                                    <span class="text-base font-bold text-slate-800 pb-1">Total a Pagar</span>
                                                    <asp:Label ID="lblTotalFinal" runat="server" CssClass="text-3xl font-black text-primary tracking-tight" Text="$0.00"></asp:Label>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>

                    </div>
                </div>

            </div>
        </main>
    </div>
</asp:Content>
