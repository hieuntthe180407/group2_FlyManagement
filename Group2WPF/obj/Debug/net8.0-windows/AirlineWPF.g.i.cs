﻿#pragma checksum "..\..\..\AirlineWPF.xaml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "B9DF51D2EC2FECEA8E54641A94489ABCDFE527A4"
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
    /// AirlineWPF
    /// </summary>
    public partial class AirlineWPF : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 114 "..\..\..\AirlineWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox txtairlineid;
        
        #line default
        #line hidden
        
        
        #line 117 "..\..\..\AirlineWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox txtairlinecode;
        
        #line default
        #line hidden
        
        
        #line 120 "..\..\..\AirlineWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox txtairlinename;
        
        #line default
        #line hidden
        
        
        #line 123 "..\..\..\AirlineWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox txtairlinecountry;
        
        #line default
        #line hidden
        
        
        #line 138 "..\..\..\AirlineWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.DataGrid AirlineDataGrid;
        
        #line default
        #line hidden
        
        
        #line 150 "..\..\..\AirlineWPF.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox txtFilterName;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "8.0.8.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/Group2WPF;component/airlinewpf.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\..\AirlineWPF.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "8.0.8.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            
            #line 8 "..\..\..\AirlineWPF.xaml"
            ((Group2WPF.AirlineWPF)(target)).Loaded += new System.Windows.RoutedEventHandler(this.Airline_Loaded);
            
            #line default
            #line hidden
            return;
            case 2:
            this.txtairlineid = ((System.Windows.Controls.TextBox)(target));
            return;
            case 3:
            this.txtairlinecode = ((System.Windows.Controls.TextBox)(target));
            return;
            case 4:
            this.txtairlinename = ((System.Windows.Controls.TextBox)(target));
            return;
            case 5:
            this.txtairlinecountry = ((System.Windows.Controls.TextBox)(target));
            return;
            case 6:
            
            #line 126 "..\..\..\AirlineWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.AddAirlineButton_Click);
            
            #line default
            #line hidden
            return;
            case 7:
            
            #line 127 "..\..\..\AirlineWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.UpdateAirlineButton_Click);
            
            #line default
            #line hidden
            return;
            case 8:
            
            #line 128 "..\..\..\AirlineWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.DeleteAirlineButton_Click);
            
            #line default
            #line hidden
            return;
            case 9:
            
            #line 129 "..\..\..\AirlineWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.ResetButton_Click);
            
            #line default
            #line hidden
            return;
            case 10:
            
            #line 130 "..\..\..\AirlineWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.CloseButton_Click);
            
            #line default
            #line hidden
            return;
            case 11:
            
            #line 131 "..\..\..\AirlineWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.ExportButton_Click);
            
            #line default
            #line hidden
            return;
            case 12:
            
            #line 132 "..\..\..\AirlineWPF.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.ImportButton_Click);
            
            #line default
            #line hidden
            return;
            case 13:
            this.AirlineDataGrid = ((System.Windows.Controls.DataGrid)(target));
            
            #line 138 "..\..\..\AirlineWPF.xaml"
            this.AirlineDataGrid.SelectionChanged += new System.Windows.Controls.SelectionChangedEventHandler(this.AirlineDataGrid_SelectionChanged);
            
            #line default
            #line hidden
            return;
            case 14:
            this.txtFilterName = ((System.Windows.Controls.TextBox)(target));
            
            #line 150 "..\..\..\AirlineWPF.xaml"
            this.txtFilterName.TextChanged += new System.Windows.Controls.TextChangedEventHandler(this.txtFilterName_TextChanged);
            
            #line default
            #line hidden
            return;
            }
            this._contentLoaded = true;
        }
    }
}

