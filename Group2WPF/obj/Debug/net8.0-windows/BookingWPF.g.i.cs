﻿#pragma checksum "..\..\..\BookingWPF.xaml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "870E4E0A4BB7FB5C881004C651FD8EBF6E3B7F88"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using Group2WPF;
using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Controls.Ribbon;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Shell;


namespace Group2WPF {
    
    
    /// <summary>
    /// BookingWPF
    /// </summary>
    public partial class BookingWPF : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 12 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.DataGrid dgData;
        
        #line default
        #line hidden
        
        
        #line 13 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox txtId;
        
        #line default
        #line hidden
        
        
        #line 19 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox txtBookingTime;
        
        #line default
        #line hidden
        
        
        #line 31 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox filterPID;
        
        #line default
        #line hidden
        
        
        #line 32 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox filterFID;
        
        #line default
        #line hidden
        
        
        #line 33 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox filterBPID;
        
        #line default
        #line hidden
        
        
        #line 34 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox cboPassenger;
        
        #line default
        #line hidden
        
        
        #line 35 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox cboFlight;
        
        #line default
        #line hidden
        
        
        #line 36 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox cboBookingPlatform;
        
        #line default
        #line hidden
        
        
        #line 37 "..\..\..\BookingWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox datePicker;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "8.0.10.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/Group2WPF;V1.0.0.0;component/bookingwpf.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\..\BookingWPF.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "8.0.10.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            
            #line 8 "..\..\..\BookingWPF.xaml"
            ((Group2WPF.BookingWPF)(target)).Loaded += new System.Windows.RoutedEventHandler(this.Window_Loaded);
            
            #line default
            #line hidden
            return;
            case 2:
            this.dgData = ((System.Windows.Controls.DataGrid)(target));
            
            #line 12 "..\..\..\BookingWPF.xaml"
            this.dgData.SelectionChanged += new System.Windows.Controls.SelectionChangedEventHandler(this.dgData_SelectionChanged);
            
            #line default
            #line hidden
            return;
            case 3:
            this.txtId = ((System.Windows.Controls.TextBox)(target));
            return;
            case 4:
            this.txtBookingTime = ((System.Windows.Controls.TextBox)(target));
            return;
            case 5:
            
            #line 22 "..\..\..\BookingWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.ButtonAdd_Click);
            
            #line default
            #line hidden
            return;
            case 6:
            
            #line 23 "..\..\..\BookingWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.ButtonUpdate_Click);
            
            #line default
            #line hidden
            return;
            case 7:
            
            #line 24 "..\..\..\BookingWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.ButtonDelete_Click);
            
            #line default
            #line hidden
            return;
            case 8:
            
            #line 25 "..\..\..\BookingWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.ButtonClose_Click);
            
            #line default
            #line hidden
            return;
            case 9:
            this.filterPID = ((System.Windows.Controls.TextBox)(target));
            
            #line 31 "..\..\..\BookingWPF.xaml"
            this.filterPID.TextChanged += new System.Windows.Controls.TextChangedEventHandler(this.filter_PassengerID);
            
            #line default
            #line hidden
            return;
            case 10:
            this.filterFID = ((System.Windows.Controls.TextBox)(target));
            
            #line 32 "..\..\..\BookingWPF.xaml"
            this.filterFID.TextChanged += new System.Windows.Controls.TextChangedEventHandler(this.filter_FlightID);
            
            #line default
            #line hidden
            return;
            case 11:
            this.filterBPID = ((System.Windows.Controls.TextBox)(target));
            
            #line 33 "..\..\..\BookingWPF.xaml"
            this.filterBPID.TextChanged += new System.Windows.Controls.TextChangedEventHandler(this.filter_BookingPlatformID);
            
            #line default
            #line hidden
            return;
            case 12:
            this.cboPassenger = ((System.Windows.Controls.ComboBox)(target));
            return;
            case 13:
            this.cboFlight = ((System.Windows.Controls.ComboBox)(target));
            return;
            case 14:
            this.cboBookingPlatform = ((System.Windows.Controls.ComboBox)(target));
            return;
            case 15:
            this.datePicker = ((System.Windows.Controls.TextBox)(target));
            
            #line 37 "..\..\..\BookingWPF.xaml"
            this.datePicker.TextChanged += new System.Windows.Controls.TextChangedEventHandler(this.datePicker_TextChanged);
            
            #line default
            #line hidden
            return;
            }
            this._contentLoaded = true;
        }
    }
}

