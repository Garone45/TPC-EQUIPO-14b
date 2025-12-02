<%@ Page Title="Gestión de Compras" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ComprasListado.aspx.cs" Inherits="Presentacion.ComprasListado" %>

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

    <div class="max-w-7xl mx-auto">

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Listado de Compras</h1>
            </div>
        </div>

        <div class="flex justify-between items-center gap-4 mb-4">
            <div class="relative w-full sm:max-w-xs">
                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                    <span class="material-symbols-outlined text-slate-400">search</span>
                </div>
                <asp:TextBox ID="txtBuscar" runat="server"
                    CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-10 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-10 pr-4 text-sm font-normal leading-normal"
                    placeholder="Buscar por Nº de compra o proveedor..."
                    onkeyup="delayPostback(this);"
                    OnTextChanged="txtBuscar_TextChanged"
                    AutoPostBack="true" />
            </div>

            <div class="flex items-center gap-4">
                <asp:HyperLink ID="lnkNuevaCompra" runat="server" NavigateUrl="~/ComprasForms.aspx"
                    CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90 gap-2">
                    <span class="material-symbols-outlined text-base">add_shopping_cart</span>
                    <span class="truncate">Nueva Compra</span>
                </asp:HyperLink>
            </div>
        </div>

        <asp:UpdatePanel ID="updCompras" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                
                <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60 overflow-hidden">
                    <div class="overflow-x-auto">

                        <asp:GridView ID="gvCompras" runat="server"
                            AutoGenerateColumns="False"
                            DataKeyNames="IDCompra"
                            CssClass="w-full text-sm text-left text-slate-500 dark:text-slate-400"
                            GridLines="None"
                            AllowPaging="True" PageSize="10"
                            OnPageIndexChanging="gvCompras_PageIndexChanging"
                            OnRowCommand="gvCompras_RowCommand">

                            <HeaderStyle CssClass="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-700/50" />
                            <RowStyle CssClass="bg-white dark:bg-slate-800 border-b dark:border-slate-700/60 hover:bg-slate-50 dark:hover:bg-slate-700/40" />
                            <PagerStyle CssClass="flex items-center justify-between p-4" />

                            <Columns>
                                <asp:BoundField DataField="IDCompra" HeaderText="Nº Compra" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />
                                <asp:BoundField DataField="RazonSocialProveedor" HeaderText="Proveedor" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="FechaCompra" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="MontoTotal" HeaderText="Total" DataFormatString="{0:C0}" HtmlEncode="false" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-bold text-red-600" />
                                
                                <asp:TemplateField HeaderText="Estado" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4">
                                    <ItemTemplate>
                                        <span class='<%# GetEstadoClass(Eval("EstadoCompra").ToString()) %>'>
                                            <%# Eval("EstadoCompra") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center">
                                    <ItemTemplate>
                                        <div class="flex justify-center gap-2">
                                            
                                            <asp:HyperLink ID="btnModificar" runat="server"
                                                Visible='<%# Eval("EstadoCompra").ToString() == "Pendiente" %>'
                                                NavigateUrl='<%# "~/ComprasForms.aspx?id=" + Eval("IDCompra") %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 hover:bg-yellow-50 hover:text-yellow-600 transition-colors"
                                                ToolTip="Modificar Compra">
                                                <span class="material-symbols-outlined text-lg">edit</span>
                                            </asp:HyperLink>

                                            <asp:HyperLink ID="btnVer" runat="server"
                                                Visible='<%# Eval("EstadoCompra").ToString() != "Pendiente" %>'
                                                NavigateUrl='<%# "~/ComprasForms.aspx?id=" + Eval("IDCompra") + "&modo=Ver" %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 hover:bg-blue-50 hover:text-blue-600 transition-colors"
                                                ToolTip="Ver Detalle">
                                                <span class="material-symbols-outlined text-lg">visibility</span>
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
                <asp:AsyncPostBackTrigger ControlID="gvCompras" EventName="PageIndexChanging" />
            </Triggers>
        </asp:UpdatePanel>

    </div>
</asp:Content>
