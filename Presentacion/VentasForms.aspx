<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VentasForms.aspx.cs" Inherits="Presentacion.VentasForms" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script type="text/javascript">

        // --- Lógica de Debounce ---
        var delayTimer;

        // Función que espera un momento antes de ejecutar el PostBack
        function delayPostback(source) {
            clearTimeout(delayTimer);

            delayTimer = setTimeout(function () {
                
                __doPostBack(source.name, '');
            }, 500);
        }


       
        var postBackElementId = "";

       
        function onBeginRequest(sender, args) {
           
            postBackElementId = args.get_postBackElement().id;
        }

        
        function onEndRequestFocus(sender, args) {

           
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
            
            
            postBackElementId = "";
        }

        function setFocusAfterUpdate() {
            var prm = Sys.WebForms.PageRequestManager.getInstance();

         
            prm.remove_beginRequest(onBeginRequest);
            prm.remove_endRequest(onEndRequestFocus); 

           
            prm.add_beginRequest(onBeginRequest);
            prm.add_endRequest(onEndRequestFocus);
        }
        

       
        function pageLoad(sender, args) {
            
         
            setFocusAfterUpdate();

            var searchBoxClientID = '<%= txtBuscarCliente.ClientID %>';
            var $searchBox = $('#' + searchBoxClientID);

            
            $searchBox.off('keyup');

            
            $searchBox.on('keyup', function (e) {

                if (e.key === 'Enter' || e.keyCode === 13) {
                    return; 
                }

              
                delayPostback(this);
            });
        }

    </script>
 
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   
   <div class="relative flex h-screen min-h-screen w-full flex-col group/design-root overflow-hidden">
      
        <main class="flex-1 flex flex-col p-6 gap-6 overflow-hidden">
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

                               <div class="mt-4 max-h-20 overflow-y-auto">
                                    <asp:GridView ID="gvClientes" runat="server" 
                                        AutoGenerateColumns="false"
                                        DataKeyNames="IDCliente"
                                        OnSelectedIndexChanged="gvClientes_SelectedIndexChanged"
                                        CssClass="w-full text-sm text-left text-slate-700 dark:text-slate-300"
                                        HeaderStyle-CssClass="text-xs text-slate-500 uppercase bg-slate-100 dark:bg-slate-800 p-3"
                                        RowStyle-CssClass="bg-white dark:bg-slate-900/50 border-b border-slate-200 dark:border-slate-800"
                                        SelectedRowStyle-CssClass="bg-primary/20"
                                        EmptyDataText="No se encontraron clientes.">
                                        <Columns>
                                            <%-- Columna para el botón de Seleccionar --%>
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnSeleccionar" runat="server" 
                                                        CommandName="Select" 
                                                        CssClass="bg-primary/20 text-primary text-xs font-semibold px-2 py-1 rounded-md"
                                                        CausesValidation="false">
                                                        Seleccionar
                                                    </asp:LinkButton>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="100px" />
                                            </asp:TemplateField>
                                            
                                            <%-- Columnas para los datos --%>
                                            <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                                            <asp:BoundField DataField="DNI" HeaderText="DNI" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            
                            
                            <div class="md:col-span-8 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 bg-slate-50 dark:bg-slate-800/50 p-4 rounded-lg">
                                <div class="md:col-span-1">
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1" for="txtClientName">Nombre y Apellido</label>
                                    <asp:TextBox ID="txtClientName" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1" for="txtClientAddress">Dirección</label>
                                    <asp:TextBox ID="txtClientAddress" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1" for="txtClientCity">Localidad</label>
                                    <asp:TextBox ID="txtClientCity" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1" for="txtClientDNI">DNI</label>
                                    <asp:TextBox ID="txtClientDNI" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1" for="txtClientPhone">Teléfono</label>
                                    <asp:TextBox ID="txtClientPhone" runat="server" CssClass="form-input w-full bg-transparent p-0 border-0 focus:ring-0 text-slate-900 dark:text-white font-semibold" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

            <div class="bg-white dark:bg-slate-900/50 rounded-xl shadow-sm flex-1 flex flex-col overflow-hidden">
                <div class="p-6 border-b border-slate-200 dark:border-slate-800">
                    <div class="flex items-end gap-4">
                        <div class="flex-1">
                            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Buscar Producto</label>
                            <div class="relative">
                                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                    <span class="material-symbols-outlined text-slate-400">search</span>
                                </div>
                                <asp:TextBox ID="txtSearchProduct" runat="server" CssClass="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 h-11 placeholder:text-slate-500 dark:placeholder:text-slate-400 px-4 pl-10 text-base" placeholder="Escanear o buscar por nombre/código..."></asp:TextBox>
                            </div>
                        </div>
                        <asp:LinkButton ID="btnAddProduct" runat="server" CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-11 px-5 bg-primary/20 text-primary gap-2 text-base font-bold">
                            <span class="material-symbols-outlined">add_shopping_cart</span>
                            <span class="truncate">Añadir Producto</span>
                        </asp:LinkButton>
                    </div>
                </div>
                <div class="flex-1 overflow-y-auto px-6">
                    <div class="w-full text-left">
                        <div class="text-xs font-semibold uppercase text-slate-500 dark:text-slate-400 grid grid-cols-12 gap-4 py-4 border-b border-slate-200 dark:border-slate-800 sticky top-0 bg-white dark:bg-slate-900/50">
                            <div class="col-span-5">Producto</div>
                            <div class="col-span-3 text-center">Cantidad</div>
                            <div class="col-span-2 text-right">Precio Unitario</div>
                            <div class="col-span-2 text-right">Parcial</div>
                        </div>
                       


                        <div class="divide-y divide-slate-200 dark:divide-slate-800">
                            <div class="grid grid-cols-12 gap-4 items-center py-4">
                                <div class="col-span-5 flex items-center gap-3">
                                    <div class="bg-center bg-no-repeat aspect-square bg-cover rounded-lg size-12" data-alt="Imagen de Teclado Mecánico" style='background-image: url("https://lh3.googleusercontent.com/aida-public/AB6AXuC4lhX1IvHaPdsvhpYy1AXz_hYddxW4uX9Cmj8IE_FrskM4LNhE0_BD-mGCUH5FPeJW-s79wUOGttcvZlgv1oEhi5KiqIuX0gSP_bHrzXa4ijqVEIBzPJ_Nng0AjNyVC3K28LwRjFWUK29f8REolNxo9fRO5hm4R-2q7jW2YxaC_JbNA-kmA5H6ao4w0UWBgz1BmySvJmcarsGCGGduaaxebFwehYEpubqaCsnDQSZI4GUkCKaVAt3HJ2ojRtlx0fTlZucF1nd4YA");'></div>
                                    <div>
                                        <p class="font-bold text-slate-900 dark:text-white">Teclado Mecánico RGB</p>
                                        <p class="text-sm text-slate-500 dark:text-slate-400">SKU: 45-B21</p>
                                    </div>
                                </div>
                                <div class="col-span-3 flex items-center justify-center gap-2">
                                    <asp:Button ID="btnDecreaseQty1" runat="server" CssClass="flex items-center justify-center size-8 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300" Text="-" />
                                    <asp:TextBox ID="txtQuantity1" runat="server" CssClass="w-12 text-center bg-transparent border border-slate-300 dark:border-slate-700 rounded-lg h-8 p-1" Text="1"></asp:TextBox>
                                    <asp:Button ID="btnIncreaseQty1" runat="server" CssClass="flex items-center justify-center size-8 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300" Text="+" />
                                </div>
                                <div class="col-span-2 text-right font-medium text-slate-600 dark:text-slate-300">$89.99</div>
                                <div class="col-span-2 text-right font-bold text-slate-900 dark:text-white">$89.99</div>
                            </div>
                            <div class="grid grid-cols-12 gap-4 items-center py-4">
                                <div class="col-span-5 flex items-center gap-3">
                                    <div class="bg-center bg-no-repeat aspect-square bg-cover rounded-lg size-12" data-alt="Imagen de Mouse Inalámbrico" style='background-image: url("https://lh3.googleusercontent.com/aida-public/AB6AXuCx5iiHHedNscDxAa5XJwSL-lNCc9mvKzES5x5LzvkZOn38I33wygvbpiQtjMwyg7zkVWi9iju5so_G5HXDsZYaPGnQDEz_fB1UJQ8dUs8sco0JKT50SGP14DTzEOoIASrddM8Kr53WCoWrvBfRnNZnqRgg2dlYIAb5ryatDgdPXvkJsVE8RzOcaqYwEygeQx-YCFkDck12QDWQYCEDzW6iDDkHr_4NUxRouXGPBhAqEOgJ_uetdouQvOmYAgWsP44zsLeuRpj6dA");'></div>
                                    <div>
                                        <p class="font-bold text-slate-900 dark:text-white">Mouse Inalámbrico Pro</p>
                                        <p class="text-sm text-slate-500 dark:text-slate-400">SKU: 88-M04</p>
                                    </div>
                                </div>
                                <div class="col-span-3 flex items-center justify-center gap-2">
                                    <asp:Button ID="btnDecreaseQty2" runat="server" CssClass="flex items-center justify-center size-8 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300" Text="-" />
                                    <asp:TextBox ID="txtQuantity2" runat="server" CssClass="w-12 text-center bg-transparent border border-slate-300 dark:border-slate-700 rounded-lg h-8 p-1" Text="2"></asp:TextBox>
                                    <asp:Button ID="btnIncreaseQty2" runat="server" CssClass="flex items-center justify-center size-8 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300" Text="+" />
                                </div>
                                <div class="col-span-2 text-right font-medium text-slate-600 dark:text-slate-300">$45.50</div>
                                <div class="col-span-2 text-right font-bold text-slate-900 dark:text-white">$91.00</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="p-6 bg-background-light dark:bg-background-dark border-t border-slate-200 dark:border-slate-800 mt-auto">
                    <div class="grid grid-cols-12 gap-x-6 items-end">
                        <div class="col-span-7">
                            <asp:LinkButton ID="btnFinalizarVenta" runat="server" CssClass="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-11 px-5 bg-primary text-white gap-2 text-base font-bold tracking-wide">
                                <span class="material-symbols-outlined" style="font-size: 20px;">shopping_cart_checkout</span>
                                <span class="truncate">Finalizar Venta</span>
                            </asp:LinkButton>
                        </div>
                        <div class="col-span-5">
                            <div class="flex flex-col gap-1 text-sm">
                                <div class="flex justify-between items-center text-slate-600 dark:text-slate-300">
                                    <span>Subtotal</span>
                                    <asp:Label ID="lblSubtotal" runat="server" CssClass="font-medium" Text="$180.99"></asp:Label>
                                </div>
                                <div class="flex justify-between items-center text-slate-600 dark:text-slate-300">
                                    <span>IVA (16%)</span>
                                    <asp:Label ID="lblIVA" runat="server" CssClass="font-medium" Text="$28.96"></asp:Label>
                                </div>
                                <div class="flex justify-between items-center text-slate-900 dark:text-white text-base font-bold pt-2 border-t border-slate-300 dark:border-slate-700 mt-1">
                                    <span>Total Final</span>
                                    <asp:Label ID="lblTotalFinal" runat="server" Text="$209.95"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</asp:Content>
