<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ComprasForms.aspx.cs" Inherits="Presentacion.ComprasForms" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
       <!-- Contenedor Principal Flex -->
<div class="relative flex h-full min-h-screen w-full flex-col overflow-x-hidden">
    <div class="flex h-full grow flex-col">
        <main class="flex flex-1 justify-center py-8 px-4 sm:px-6 lg:px-8">
            <div class="flex w-full max-w-4xl flex-col gap-8">
                
                <!-- Page Heading -->
                <header class="flex flex-wrap items-center justify-between gap-4">
                    <h1 class="text-3xl font-black leading-tight tracking-[-0.033em] text-gray-900 dark:text-white sm:text-4xl">Registrar Nueva Compra</h1>
                </header>

                <!-- General Information Section -->
                <section class="w-full rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-700 dark:bg-gray-800/50">
                    <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
                        
                        <!-- Proveedor Dropdown -->
                        <div class="flex flex-col">
                            <p class="pb-2 text-base font-medium text-gray-900 dark:text-white">Proveedor</p>
                            <div class="flex items-center gap-2">
                                <<asp:DropDownList ID="ddlProveedor" runat="server" data-placeholder="Buscar y seleccionar un proveedor" CssClass="w-full">
                                    
                                 </asp:DropDownList>
                                
                                <asp:LinkButton ID="btnAgregarProveedor" runat="server" CssClass="flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10 text-primary transition-colors hover:bg-primary/20 dark:bg-primary/20 dark:hover:bg-primary/30" aria-label="Añadir nuevo proveedor">
                                    <span class="material-symbols-outlined">add</span>
                                </asp:LinkButton>
                            </div>
                        </div>

                        <!-- Fecha Input -->
                        <div class="flex flex-col">
                            <p class="pb-2 text-base font-medium text-gray-900 dark:text-white">Fecha de Compra</p>
                            <div class="relative flex w-full flex-1 items-stretch">
                                <asp:TextBox ID="txtFechaCompra" runat="server" TextMode="Date" CssClass="form-input h-12 w-full flex-1 resize-none overflow-hidden rounded-lg border border-gray-300 bg-background-light p-3 pr-10 text-base font-normal leading-normal text-gray-900 placeholder:text-gray-500 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/20 dark:border-gray-600 dark:bg-background-dark dark:text-white dark:placeholder:text-gray-400"></asp:TextBox>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                                    <span class="material-symbols-outlined text-gray-500 dark:text-gray-400">calendar_today</span>
                                </div>
                            </div>
                        </div>

                        <!-- Factura Input -->
                        <div class="md:col-span-2">
                            <div class="flex flex-col">
                                <p class="pb-2 text-base font-medium text-gray-900 dark:text-white">Número de Factura/Referencia (Opcional)</p>
                                <asp:TextBox ID="txtFacturaRef" runat="server" CssClass="form-input h-12 w-full flex-1 resize-none overflow-hidden rounded-lg border border-gray-300 bg-background-light p-3 text-base font-normal leading-normal text-gray-900 placeholder:text-gray-500 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/20 dark:border-gray-600 dark:bg-background-dark dark:text-white dark:placeholder:text-gray-400" placeholder="Ingrese el número de referencia"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Products Section -->
                <section class="w-full rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-700 dark:bg-gray-800/50">
                    <h2 class="text-xl font-bold leading-tight tracking-[-0.015em] text-gray-900 dark:text-white">Detalle de Productos</h2>
                    
                    <!-- Add Product Form -->
                    <div class="mt-4 grid grid-cols-12 items-end gap-x-4 gap-y-4 rounded-lg border border-gray-200 bg-background-light p-4 dark:border-gray-700 dark:bg-background-dark">
                        
                        <div class="col-span-12 flex flex-col sm:col-span-6 md:col-span-5">
                            <p class="pb-2 text-sm font-medium">Producto</p>
                            <asp:DropDownList ID="ddlProductoItem" runat="server" CssClass="form-select h-11 w-full rounded-md border-gray-300 bg-white text-sm dark:border-gray-600 dark:bg-gray-700 dark:text-white">
                                
                            </asp:DropDownList>
                        </div>

                        <div class="col-span-6 flex flex-col sm:col-span-3 md:col-span-2">
                            <p class="pb-2 text-sm font-medium">Cantidad</p>
                            <asp:TextBox ID="txtCantidad" runat="server" TextMode="Number" CssClass="form-input h-11 w-full rounded-md border-gray-300 bg-white text-sm dark:border-gray-600 dark:bg-gray-700 dark:text-white" placeholder="0"></asp:TextBox>
                        </div>

                        <div class="col-span-6 flex flex-col sm:col-span-3 md:col-span-2">
                            <p class="pb-2 text-sm font-medium">Costo/Ud.</p>
                            <asp:TextBox ID="txtCosto" runat="server" TextMode="Number" CssClass="form-input h-11 w-full rounded-md border-gray-300 bg-white text-sm dark:border-gray-600 dark:bg-gray-700 dark:text-white" placeholder="0.00"></asp:TextBox>
                        </div>

                        <div class="col-span-12 flex justify-end md:col-span-3">
                            <asp:LinkButton ID="btnAnadirProducto" runat="server" CssClass="flex h-11 w-full items-center justify-center gap-2 rounded-lg bg-emerald-500 px-4 text-sm font-semibold text-white transition-colors hover:bg-emerald-600 dark:bg-emerald-600 dark:hover:bg-emerald-700">
                                <span class="material-symbols-outlined" style="font-size: 20px;">add_circle</span>
                                Añadir Producto
                            </asp:LinkButton>
                        </div>
                    </div>

                    <!-- Products Table -->
                     <div class="mt-6 flow-root">
                         <div class="-mx-6 -my-2 overflow-x-auto">
                             <div class="inline-block min-w-full py-2 align-middle sm:px-6">
                                 <asp:GridView 
                                     ID="gvDetalleCompra" 
                                     runat="server"
                                     AutoGenerateColumns="false"
                                     GridLines="None"
                                     CssClass="min-w-full divide-y divide-gray-200 dark:divide-gray-700"
                                     HeaderStyle-CssClass="bg-background-light dark:bg-gray-800"
                                     RowStyle-CssClass="divide-y divide-gray-200 dark:divide-gray-700"
                                     EmptyDataText="No hay productos añadidos a la compra."
                                     ShowHeaderWhenEmpty="true"
                                     >
                                     <Columns>
                                         
                                         
                                         <asp:TemplateField HeaderText="Producto">
                                             <HeaderStyle CssClass="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 dark:text-white sm:pl-0" />
                                             <ItemTemplate>
                                                 <asp:Label ID="lblProductoNombre" runat="server" Text='<%# Eval("NombreProducto") %>' CssClass="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 dark:text-white sm:pl-0"></asp:Label>
                                             </ItemTemplate>
                                         </asp:TemplateField>

                                        
                                         <asp:TemplateField HeaderText="Cantidad">
                                             <HeaderStyle CssClass="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-white" />
                                             <ItemTemplate>
                                                 <asp:Label ID="lblCantidad" runat="server" Text='<%# Eval("Cantidad") %>' CssClass="whitespace-nowrap px-3 py-4 text-sm text-gray-600 dark:text-gray-300"></asp:Label>
                                             </ItemTemplate>
                                         </asp:TemplateField>

                                 
                                         <asp:TemplateField HeaderText="Precio de Costo">
                                             <HeaderStyle CssClass="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-white" />
                                             <ItemTemplate>
                                                 <asp:Label ID="lblPrecioCosto" runat="server" Text='<%# Eval("PrecioCosto", "{0:C}") %>' CssClass="whitespace-nowrap px-3 py-4 text-sm text-gray-600 dark:text-gray-300"></asp:Label>
                                             </ItemTemplate>
                                         </asp:TemplateField>

                                  
                                         <asp:TemplateField HeaderText="Subtotal">
                                             <HeaderStyle CssClass="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-white" />
                                             <ItemTemplate>
                                                 <asp:Label ID="lblSubtotal" runat="server" Text='<%# Eval("Subtotal", "{0:C}") %>' CssClass="whitespace-nowrap px-3 py-4 text-sm text-gray-600 dark:text-gray-300"></asp:Label>
                                             </ItemTemplate>
                                         </asp:TemplateField>

                                      
                                         <asp:TemplateField HeaderText="Acciones">
                                             <HeaderStyle CssClass="relative py-3.5 pl-3 pr-4 sm:pr-0" />
                                             <ItemTemplate>
                                                 <asp:LinkButton 
                                                     ID="btnEliminarProducto" 
                                                     runat="server" 
                                                     CommandName="Eliminar" 
                                                     CommandArgument='<%# Eval("IDDetalle") %>'
                                                     CssClass="text-red-500 transition-colors hover:text-red-700 dark:text-red-400 dark:hover:text-red-300"
                                                     aria-label="Eliminar producto">
                                                     <span class="material-symbols-outlined" style="font-size: 20px;">delete</span>
                                                 </asp:LinkButton>
                                             </ItemTemplate>
                                         </asp:TemplateField>
                                         
                                     </Columns>
                                     <EmptyDataTemplate>
                                         <div class="py-10 text-center">
                                             <svg class="mx-auto h-12 w-12 text-gray-400 dark:text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                                                 <path vector-effect="non-scaling-stroke" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
                                             </svg>
                                             <h3 class="mt-2 text-sm font-semibold text-gray-900 dark:text-white">Sin Productos</h3>
                                             <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Añade tu primer producto usando el formulario de arriba.</p>
                                         </div>
                                     </EmptyDataTemplate>
                                 </asp:GridView>
                             </div>
                         </div>
                     </div>

                    <!-- Summary -->
                    <div class="mt-8 flex justify-end">
                        <div class="w-full max-w-sm space-y-3 rounded-lg bg-background-light p-4 dark:bg-background-dark">
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600 dark:text-gray-300">Subtotal</span>
                                <span class="font-medium text-gray-900 dark:text-white">$142.50</span>
                            </div>
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600 dark:text-gray-300">Impuestos (IVA 21%)</span>
                                <span class="font-medium text-gray-900 dark:text-white">$29.93</span>
                            </div>
                            <div class="flex justify-between border-t border-gray-200 pt-3 text-base font-bold dark:border-gray-700">
                                <span class="text-gray-900 dark:text-white">TOTAL</span>
                                <span class="text-primary dark:text-blue-400">$172.43</span>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </main>

        <!-- Floating Action Footer -->
        <footer class="sticky bottom-0 mt-auto w-full border-t border-gray-200 bg-white/80 py-4 backdrop-blur-sm dark:border-gray-700 dark:bg-background-dark/80">
            <div class="mx-auto flex max-w-4xl justify-end gap-4 px-4 sm:px-6 lg:px-8">
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="rounded-lg border border-gray-300 bg-white px-5 py-2.5 text-sm font-medium text-gray-700 transition-colors hover:bg-gray-50 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600" />
                <asp:Button ID="btnGuardarCompra" runat="server" Text="Guardar Compra" CssClass="rounded-lg bg-primary px-5 py-2.5 text-sm font-medium text-white transition-colors hover:bg-primary/90" />
            </div>
        </footer>
    </div>
</div>
</asp:Content>
