using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using AXOpen.Base.Data;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Data;
using System.Runtime.CompilerServices;
using Microsoft.AspNetCore.Components;
using System.Threading.Channels;

namespace AXOpen.Data.ViewModels
{
    public class AxoDataViewModelCreator : ObservableObject
    {
        public static AxoDataViewModel<T, O> Create<T, O>(IRepository<T> repository, AxoDataExchange dataExchange) where T : IBrowsableDataObject, new()
            where O : class
        {
            return new AxoDataViewModel<T, O>(repository, dataExchange);
        }
    }
}
