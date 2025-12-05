<%@ Page Title="Gestión de Clientes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClientesListado.aspx.cs" Inherits="Presentacion.ClientesListado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 
    <script src="Scripts/jquery-3.7.0.min.js"></script>

    <script src="Scripts/bootstrap.bundle.min.js"></script>


    <script type="text/javascript">
        // --- TUS SCRIPTS DE BÚSQUEDA (Conservados) ---
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

        <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server" />

        <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
            <div class="flex flex-col gap-1">
                <h1 class="text-slate-900 dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Gestión de Clientes</h1>
                <p class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal">Administra tu cartera de clientes.</p>
            </div>
            <div class="flex items-center gap-4">
                <asp:HyperLink ID="btnNuevoCliente" runat="server" NavigateUrl="~/ClientesForm.aspx"
                    CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90 gap-2">
                    <span class="material-symbols-outlined text-base">add</span>
                    <span class="truncate">Nuevo Cliente</span>
                </asp:HyperLink>
            </div>
        </div>

        <asp:UpdatePanel ID="updClientes" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:HiddenField ID="hfIdCliente" runat="server" />
                <asp:Button ID="btnEliminarServer" runat="server" OnClick="btnEliminarServer_Click" Style="display: none;" ClientIDMode="Static" />

                <div class="flex justify-between items-center gap-4 mb-4">
                    <div class="relative w-full sm:max-w-xs">
                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                            <span class="material-symbols-outlined text-slate-400">search</span>
                        </div>
                        <asp:TextBox ID="txtBuscar" runat="server"
                            CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-10 placeholder:text-slate-400 dark:placeholder:text-slate-500 pl-10 pr-4 text-sm font-normal leading-normal"
                            placeholder="Buscar cliente..."
                            onkeyup="delayPostback(this);"
                            OnTextChanged="txtBuscar_TextChanged" />
                    </div>
                </div>

                <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/60 overflow-hidden">
                    <div class="overflow-x-auto">

                        <asp:GridView ID="gvClientes" runat="server"
                            AutoGenerateColumns="False"
                            DataKeyNames="IDCliente"
                            CssClass="w-full text-sm text-left text-slate-500 dark:text-slate-400"
                            GridLines="None"
                            AllowPaging="True" PageSize="10"
                            OnPageIndexChanging="gvClientes_PageIndexChanging">

                            <HeaderStyle CssClass="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-700/50" />
                            <RowStyle CssClass="bg-white dark:bg-slate-800 border-b dark:border-slate-700/60 hover:bg-slate-50 dark:hover:bg-slate-700/40" />
                            <PagerStyle CssClass="flex items-center justify-between p-4" />

                            <Columns>
                                <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" />
                                <asp:BoundField DataField="Dni" HeaderText="DNI" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Telefono" HeaderText="Teléfono" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Direccion" HeaderText="Dirección" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Altura" HeaderText="Altura" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />
                                <asp:BoundField DataField="Localidad" HeaderText="Localidad" HeaderStyle-CssClass="px-6 py-3" ItemStyle-CssClass="px-6 py-4" />

                                <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="px-6 py-3 text-center" ItemStyle-CssClass="px-6 py-4 text-center">
                                    <ItemTemplate>
                                        <div class="flex justify-center gap-2">

                                            <asp:HyperLink ID="btnEditar" runat="server"
                                                NavigateUrl='<%# Eval("IDCliente", "ClientesForm.aspx?id={0}") %>'
                                                CssClass="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-primary/10 hover:text-primary dark:hover:bg-primary/20">
                <span class="material-symbols-outlined text-lg">edit</span>
            </asp:HyperLink>

                                            <asp:PlaceHolder ID="phEliminar" runat="server" Visible='<%# EsAdmin() %>'>
                                                <a href="javascript:void(0);"
                                                    onclick="abrirModalEliminar(<%# Eval("IDCliente") %>);"
                                                    class="p-1.5 rounded-md text-slate-500 dark:text-slate-400 hover:bg-red-500/10 hover:text-red-500 dark:hover:bg-red-500/20 cursor-pointer">
                                                    <span class="material-symbols-outlined text-lg">delete</span>
                                                </a>
                                            </asp:PlaceHolder>

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

      <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 400px;">
        
        <div class="modal-content border-0 shadow-2xl overflow-hidden" 
             style="border-radius: 1rem; border: 2px solid #1173d4;">
            
            <div class="bg-primary text-white px-4 py-2 flex justify-between items-center">
                <span class="font-bold text-sm tracking-wide">BAJA DE CLIENTE</span>
                <button type="button" class="btn-close btn-close-white text-xs" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body text-center pt-6 pb-4 px-4 bg-white dark:bg-slate-800">
                <div class="mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-blue-50 dark:bg-blue-900/20">
                    <span class="material-symbols-outlined text-3xl text-primary">person_remove</span>
                </div>
                
                <h3 class="text-lg font-bold text-slate-800 dark:text-white">¿Eliminar Cliente?</h3>
                <p class="text-slate-500 text-sm mt-1 leading-snug">
                    Se dará de baja al cliente seleccionado.
                </p>
            </div>

            <div class="flex gap-2 p-3 bg-slate-50 dark:bg-slate-800/50 justify-center">
                <button type="button" 
                        class="px-4 py-1.5 rounded text-sm text-slate-600 font-medium hover:bg-slate-200 transition-colors"
                        data-bs-dismiss="modal">
                    Cancelar
                </button>
                <button type="button" 
                        class="px-4 py-1.5 rounded text-sm bg-primary text-white font-bold hover:bg-blue-600 shadow-md transition-colors"
                        onclick="confirmarEliminar()">
                    Sí, eliminar
                </button>
            </div>

        </div>
    </div>
</div>

    </div>

    <script type="text/javascript">
        function abrirModalEliminar(id) {
            var hf = document.getElementById('<%= hfIdCliente.ClientID %>');
            if (hf) hf.value = id;

            var el = document.getElementById('deleteModal');
            // Ahora que agregaste el script en el Paso 1, esto funcionará:
            var myModal = new bootstrap.Modal(el);
            myModal.show();
        }

        function confirmarEliminar() {
            // ... (código para cerrar modal y clickear btnEliminarServer) ...
            document.getElementById('btnEliminarServer').click();
        }

        function confirmarEliminar() {
            try {
                // Cerrar modal
                var el = document.getElementById('deleteModal');
                if (window.bootstrap) {
                    var myModal = bootstrap.Modal.getInstance(el);
                    if (myModal) myModal.hide();
                } else if (window.jQuery) {
                    $('#deleteModal').modal('hide');
                }
            } catch (e) { }

            // Disparar evento servidor
            document.getElementById('btnEliminarServer').click();
        }
    </script>
</asp:Content>
