<%@ Page Title="Gestión de Clientes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClientesForm.aspx.cs" Inherits="Presentacion.ClientesForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server" />

    <div class="min-h-screen w-full bg-slate-50/50 dark:bg-slate-900/50 p-4 sm:p-8">
        
        <div class="max-w-4xl mx-auto">
            
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
                <div>
                    <h1 class="text-3xl font-black text-slate-900 dark:text-white tracking-tight">
                        <asp:Label ID="lblTitulo" runat="server" Text="Nuevo Cliente"></asp:Label>
                    </h1>
                    <p class="text-slate-500 dark:text-slate-400 mt-1">Complete la ficha digital del cliente.</p>
                </div>
                <asp:HyperLink ID="lnkVolver" runat="server" NavigateUrl="~/ClientesListado.aspx" 
                    CssClass="text-sm font-medium text-slate-500 hover:text-primary transition-colors flex items-center gap-1">
                    <span class="material-symbols-outlined text-lg">arrow_back</span> Volver al listado
                </asp:HyperLink>
            </div>

            <asp:UpdatePanel ID="updMensajes" runat="server">
                <ContentTemplate>
                    <div class="mb-6">
                        <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" class="p-4 rounded-lg block border shadow-sm"></asp:Label>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg border border-slate-200 dark:border-slate-700 overflow-hidden">
                
                <div class="p-6 sm:p-8 flex flex-col gap-8">

                    <div>
                        <h2 class="text-lg font-bold text-slate-800 dark:text-white mb-4 flex items-center gap-2 border-b border-slate-100 dark:border-slate-700 pb-2">
                            <span class="material-symbols-outlined text-primary">person</span> Datos Personales
                        </h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            
                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Nombre(s) <span class="text-red-500">*</span></label>
                                <asp:TextBox ID="txtNombre" runat="server" MaxLength="50" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white transition-all" placeholder="Ej: Juan"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNombre" ErrorMessage="El nombre es requerido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Apellido(s) <span class="text-red-500">*</span></label>
                                <asp:TextBox ID="txtApellido" runat="server" MaxLength="50" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white transition-all" placeholder="Ej: Pérez"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtApellido" ErrorMessage="El apellido es requerido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                            <div class="md:col-span-1">
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">DNI / Cédula <span class="text-red-500">*</span></label>
                                <div class="relative">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="material-symbols-outlined text-slate-400 text-[20px]">badge</span>
                                    </div>
                                    <asp:TextBox ID="txtDni" runat="server" TextMode="Number" MaxLength="8" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pl-10 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white transition-all" placeholder="Sin puntos"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDni" ErrorMessage="El DNI es requerido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                                
                                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtDni" ValidationExpression="^\d{7,8}$" ErrorMessage="El DNI debe tener 7 u 8 dígitos." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                        </div>
                    </div>

                    <div>
                        <h2 class="text-lg font-bold text-slate-800 dark:text-white mb-4 flex items-center gap-2 border-b border-slate-100 dark:border-slate-700 pb-2">
                            <span class="material-symbols-outlined text-primary">contact_mail</span> Contacto y Ubicación
                        </h2>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            
                            <div class="md:col-span-1">
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Correo Electrónico <span class="text-red-500">*</span></label>
                                <div class="relative">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="material-symbols-outlined text-slate-400 text-[20px]">mail</span>
                                    </div>
                                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" MaxLength="100" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pl-10 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white transition-all" placeholder="ejemplo@mail.com"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ErrorMessage="El email es requerido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="Email inválido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                            <div class="md:col-span-1">
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Teléfono <span class="text-red-500">*</span></label>
                                <div class="relative">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="material-symbols-outlined text-slate-400 text-[20px]">call</span>
                                    </div>
                                    <asp:TextBox ID="txtTelefono" runat="server" TextMode="Phone" MaxLength="15" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pl-10 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white transition-all" placeholder="Cod. Área + Número"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTelefono" ErrorMessage="Requerido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                                
                                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtTelefono" ValidationExpression="^\d{8,15}$" ErrorMessage="Ingrese un teléfono válido (mín 8 núm)." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                            <div class="md:col-span-2 grid grid-cols-1 sm:grid-cols-3 gap-4">
                                <div class="sm:col-span-2">
                                    <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Calle <span class="text-red-500">*</span></label>
                                    <div class="relative">
                                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                            <span class="material-symbols-outlined text-slate-400 text-[20px]">home</span>
                                        </div>
                                        <asp:TextBox ID="txtDireccion" runat="server" MaxLength="100" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pl-10 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white transition-all" placeholder="Nombre de la calle"></asp:TextBox>
                                    </div>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDireccion" ErrorMessage="La calle es requerida." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                                </div>

                                <div class="sm:col-span-1">
                                    <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Altura <span class="text-red-500">*</span></label>
                                    <div class="relative">
                                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                            <span class="material-symbols-outlined text-slate-400 text-[20px]">tag</span>
                                        </div>
                                        <asp:TextBox ID="txtAltura" runat="server" TextMode="Number" MaxLength="5" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pl-10 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white transition-all" placeholder="123"></asp:TextBox>
                                    </div>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAltura" ErrorMessage="Requerido." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                                    <asp:RangeValidator runat="server" ControlToValidate="txtAltura" MinimumValue="1" MaximumValue="99999" Type="Integer" ErrorMessage="Altura inválida." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                                </div>
                            </div>

                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Localidad / Ciudad <span class="text-red-500">*</span></label>
                                <div class="relative">
                                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                        <span class="material-symbols-outlined text-slate-400 text-[20px]">location_on</span>
                                    </div>
                                    <asp:TextBox ID="txtLocalidad" runat="server" MaxLength="100" CssClass="form-input w-full rounded-lg border-slate-300 bg-slate-50 pl-10 focus:bg-white focus:ring-primary focus:border-primary dark:bg-slate-900/50 dark:border-slate-600 dark:text-white transition-all" placeholder="Ej: San Fernando"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLocalidad" ErrorMessage="La localidad es requerida." CssClass="text-red-500 text-xs font-semibold mt-1 block" Display="Dynamic" />
                            </div>

                        </div>
                    </div>

                </div>

                <div class="bg-slate-50 dark:bg-slate-800/50 px-6 py-4 border-t border-slate-200 dark:border-slate-700 flex justify-end gap-3">
                    <asp:HyperLink ID="btnCancelar" runat="server" NavigateUrl="~/ClientesListado.aspx"
                        CssClass="rounded-xl border border-slate-300 bg-white px-5 py-2.5 text-sm font-bold text-slate-700 hover:bg-slate-50 hover:text-slate-800 transition-all dark:border-slate-600 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">
                        Cancelar
                    </asp:HyperLink>

                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar Cliente" OnClick="btnGuardar_Click"
                        CssClass="rounded-xl bg-primary px-6 py-2.5 text-sm font-bold text-white shadow-lg shadow-primary/30 hover:bg-primary/90 hover:scale-[1.02] active:scale-95 transition-all cursor-pointer" />
                </div>

            </div>
        </div>
    </div>
</asp:Content>