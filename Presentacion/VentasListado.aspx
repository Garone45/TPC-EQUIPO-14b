<%@ Page Title="Listado de Ventas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VentasListado.aspx.cs" Inherits="Presentacion.VentasListado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="Scripts/jquery-3.7.0.min.js"></script>
   

    <script type="text/javascript">

        var delayTimer;

        function delayPostback() {
            // Reiniciamos el reloj cada vez que escribes
            clearTimeout(delayTimer);

            delayTimer = setTimeout(function () {
                // Buscamos el botón oculto por su ID estático
                var btn = document.getElementById('btnBuscarTrigger');
                if (btn) {
                    btn.click(); // ¡Clic! Esto dispara el UpdatePanel
                }
            }, 500); // Espera medio segundo después de dejar de escribir
        }

        function setFocusAfterUpdate() {
            var prm = Sys.WebForms.PageRequestManager.getInstance();

            prm.add_endRequest(function (sender, args) {
                // Verificamos que no haya errores de servidor antes de intentar poner foco
                if (args.get_error() == null) {

                    // Buscamos el textbox por su ID Static
                    var txt = document.getElementById('txtBuscar');

                    if (txt) {
                        // 1. Guardamos el largo del texto actual
                        var len = txt.value.length;

                        // 2. Ponemos el foco básico
                        txt.focus();

                        // 3. TRUCO DE MAGIA: Forzamos el cursor al final
                        // Método A: Para la mayoría de navegadores (Reset de valor)
                        var val = txt.value;
                        txt.value = '';
                        txt.value = val;
                        if (txt.setSelectionRange) {
                            txt.setSelectionRange(len, len);
                        }
                    }
                }
            });
        }

        // Inicializamos al cargar la página
        window.onload = setFocusAfterUpdate;
    </script>

    <script type="text/javascript">

        // Almacenamos el UniqueID del botón que abrió el modal
        var clickedButtonUniqueID = '';

        // 1. Abrir el Modal (Ahora recibe el uniqueID del botón)
        function abrirModalEntrega(uniqueID, idPedido) {

            // Guardamos el UniqueID en la variable global
            clickedButtonUniqueID = uniqueID;

            var modal = document.getElementById('modalConfirmarEntrega');
            var inputHidden = document.getElementById('pedidoIdConfirmar');
            var displayText = document.getElementById('pedidoIdDisplay');

            // Seteamos el ID del pedido
            inputHidden.value = idPedido;
            displayText.innerText = '#' + idPedido;

            // Mostrar el modal
            modal.classList.remove('hidden');
        }

        // 2. Cerrar el Modal
        function cerrarModalEntrega() {
            var modal = document.getElementById('modalConfirmarEntrega');
            modal.classList.add('hidden');
        }

        function confirmarEntrega() {
            // 1. Cerrar el modal
            cerrarModalEntrega();

            // 2. Obtener el ID del input del modal
            var idPedido = document.getElementById('pedidoIdConfirmar').value;

            // 3. Pasarlo al HiddenField del servidor (hfIdPedidoEntregar)
            var hf = document.getElementById('hfIdPedidoEntregar');
            if (hf) {
                hf.value = idPedido;

                // 4. Simular clic en el botón del servidor (btnEntregarServer)
                var btn = document.getElementById('btnEntregarServer');
                if (btn) {
                    btn.click();
                }
            }
        }
    </script>

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

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-7xl mx-auto">

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Gestión de Ventas</h1>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Historial de pedidos realizados.</p>
            </div>

        </div>

        <asp:UpdatePanel ID="updVentas" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:HiddenField ID="IdVenta" runat="server" />
                <asp:Button ID="btnEliminarServer" runat="server" OnClick="btnEliminarServer_Click" Style="display: none;" ClientIDMode="Static" />

                <asp:HiddenField ID="hfIdPedidoEntregar" runat="server" ClientIDMode="Static" />
                <asp:Button ID="btnEntregarServer" runat="server" OnClick="btnEntregarServer_Click" Style="display: none;" ClientIDMode="Static" />

                <div class="flex justify-between items-center gap-4 mb-4">
                    <div class="relative w-full sm:max-w-xs">
                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                            <span class="material-symbols-outlined text-slate-400">search</span>
                        </div>
                        <asp:TextBox ID="txtBuscar" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-10 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-10 pr-4 text-sm font-normal leading-normal"
                            placeholder="Buscar por ID o Cliente..."
                            onkeyup="delayPostback(this);"
                            ClientIDMode="Static" />
                        <asp:Button ID="btnBuscarTrigger" runat="server"
                            OnClick="btnBuscarTrigger_Click"
                            Style="display: none;"
                            ClientIDMode="Static" />
                    </div>
                    <div class="flex items-center gap-4">
                        <asp:HyperLink ID="btnNuevaVenta" runat="server" NavigateUrl="~/VentasForms.aspx"
                            CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90 gap-2">
                            <span class="material-symbols-outlined text-base">add_shopping_cart</span>
                            <span class="truncate">Nueva Venta</span>
                        </asp:HyperLink>
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
                                <asp:BoundField DataField="IDPedido" HeaderText="N°Pedido" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-bold" />
                                <asp:BoundField DataField="NombreCliente" HeaderText="Cliente" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:C0}"  HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-bold text-green-600" />

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

                                            <asp:HyperLink ID="btnModificar" runat="server"
                                                Visible='<%# Eval("Estado").ToString() == "Pendiente" %>'
                                                NavigateUrl='<%# "~/VentasForms.aspx?id=" + Eval("IDPedido") + "&modo=Modificar" %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-yellow-500/10 hover:text-yellow-600 dark:hover:bg-yellow-500/20"
                                                ToolTip="Modificar Pedido">
                                                <span class="material-symbols-outlined text-lg">edit</span>
                                            </asp:HyperLink>


                                            <asp:HyperLink ID="btnVer" runat="server"
                                                Visible='<%# Eval("Estado").ToString() != "Pendiente" %>'
                                                NavigateUrl='<%# "~/VentasForms.aspx?id=" + Eval("IDPedido") + "&modo=Ver" %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-blue-500/10 hover:text-blue-600 dark:hover:bg-blue-500/20"
                                                ToolTip="Ver Detalles">
                                                <span class="material-symbols-outlined text-lg">visibility</span>
                                            </asp:HyperLink>

                                            <asp:HyperLink ID="btnEliminar" runat="server" Visible='<%# Eval("Estado").ToString() == "Pendiente" %>' ToolTip="Eliminar">
                                                <a href="javascript:void(0);"
                                                    onclick="abrirModalEliminar(<%# Eval("IDPedido") %>);"
                                                    class="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-red-500/10 hover:text-red-500 dark:hover:bg-red-500/20 cursor-pointer">
                                                    <span class="material-symbols-outlined text-lg">delete</span>
                                                </a>
                                            </asp:HyperLink>

                                            <asp:LinkButton ID="btnEntregado" runat="server"
                                                Visible='<%# Eval("Estado").ToString() == "Pendiente" %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-green-500/10 hover:text-green-500 dark:hover:bg-green-500/20"
                                                OnClientClick='<%# "abrirModalEntrega(this.uniqueID, " + Eval("IDPedido") + "); return false;" %>'
                                                ToolTip="Entregado">
                                                <span class="material-symbols-outlined text-lg">check_circle</span>
                                            </asp:LinkButton>
                                        </div>

                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                    </div>
                </div>
                <asp:LinkButton ID="btnPostbackReferencia" runat="server" Style="display: none;" />
            </ContentTemplate>

            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnBuscarTrigger" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="gvPedidos" EventName="PageIndexChanging" />
                <asp:AsyncPostBackTrigger ControlID="btnEntregarServer" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnEliminarServer" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>


        <!-- MODALS -->


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



    <div id="modalConfirmarEntrega" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden flex items-center justify-center z-50">
        <div class="bg-white dark:bg-slate-800 rounded-lg shadow-2xl w-full max-w-sm p-6 transform transition-all duration-300">

            <div class="flex justify-between items-start border-b border-gray-200 dark:border-slate-700 pb-3 mb-4">
                <h3 class="text-xl font-semibold text-gray-900 dark:text-white">Confirmar Entrega
                </h3>
                <button type="button" onclick="cerrarModalEntrega()" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <div class="mb-6">
                <p class="text-sm text-gray-600 dark:text-gray-300">
                    ¿Estás seguro de que deseas marcar el pedido <strong id="pedidoIdDisplay">#XXX</strong> como **ENTREGADO**? Esta acción no se puede deshacer fácilmente.
                </p>
                <input type="hidden" id="pedidoIdConfirmar" value="" />
            </div>

            <div class="flex justify-end gap-3">
                <button type="button" onclick="cerrarModalEntrega()"
                    class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-gray-100 dark:bg-slate-700 rounded-md hover:bg-gray-200 dark:hover:bg-slate-600 transition duration-150">
                    Cancelar
                </button>

                <button type="button" onclick="confirmarEntrega()"
                    class="px-4 py-2 text-sm font-medium text-white bg-green-600 rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 transition duration-150">
                    Confirmar
                </button>
            </div>

        </div>
    </div>



</asp:Content>
