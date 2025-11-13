<%@ Page Title="Gestión de Ventas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VentasListado.aspx.cs" Inherits="Presentacion.VentasListado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script type="text/javascript">
        var delayTimer;

        // Función que espera un momento antes de ejecutar el PostBack
        function delayPostback(source) {
            clearTimeout(delayTimer);

            delayTimer = setTimeout(function () {
                // Ejecuta el PostBack asíncrono
                __doPostBack(source.name, '');
            }, 500); // Retraso de 500 milisegundos
        }

        // =========================================================
        // AÑADIDO CLAVE: Función para mantener el foco después de AJAX
        // =========================================================
        function setFocusAfterUpdate() {
            // El componente PageRequestManager maneja las peticiones AJAX
            var prm = Sys.WebForms.PageRequestManager.getInstance();

            // Suscribirse al evento que ocurre al finalizar la petición AJAX
            prm.add_endRequest(function (sender, args) {
                // Verificar si la petición no falló
                if (args.get_error() == null) {
                    // Obtener el TextBox por su ID de cliente
                    var focusedControl = $get('<%= txtBuscar.ClientID %>');
                  if (focusedControl) {
                      focusedControl.focus();
                      // Opcional: Esto mueve el cursor al final del texto
                      var temp = focusedControl.value;
                      focusedControl.value = '';
                      focusedControl.value = temp;
                  }
              }
          });
        }

        // Llamar a la función al cargar la página (para que se suscriba al evento)
        window.onload = setFocusAfterUpdate;
    </script>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server" />

    <div class="font-display bg-background-light dark:bg-background-dark text-[#2C3E50] dark:text-gray-200">

        <main class="flex-grow p-4 md:p-8">
            <div class="mx-auto max-w-7xl">

                <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
                    <div class="flex flex-col gap-1">
                        <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Listado de Ventas</h1>
                        <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Administra, filtra y busca todas las ventas de tu negocio.</p>
                    </div>
                    <asp:HyperLink ID="lnkNuevaVenta" runat="server" NavigateUrl="~/VentasForms" CssClass="flex items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold gap-2">
                        <span class="material-symbols-outlined">add_circle</span>
                        <span class="truncate">Nueva Venta</span>
                    </asp:HyperLink>
                </div>

                <div class="mb-4 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 p-4">
                    <div class="grid grid-cols-1 gap-4">
                        <div class="lg:col-span-4">
                            <label class="sr-only" for="txtBuscar">Buscar</label>
                            <div class="relative">
                                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                    <span class="material-symbols-outlined text-gray-400">search</span>
                                </div>
                                <asp:TextBox ID="txtBuscar" runat="server"
                                    CssClass="block w-full rounded-lg border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 pl-10 h-11 focus:border-primary focus:ring-primary dark:placeholder-gray-400"
                                    placeholder="Buscar por Nº de pedido o cliente..."
                                    onkeyup="delayPostback(this);"
                                    OnTextChanged="txtBuscar_TextChanged"
                                    AutoPostBack="true" />
                            </div>
                        </div>
                    </div>
                </div>

                <asp:UpdatePanel ID="updPedidos" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>

                        <!-- 3. Grilla de Ventas -->
                        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60 overflow-hidden">
                            <div class="overflow-x-auto">

                                <asp:GridView ID="gvPedidos" runat="server"
                                    AutoGenerateColumns="False"
                                    DataKeyNames="IDPedido"
                                    CssClass="w-full text-sm text-left text-slate-500 dark:text-slate-400"
                                    GridLines="None"
                                    AllowPaging="True" PageSize="10"
                                    OnPageIndexChanging="gvPedidos_PageIndexChanging"
                                    OnRowCommand="gvPedidos_RowCommand">

                                    <HeaderStyle CssClass="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-700/50" />
                                    <RowStyle CssClass="bg-white dark:bg-slate-800 border-b dark:border-slate-700/60 hover:bg-slate-50 dark:hover:bg-slate-700/40" />
                                    <PagerStyle CssClass="flex items-center justify-between p-4" />

                                    <Columns>
                                        <asp:BoundField DataField="IDPedido" HeaderText="Nº Pedido" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />
                                        <asp:BoundField DataField="NombreCliente" HeaderText="Cliente" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                        <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                        <asp:TemplateField HeaderText="Estado" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4">
                                            <ItemTemplate>
                                                <span class='<%# GetEstadoClass(Eval("Estado").ToString()) %>'>
                                                    <%# Eval("Estado") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Total" HeaderText="Total" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                        <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center">



                                            <ItemTemplate>
                                                <div class="flex justify-center gap-2">

                                                    <!-- ESTE ES EL CAMBIO CLAVE: Es un link que navega a la otra página -->
                                                    <asp:HyperLink ID="btnEditar" runat="server"
                                                        NavigateUrl='<%# Eval("IDPedido", "VentasForms.aspx?id={0}") %>'
                                                        CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-primary/10 hover:text-primary dark:hover:bg-primary/20">
                                    <span class="material-symbols-outlined text-lg">edit</span>
                                                    </asp:HyperLink>

                                                    <asp:LinkButton ID="btnEliminar" runat="server"
                                                        CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-red-500/10 hover:text-red-500 dark:hover:bg-red-500/20"
                                                        OnClientClick="return confirm('¿Está seguro de que desea eliminar este cliente?');"
                                                        CommandName="Eliminar"
                                                        CommandArgument='<%# Container.DataItemIndex %>'>

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
                        <asp:AsyncPostBackTrigger ControlID="gvPedidos" EventName="PageIndexChanging" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </main>
    </div>
</asp:Content>
